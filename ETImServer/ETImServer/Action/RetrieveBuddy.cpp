
//
//  RetrieveBuddy.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "RetrieveBuddy.h"
#include "OutStream.h"
#include "InStream.h"
#include "MD5.h"
#include "Idea.h"
#include "Logging.h"
#include "DataService.h"
#include "DataStruct.h"

#include <sstream>
#include <iomanip>

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;

void RetrieveBuddyList::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    if (cmd == CMD_UNREAD) {
        cmd = CMD_RETRIEVE_BUDDY_LIST;
    }
    
	// 好友请求
	string username;
	jis>>username;
	
	int16 error_code = kErrCode000;
	char error_msg[31] = {0};
    
    
	// 实际的添加操作
	DataService dao;
    list<IMUser> buddys;
	int ret;
	ret = dao.RetrieveBuddyList(username, buddys);
	if (ret == kErrCode000) {
		LOG_INFO<<"获取好友列表成功"<<username;
        uint16 cnt = static_cast<uint16>(buddys.size());    //总共多少
		uint16 seq = 0;                                     //序列号
        list<IMUser>::const_iterator it;
        for (it = buddys.begin(); it != buddys.end(); ++it) {
            OutStream jos;
            // 包头命令
            jos<<cmd;
            size_t lengthPos = jos.Length();
            jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
            // 包头cnt、seq、error_code、error_msg

            jos<<cnt<<seq<<error_code;
            seq++;
            jos.WriteBytes(error_msg, 30);
            
            // 包体
            stringstream ss;
            ss<<setw(6)<<setfill('0')<<it->userId;
            jos.WriteBytes(ss.str().c_str(), 6);
            jos<<it->username;
            jos<<it->regDate;
            jos<<it->signature;
            jos<<it->gender;
            jos<<it->relation;
            jos<<it->status;
            
            FillOutPackage(jos, lengthPos, cmd);
            
            s->Send(jos.Data(), jos.Length());
        }
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_ERROR<<error_msg;
        
        OutStream jos;
        // 包头命令
        jos<<cmd;
        size_t lengthPos = jos.Length();
        jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
        // 包头cnt、seq、error_code、error_msg
        uint16 cnt = 0;
        uint16 seq = 0;
        jos<<cnt<<seq<<error_code;
        jos.WriteBytes(error_msg, 30);
        
        // 空包体
        
        FillOutPackage(jos, lengthPos, cmd);
        
        s->Send(jos.Data(), jos.Length());
	}
}


void RetrieveBuddyRequest::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    if (cmd == CMD_UNREAD) {
        cmd = CMD_RETRIEVE_BUDDY_REQUEST;
    }
    
	// 登录名
	string username;
	jis>>username;
	
    int16 error_code = kErrCode000;
	char error_msg[31] = {0};
	//TODO 用户请求 查询用户请求信息
	DataService dao;
	int ret = kErrCode000;
    //ret = dao.UserLogout(username, s);
	if (ret == kErrCode000) {
		LOG_INFO<<"查询好友请求成功";
	} else  {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_INFO<<error_msg;
	}
    
	OutStream jos;
	// 包头命令
	jos<<cmd;
	size_t lengthPos = jos.Length();
	jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
	// 包头cnt、seq、error_code、error_msg
	uint16 cnt = 0;
	uint16 seq = 0;
	jos<<cnt<<seq<<error_code;
	jos.WriteBytes(error_msg, 30);
    
	// 空包体

    FillOutPackage(jos, lengthPos, cmd);
    
	s->Send(jos.Data(), jos.Length());
}
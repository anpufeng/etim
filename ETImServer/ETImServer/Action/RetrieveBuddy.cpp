
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
	string userId;
	jis>>userId;
	
	int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    
    
	// 实际的添加操作
	DataService dao;
    list<IMUser> buddys;
	int ret;
	ret = dao.RetrieveBuddyList(userId, false, true, buddys);
	if (ret == kErrCode00) {
		LOG_INFO<<"查询好友列表成功 userid: "<<userId <<" 好友数: "<<buddys.size();
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
            jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
            
            // 包体
            jos<<it->userId;
            jos<<it->username;
            jos<<it->regDate;
            jos<<it->signature;
            jos<<it->gender;
            jos<<it->relation;
            jos<<it->status;
            jos<<it->statusName;
            
            FillOutPackage(jos, lengthPos, cmd);
            
            s->Send(jos.Data(), jos.Length());
        }
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_INFO<<"查询好友列表失败: "<<error_msg<<" userId: "<<userId;
        
        OutStream jos;
        // 包头命令
        jos<<cmd;
        size_t lengthPos = jos.Length();
        jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
        // 包头cnt、seq、error_code、error_msg
        uint16 cnt = 0;
        uint16 seq = 0;
        jos<<cnt<<seq<<error_code;
        jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
        
        // 空包体
        
        FillOutPackage(jos, lengthPos, cmd);
        
        s->Send(jos.Data(), jos.Length());
	}
}


void RetrievePendingBuddyRequest::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    if (cmd == CMD_UNREAD) {
        cmd = CMD_RETRIEVE_PENDING_BUDDY_REQUEST;
    }
    
	string userId;
	jis>>userId;
	
    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
	// 实际的用户请求获取操作
	DataService dao;
    list<IMUser> reqBuddys;
	int ret;
	ret = dao.RetrievePendingBuddyRequest(userId, reqBuddys);
	if (ret == kErrCode00) {
		LOG_INFO<<"查询待处理好友请求数成功 userid: "<<userId <<" 好友请求数: "<<reqBuddys.size();
        uint16 cnt = static_cast<uint16>(reqBuddys.size());    //总共多少
		uint16 seq = 0;                                     //序列号
        list<IMUser>::const_iterator it;
        for (it = reqBuddys.begin(); it != reqBuddys.end(); ++it) {
            OutStream jos;
            // 包头命令
            jos<<cmd;
            size_t lengthPos = jos.Length();
            jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
            // 包头cnt、seq、error_code、error_msg
            
            jos<<cnt<<seq<<error_code;
            seq++;
            jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
            
            // 包体
            jos<<it->userId;
            jos<<it->username;
            jos<<it->regDate;
            jos<<it->signature;
            jos<<it->gender;
            jos<<it->relation;
            jos<<it->status;
            jos<<it->statusName;
            
            FillOutPackage(jos, lengthPos, cmd);
            
            s->Send(jos.Data(), jos.Length());
        }
        //TODO 发送后更新request状态
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_INFO<<"查询好友请求列表失败: "<<error_msg<<" userId: "<<userId;
        
        OutStream jos;
        // 包头命令
        jos<<cmd;
        size_t lengthPos = jos.Length();
        jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
        // 包头cnt、seq、error_code、error_msg
        uint16 cnt = 0;
        uint16 seq = 0;
        jos<<cnt<<seq<<error_code;
        jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
        
        // 空包体
        
        FillOutPackage(jos, lengthPos, cmd);
        
        s->Send(jos.Data(), jos.Length());
	}
}

void RetrieveAllBuddyRequest::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    if (cmd == CMD_UNREAD) {
        cmd = CMD_RETRIEVE_ALL_BUDDY_REQUEST;
    }
    
	string userId;
	jis>>userId;
	
    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
	// 实际的用户请求获取操作
	DataService dao;
    list<IMReq> reqs;
	int ret;
	ret = dao.RetrieveAllBuddyRequest(userId, reqs);
	if (ret == kErrCode00) {
		LOG_INFO<<"查询好友请求历史记录成功 userid: "<<userId <<" 请求历史记录数: "<<reqs.size();
        uint16 cnt = static_cast<uint16>(reqs.size());    //总共多少
		uint16 seq = 0;                                     //序列号
        list<IMReq>::const_iterator it;
        for (it = reqs.begin(); it != reqs.end(); ++it) {
            OutStream jos;
            // 包头命令
            jos<<cmd;
            size_t lengthPos = jos.Length();
            jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
            // 包头cnt、seq、error_code、error_msg
            
            jos<<cnt<<seq<<error_code;
            seq++;
            jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
            // 包体
            jos<<it->reqId;
            jos<<it->from.userId;
            jos<<it->from.username;
            jos<<it->from.regDate;
            jos<<it->from.signature;
            jos<<it->from.gender;
            jos<<it->from.relation;
            jos<<it->from.status;
            jos<<it->from.statusName;
            jos<<it->status;
            jos<<it->reqTime;
            jos<<it->reqSendTime;
            jos<<it->actionTime;
            jos<<it->actionSendTime;
            
            FillOutPackage(jos, lengthPos, cmd);
            
            s->Send(jos.Data(), jos.Length());
        }
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_INFO<<"查询好友所有请求列表失败: "<<error_msg<<" userId: "<<userId;
        
        OutStream jos;
        // 包头命令
        jos<<cmd;
        size_t lengthPos = jos.Length();
        jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
        // 包头cnt、seq、error_code、error_msg
        uint16 cnt = 0;
        uint16 seq = 0;
        jos<<cnt<<seq<<error_code;
        jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
        
        // 空包体
        
        FillOutPackage(jos, lengthPos, cmd);
        
        s->Send(jos.Data(), jos.Length());
	}
}
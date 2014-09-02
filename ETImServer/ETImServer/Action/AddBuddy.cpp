//
//  AddBuddy.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "AddBuddy.h"
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

void RequestAddBuddy::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	// 好友请求
	string fromName;
    string toName;
    jis>>fromName;
	jis>>toName;
	
	int16 error_code = kErrCode000;
	char error_msg[31] = {0};
    
    
	// 实际的添加操作
	DataService dao;
	int ret;
	ret = dao.RequestAddBuddy(fromName, toName);
	if (ret == kErrCode000) {
        strcpy(error_msg, "请求发送成功");
		LOG_INFO<<"添加好友请求成功";
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_ERROR<<error_msg;
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
    //TODO 如果用户在线要将请求信息发送给用户  (直接遍历vector, 此效率待改进)
}



void SearchBuddy::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	// 搜索名
	string name;
	jis>>name;
	
	int16 error_code = kErrCode000;
	char error_msg[31] = {0};
    
    
	// 实际的搜索操作
	DataService dao;
    IMUser user;
    user.username = name;
	int ret;
	ret = dao.UserSearch(name, s, user);
	if (ret == kErrCode000) {
		LOG_INFO<<"登录成功";
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_ERROR<<error_msg;
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
    
	// 包体
    jos<<user.userId;
	jos<<user.username;
    jos<<user.regDate;
    jos<<user.signature;
    jos<<user.gender;
    jos<<user.relation;
    jos<<user.status;
    
    FillOutPackage(jos, lengthPos, cmd);
    
	s->Send(jos.Data(), jos.Length());
}
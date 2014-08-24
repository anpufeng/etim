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

void AddBuddy::Execute(Session *s) {
    
}



void SearchBuddy::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
    MD5 md5;
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
	} else if (ret == kErrCode004) {
		error_code = kErrCode004;
		strcpy(error_msg, gErrMsg[kErrCode004].c_str());
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
    
	// 包体
    stringstream ss;
	ss<<setw(6)<<setfill('0')<<user.userId;
	jos.WriteBytes(ss.str().c_str(), 6);
	jos<<user.username;
    jos<<user.regDate;
    jos<<user.signature;
    jos<<user.gender;
    jos<<user.relation;
    jos<<user.status;
    
	// 包头len
	size_t tailPos = jos.Length();
	jos.Reposition(lengthPos);
	jos<<static_cast<uint16>(tailPos + 8 - sizeof(ResponseHead)); // 包体长度 + 包尾长度
    
	// 包尾
	jos.Reposition(tailPos);
	// 计算包尾
	unsigned char hash[16];
	md5.MD5Make(hash, (const unsigned char*)jos.Data(), jos.Length());
	for (int i=0; i<8; ++i) {
		hash[i] = hash[i] ^ hash[i+8];
		hash[i] = hash[i] ^ ((cmd >> (i%2)) & 0xff);
	}
	jos.WriteBytes(hash, 8);
    
	s->Send(jos.Data(), jos.Length());
}
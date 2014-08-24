//
//  AddBuddy.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "AddBuddy.h"
#include "InStream.h"
#include "OutStream.h"
#include "MD5.h"
#include "Idea.h"
#include "DataStruct.h"

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

void AddBuddy::Execute(Session& s) {
    
}


void SearchBuddy::Execute(Session &s) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_SEARCH_BUDDY;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 要查找的用户名
	string name = s.GetAttribute("name");
	jos<<name;
    
    MD5 md5;
    
	// 包头len
	size_t tailPos = jos.Length();
	jos.Reposition(lengthPos);
	jos<<static_cast<uint16>(tailPos + 8 - sizeof(RequestHead)); // 包体长度 + 包尾长度
    
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
    
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
	s.Recv();	// 接收应答包
	InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
	// 跳过cmd、len
	jis.Skip(4);
	uint16 cnt;
	uint16 seq;
	int16 error_code;
	jis>>cnt>>seq>>error_code;
    
	char error_msg[31];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
    IMUser user;
    int rel;
    char userId[7] = {0};
    jis.ReadBytes(userId, 6);
    jis>>user.username;
    jis>>user.regDate;
    jis>>user.signature;
    jis>>user.gender;
    jis>>rel;
    jis>>user.status;
    user.userId = userId;
    user.relation = (BuddyRelation)rel;
    
    s.SetSearchIMUser(user);
	s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}
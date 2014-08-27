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

#include <algorithm>

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

void RequestAddBuddy::DoSend(Session& s) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_REQUEST_ADD_BUDDY;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 要查找的用户名
	string fromName = s.GetAttribute("friend_from");
    string toName = s.GetAttribute("friend_to");
    transform(fromName.begin(), fromName.end(), fromName.begin(), ::tolower);
    transform(toName.begin(), toName.end(), toName.begin(), ::tolower);
	jos<<fromName;
    jos<<toName;
    
    FillOutPackage(jos, lengthPos, cmd);
    
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
    
 	s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}

void RequestAddBuddy::DoRecv(etim::Session &s) {
    
}


void SearchBuddy::DoSend(Session &s) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_SEARCH_BUDDY;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 要查找的用户名
	string name = s.GetAttribute("name");
    transform(name.begin(),name.end(), name.begin(), ::tolower);
	jos<<name;

	FillOutPackage(jos, lengthPos, cmd);
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}

void SearchBuddy::DoRecv(etim::Session &s) {
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
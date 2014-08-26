
//
//  Login.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Login.h"
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

void Login::Execute(Session& s) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_LOGIN;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 登录名
	string name = s.GetAttribute("name");
    transform(name.begin(),name.end(), name.begin(), ::tolower);
	jos<<name;
    
	// 密码
	string pass = s.GetAttribute("pass");
	unsigned char ideaKey[16];
	unsigned char buf[2];
	buf[0] = (cmd >> 8) & 0xff;
	buf[1] = cmd & 0xff;
	MD5 md5;
	md5.MD5Make(ideaKey, buf, 2);
	for (int i=0; i<8; ++i)
	{
		ideaKey[i] = ideaKey[i] ^ ideaKey[i+8];
		ideaKey[i] = ideaKey[i] ^ ((cmd >> (i%2)) & 0xff);
		ideaKey[i+8] = ideaKey[i] ^ ideaKey[i+8];
		ideaKey[i+8] = ideaKey[i+8] ^ ((cmd >> (i%2)) & 0xff);
	}
	char encryptedPass[16];
	Idea idea;
	// 加密
	idea.Crypt(ideaKey,(const unsigned char*)pass.c_str(), (unsigned char *)encryptedPass, 16, true);
	jos.WriteBytes(encryptedPass, 16);
    
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
    
    s.SetIMUser(user);
	s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}

void Logout::Execute(Session& s) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_LOGOUT;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 用户id
	string name = s.GetAttribute("name");
	jos<<name;
    
	FillOutPackage(jos, lengthPos, cmd);;
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
	s.Recv();	// 接收应答包
	InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
	// 跳过cmd、len
	jis.Skip(4);
	uint16 cnt;
	uint16 seq;
	int16 error_code;
	jis>>cnt>>seq>>error_code;
    
	char error_msg[ERR_MSG_LENGTH + 1];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
	s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}


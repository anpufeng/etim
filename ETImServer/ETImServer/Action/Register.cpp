//
//  Register.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Register.h"
#include "OutStream.h"
#include "InStream.h"
#include "MD5.h"
#include "Idea.h"
#include "DataService.h"
#include "Logging.h"
#include "Session.h"

#include <string>

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;


void Register::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	// 注册名
	string name;
	jis>>name;
	// 密码
	char pass[16];
	unsigned char ideaKey[16];
	unsigned char buf[2];
	buf[0] = (cmd >> 8) & 0xff;
	buf[1] = cmd & 0xff;
	MD5 md5;
	md5.MD5Make(ideaKey, buf, 2);
	for (int i=0; i<8; ++i) {
		ideaKey[i] = ideaKey[i] ^ ideaKey[i+8];
		ideaKey[i] = ideaKey[i] ^ ((cmd >> (i%2)) & 0xff);
		ideaKey[i+8] = ideaKey[i] ^ ideaKey[i+8];
		ideaKey[i+8] = ideaKey[i+8] ^ ((cmd >> (i%2)) & 0xff);
	}
	char encryptedPass[16];
	jis.ReadBytes(encryptedPass, 16);
	Idea idea;
	// 解密
	idea.Crypt(ideaKey, (const unsigned char*)encryptedPass, (unsigned char *)pass, 16, false);
    
	int16 error_code = kErrCode000;
	char error_msg[31] = {0};
    
    

     // 实际的注册操作
    DataService dao;
     int ret;
     ret = dao.UserRegister(name, pass);
     if (ret == kErrCode000) {
         LOG_INFO<<"注册成功 用户名: "<<name;
     } else {
         error_code = ret;
         assert(error_code < kErrCodeMax);
         strcpy(error_msg, gErrMsg[error_code].c_str());
         LOG_INFO<<error_msg;
     }
    
	OutStream jos;
	// 包头命令
	jos<<cmd;
	size_t lengthPos = jos.Length();
	jos.Skip(2);
	// 包头cnt、seq、error_code、error_msg
	uint16 cnt = 0;
	uint16 seq = 0;
	jos<<cnt<<seq<<error_code;
	jos.WriteBytes(error_msg, 30);
	// 包体为空
    
    FillOutPackage(jos, lengthPos, cmd);
    
	s->Send(jos.Data(), jos.Length());
}
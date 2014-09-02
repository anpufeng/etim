//
//  SendMsg.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "SendMsg.h"
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

using namespace etim;
using namespace etim::action;


void SendMsg::Execute(Session *s) {
    
}



void RetrieveUnreadMsg::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    if (cmd == CMD_UNREAD) {
        cmd = CMD_RETRIEVE_UNREAD_MSG;
    }
    
	// 登录名
	string username;
	jis>>username;
	
    int16 error_code = kErrCode000;
	char error_msg[31] = {0};
	//TODO 获取未读消息 查询数据库未读消息并send
	DataService dao;
	int ret = kErrCode000;
    //ret = dao.UserLogout(username, s);
	if (ret == kErrCode000) {
		LOG_INFO<<"查询未读消息成功: "<<username;
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
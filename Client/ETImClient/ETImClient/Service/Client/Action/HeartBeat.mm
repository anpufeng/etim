//
//  HeartBeat.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "HeartBeat.h"
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


void HeartBeat::DoSend(Session& s, sendarg arg) {
    OutStream jos;
	// 包头命令
	uint16 cmd = CMD_HEART_BEAT;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	string userId = arg["userId"];

    jos<<userId;
    
	FillOutPackage(jos, lengthPos, cmd);
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}


void HeartBeat::DoRecv(etim::Session &s) {
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
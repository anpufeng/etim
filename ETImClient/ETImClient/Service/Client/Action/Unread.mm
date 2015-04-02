//
//  Unread.cpp
//  ETImClient
//
//  Created by Ethan on 14/9/1.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Unread.h"
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


void Unread::DoSend(Session& s, sendarg arg) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_UNREAD;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 用户id
	string name = arg["userId"];
	jos<<name;
    
	FillOutPackage(jos, lengthPos, cmd);;
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}

void Unread::DoRecv(etim::Session &s) {
	
}
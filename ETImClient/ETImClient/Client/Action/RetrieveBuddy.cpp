
//
//  RetrieveBuddy.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "RetrieveBuddy.h"
#include "InStream.h"
#include "OutStream.h"
#include "MD5.h"
#include "Idea.h"
#include "DataStruct.h"

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

void RetrieveBuddyList::DoSend(Session& s) {
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


void RetrieveBuddyList::DoRecv(etim::Session &s) {
    
}


void RetrieveBuddyRequest::DoSend(Session& s) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_RETRIEVE_BUDDY_REQUEST;
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


void RetrieveBuddyRequest::DoRecv(etim::Session &s) {
    
}
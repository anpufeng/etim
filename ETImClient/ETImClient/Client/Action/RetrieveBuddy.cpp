
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
	uint16 cmd = CMD_RETRIEVE_BUDDY_LIST;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 要查找的用户名
	string name = s.GetAttribute("userId");
    transform(name.begin(),name.end(), name.begin(), ::tolower);
	jos<<name;
    
	FillOutPackage(jos, lengthPos, cmd);
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}


void RetrieveBuddyList::DoRecv(etim::Session &s) {
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
    
    if (error_code == kErrCode000) {
        s.ClearBuddys();
        
        for (uint16 i = 0; i < cnt; ++i) {
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
            jis>>user.userId;
            jis>>user.username;
            jis>>user.regDate;
            jis>>user.signature;
            jis>>user.gender;
            jis>>rel;
            jis>>user.status;
            user.relation = (BuddyRelation)rel;
            s.AddBuddy(user);
            
            if (seq == cnt - 1)
                break;
            s.Recv();
        }
    }
   

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
	string name = s.GetAttribute("userId");
    transform(name.begin(),name.end(), name.begin(), ::tolower);
	jos<<name;
    
	FillOutPackage(jos, lengthPos, cmd);
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}


void RetrieveBuddyRequest::DoRecv(etim::Session &s) {
    
}
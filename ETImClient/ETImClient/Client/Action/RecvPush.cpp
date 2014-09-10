//
//  RecvPush.cpp
//  ETImClient
//
//  Created by Ethan on 14/9/10.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "RecvPush.h"
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

void PushBuddyUpdate::DoSend(Session& s) {
    //empty
}

void PushBuddyUpdate::DoRecv(etim::Session &s) {
	InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
	// 跳过cmd、len
	jis.Skip(4);
	uint16 cnt;
	uint16 seq;
	int16 error_code;
	jis>>cnt>>seq>>error_code;
    
	char error_msg[ERR_MSG_LENGTH+1];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
    
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
    
    if (error_code == kErrCode00) {
        IMUser user;
        int rel;
        int status;
        jis>>user.userId;
        jis>>user.username;
        jis>>user.regDate;
        jis>>user.signature;
        jis>>user.gender;
        jis>>rel;
        jis>>status;
        jis>>user.statusName;
        
        user.relation = static_cast<BuddyRelation>(rel);
        user.status = static_cast<BuddyStatus>(status);
        
        s.SetStatusChangedBuddy(user);
    }
}


void PushBuddyRequest::DoSend(Session& s) {
    //empty
}

void PushBuddyRequest::DoRecv(etim::Session &s) {
	InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
	// 跳过cmd、len
	jis.Skip(4);
	uint16 cnt;
	uint16 seq;
	int16 error_code;
	jis>>cnt>>seq>>error_code;
    
	char error_msg[ERR_MSG_LENGTH+1];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
    
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
    
    if (error_code == kErrCode00) {
        IMUser user;
        int rel;
        int status;
        int accept;
        int peer;
        jis>>user.userId;
        jis>>user.username;
        jis>>user.regDate;
        jis>>user.signature;
        jis>>user.gender;
        jis>>rel;
        jis>>status;
        jis>>user.statusName;
        jis>>accept;
        jis>>peer;
        
        user.relation = static_cast<BuddyRelation>(rel);
        user.status = static_cast<BuddyStatus>(status);
        //TODO 更新请求通知 如果接受还要更新好友列表
    }
}

void PushRequestAddBuddy::DoSend(Session& s) {
    //empty
}

void PushRequestAddBuddy::DoRecv(etim::Session &s) {
	InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
	// 跳过cmd、len
	jis.Skip(4);
	uint16 cnt;
	uint16 seq;
	int16 error_code;
	jis>>cnt>>seq>>error_code;
    
	char error_msg[ERR_MSG_LENGTH+1];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
    
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
    
    if (error_code == kErrCode00) {
        IMUser user;
        int rel;
        int status;
        jis>>user.userId;
        jis>>user.username;
        jis>>user.regDate;
        jis>>user.signature;
        jis>>user.gender;
        jis>>rel;
        jis>>status;
        jis>>user.statusName;
        
        user.relation = static_cast<BuddyRelation>(rel);
        user.status = static_cast<BuddyStatus>(status);
        s.ClearReqBuddys();
        s.AddReqBuddy(user);
    }
}
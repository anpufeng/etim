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

#import "BuddyModel.h"
#import "MsgModel.h"
#import "ReceivedManager.h"

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

void PushBuddyUpdate::DoSend(Session& s, sendarg arg) {
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
    
    if (error_code == kErrCode00) {
        IMUser user;
        int rel;
        int status;
        jis>>user.userId;
        jis>>user.username;
        jis>>user.regTime;
        jis>>user.signature;
        jis>>user.gender;
        jis>>rel;
        jis>>status;
        jis>>user.statusName;
        
        user.relation = static_cast<BuddyRelation>(rel);
        user.status = static_cast<BuddyStatus>(status);
        BuddyModel *buddy = [[BuddyModel alloc] initWithUser:user];
        [[ReceivedManager sharedInstance] setStatusChangedBuddy:buddy];
    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}


void PushBuddyRequestResult::DoSend(Session& s, sendarg arg) {
    //empty
}

void PushBuddyRequestResult::DoRecv(etim::Session &s) {
	InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
	// 跳过cmd、len
	jis.Skip(4);
	uint16 cnt;
	uint16 seq;
	int16 error_code;
	jis>>cnt>>seq>>error_code;
    
	char error_msg[ERR_MSG_LENGTH+1];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
    if (error_code == kErrCode00) {
        IMUser user;
        int rel;
        int status;
        int accept;
        int peer;
        jis>>user.userId;
        jis>>user.username;
        jis>>user.regTime;
        jis>>user.signature;
        jis>>user.gender;
        jis>>rel;
        jis>>status;
        jis>>user.statusName;
        jis>>accept;
        jis>>peer;
        
        user.relation = static_cast<BuddyRelation>(rel);
        user.status = static_cast<BuddyStatus>(status);
        if (accept) {
            //如果同意则将用户关系轩为好友并添加到好友列表
            user.relation = kBuddyRelationFriend;
            
            BuddyModel *buddy = [[BuddyModel alloc] initWithUser:user];
            [[[ReceivedManager sharedInstance] buddyArr] addObject:buddy];
            
        }
    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}

void PushRequestAddBuddy::DoSend(Session& s, sendarg arg) {
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
    
    if (error_code == kErrCode00) {
        IMUser user;
        int rel;
        int status;
        jis>>user.userId;
        jis>>user.username;
        jis>>user.regTime;
        jis>>user.signature;
        jis>>user.gender;
        jis>>rel;
        jis>>status;
        jis>>user.statusName;
        
        user.relation = static_cast<BuddyRelation>(rel);
        user.status = static_cast<BuddyStatus>(status);
        //清空并新加一个通知对象, 同时去重
        BuddyModel *buddy = [[BuddyModel alloc] initWithUser:user];
        [[ReceivedManager sharedInstance] setRequestingBuddy:buddy];
    }
    
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}


void PushSendMsg::DoSend(Session& s, sendarg arg) {
    //empty
}

void PushSendMsg::DoRecv(etim::Session &s) {
	InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
	// 跳过cmd、len
	jis.Skip(4);
	uint16 cnt;
	uint16 seq;
	int16 error_code;
	jis>>cnt>>seq>>error_code;
    
	char error_msg[ERR_MSG_LENGTH+1];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
    if (error_code == kErrCode00) {
        IMMsg msg;
        jis>>msg.msgId;
        jis>>msg.fromId;
        jis>>msg.fromName;
        jis>>msg.toId;
        jis>>msg.toName;
        jis>>msg.text;
        jis>>msg.sent;
        jis>>msg.requestTime;
        jis>>msg.sendTime;
        
        MsgModel *message = [[MsgModel alloc] initWithMsg:msg];
        [[ReceivedManager sharedInstance] setReceivedMsg:message];
    }
    
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}
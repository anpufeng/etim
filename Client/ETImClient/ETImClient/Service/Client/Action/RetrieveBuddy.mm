
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

#import "ReceivedManager.h"
#import "BuddyModel.h"
#import "RequestModel.h"

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

void RetrieveBuddyList::DoSend(Session& s, sendarg arg) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_RETRIEVE_BUDDY_LIST;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);

	string userId = arg["userId"];
	jos<<userId;
    
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
    
	char error_msg[ERR_MSG_LENGTH+1];
	jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
    
    if (error_code == kErrCode00) {
        NSMutableArray *buddyArr = [NSMutableArray array];
        
        for (uint16 i = 0; i < cnt; ++i) {
            InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
            // 跳过cmd、len
            jis.Skip(4);
            uint16 cnt;
            uint16 seq;
            int16 error_code;
            jis>>cnt>>seq>>error_code;
            char error_msg[ERR_MSG_LENGTH+1];
            jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
            
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
            
            [buddyArr addObject:[[BuddyModel alloc] initWithUser:user]];
            
            if (seq == cnt - 1)
                break;
            s.Recv();
        }
        
        if ([buddyArr count]) {
            [[ReceivedManager sharedInstance] setBuddyArr:buddyArr];
        }
        
    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}


void RetrievePendingBuddyRequest::DoSend(Session& s, sendarg arg) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_RETRIEVE_PENDING_BUDDY_REQUEST;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 要查找的用户名
	string name = arg["userId"];
    transform(name.begin(),name.end(), name.begin(), ::tolower);
	jos<<name;
    
	FillOutPackage(jos, lengthPos, cmd);
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}


void RetrievePendingBuddyRequest::DoRecv(etim::Session &s) {
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
        NSMutableArray *reqBuddyArr = [NSMutableArray array];
        
        for (uint16 i = 0; i < cnt; ++i) {
            InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
            // 跳过cmd、len
            jis.Skip(4);
            uint16 cnt;
            uint16 seq;
            int16 error_code;
            jis>>cnt>>seq>>error_code;
            char error_msg[ERR_MSG_LENGTH+1];
            jis.ReadBytes(error_msg, ERR_MSG_LENGTH);
            
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
            [reqBuddyArr addObject:[[BuddyModel alloc] initWithUser:user]];
            
            if (seq == cnt - 1)
                break;
            s.Recv();
        }
        
        if ([reqBuddyArr count]) {
            [[ReceivedManager sharedInstance] setReqBuddyArr:reqBuddyArr];
        }

    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}


void RetrieveAllBuddyRequest::DoSend(Session& s, sendarg arg) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_RETRIEVE_ALL_BUDDY_REQUEST;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 要查找的用户名
	string name = arg["userId"];
    transform(name.begin(),name.end(), name.begin(), ::tolower);
	jos<<name;
    
	FillOutPackage(jos, lengthPos, cmd);
    
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}


void RetrieveAllBuddyRequest::DoRecv(etim::Session &s) {
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
        NSMutableArray *reqArr = [NSMutableArray array];
        for (uint16 i = 0; i < cnt; ++i) {
            InStream jis((const char*)s.GetResponsePack(), s.GetResponsePack()->head.len+sizeof(ResponseHead));
            // 跳过cmd、len
            jis.Skip(4);
            uint16 cnt;
            uint16 seq;
            int16 error_code;
            jis>>cnt>>seq>>error_code;
            char error_msg[ERR_MSG_LENGTH+1];
            jis.ReadBytes(error_msg, ERR_MSG_LENGTH);

            IMReq req;
            IMUser user;
            int rel;
            int status;
            int reqStatus;
            jis>>req.reqId;
            jis>>user.userId;
            jis>>user.username;
            jis>>user.regTime;
            jis>>user.signature;
            jis>>user.gender;
            jis>>rel;
            jis>>status;
            jis>>user.statusName;
            jis>>reqStatus;
            jis>>req.reqTime;
            jis>>req.reqSendTime;
            jis>>req.actionTime;
            jis>>req.actionSendTime;
            
            user.relation = static_cast<BuddyRelation>(rel);
            user.status = static_cast<BuddyStatus>(status);
            req.status = static_cast<BuddyRequestStatus>(reqStatus);
            req.from = user;
            
            RequestModel *model = [[RequestModel alloc] initWithRequest:req];
            [reqArr addObject:model];
            
            if (seq == cnt - 1)
                break;
            s.Recv();
        }
        if ([reqArr count]) {
            [[ReceivedManager sharedInstance] setReqArr:reqArr];
        }
    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}
//
//  SendMsg.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "SendMsg.h"
#include "InStream.h"
#include "OutStream.h"
#include "MD5.h"
#include "Idea.h"
#include "DataStruct.h"


#import "ReceivedManager.h"
#import "MsgModel.h"
#import "Client.h"

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

void SendMsg::DoSend(Session& s, sendarg arg) {
    OutStream jos;
	// 包头命令
	uint16 cmd = CMD_SEND_MSG;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	string from = arg["from"];
	string to = arg["to"];
    string text = arg["text"];
    string uuid = arg["uuid"];
    jos<<from;
	jos<<to;
    jos<<text;
    jos<<uuid;
    
	FillOutPackage(jos, lengthPos, cmd);
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}


void SendMsg::DoRecv(etim::Session &s) {
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
        int msgId;
        string uuid;
        jis>>msgId;
        jis>>uuid;
        
        SendMsgReturn send;
        send.msgId = msgId;
        send.uuid = [stdStrToNsStr(uuid) intValue];
        
        [[ReceivedManager sharedInstance] setSendMsgReturn:send];
    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);

}

void RetrieveUnreadMsg::DoSend(Session& s, sendarg arg) {
    OutStream jos;
    
	// 包头命令
	uint16 cmd = CMD_RETRIEVE_UNREAD_MSG;
	jos<<cmd;
    
	// 预留两个字节包头len（包体+包尾长度）
	size_t lengthPos = jos.Length();
	jos.Skip(2);
    
	// 要查找的用户id
	string userId = arg["userId"];
	jos<<userId;
    
	FillOutPackage(jos, lengthPos, cmd);
	s.Send(jos.Data(), jos.Length());	// 发送请求包
}


void RetrieveUnreadMsg::DoRecv(etim::Session &s) {
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
        NSMutableArray *msgArr = [NSMutableArray array];
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

            [msgArr addObject:[[MsgModel alloc] initWithMsg:msg]];
            
            if (seq == cnt - 1)
                break;
            s.Recv();
        }
        
        if ([msgArr count]) {
            [[ReceivedManager sharedInstance] setUnreadMsgArr:msgArr];
        }
    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}
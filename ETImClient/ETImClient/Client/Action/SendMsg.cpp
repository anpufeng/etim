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

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

void SendMsg::DoSend(Session& s, sendarg arg) {

}


void SendMsg::DoRecv(etim::Session &s) {
    
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

    
    /*
     ///用户
     struct IMUser {
     int             userId;
     std::string     username;
     std::string     regDate;
     std::string     signature;
     int8            gender;
     BuddyRelation   relation;
     BuddyStatus     status;
     std::string     statusName;
     };
     
     ///消息
     struct IMMsg {
     int             msgId;
     IMUser          from;
     std::string     text;
     int8            sent;
     std::string     requestTime;
     std::string     sendTime;
     };
     */
    if (error_code == kErrCode00) {
        
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
            IMUser user;
            int rel;
            int status;
            jis>>msg.msgId;
            jis>>user.userId;
            jis>>user.username;
            jis>>user.regDate;
            jis>>user.signature;
            jis>>user.gender;
            jis>>rel;
            jis>>status;
            jis>>user.statusName;
            jis>>msg.text;
            jis>>msg.sent;
            jis>>msg.requestTime;
            jis>>msg.sendTime;
            
            user.relation = static_cast<BuddyRelation>(rel);
            user.status = static_cast<BuddyStatus>(status);
            msg.from = user;
            s.AddUnreadMsg(msg);
            
            if (seq == cnt - 1)
                break;
            s.Recv();
        }
    }
    s.SetErrorCode(error_code);
	s.SetErrorMsg(error_msg);
}
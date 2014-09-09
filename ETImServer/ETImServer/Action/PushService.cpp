//
//  PushService.cpp
//  ETImServer
//
//  Created by Ethan on 14/9/9.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "PushService.h"
#include "OutStream.h"
#include "InStream.h"
#include "MD5.h"
#include "Idea.h"
#include "Logging.h"
#include "DataService.h"
#include "DataStruct.h"
#include "SwitchStatus.h"

#include <sstream>
#include <iomanip>

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;

void PushService::Execute(Session *s) {
    
}

void PushService::PushBuddyUpdate(const etim::IMUser &user, etim::DataService &dao) {
    int ret;
    uint16 cnt = 0;
	uint16 seq = 0;
    uint16 cmd = PUSH_BUDDY_UPDATE;;
    Session *s;
    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    
    std::list<IMUser> buddys;
    ret = dao.RetrieveBuddyList(Convert::IntToString(user.userId), true, false, buddys);
    if (ret == kErrCode00) {
        LOG_INFO<<"通知在线好友我上线, userId: "<<user.userId;
        list<IMUser>::const_iterator it;
        for (it = buddys.begin(); it != buddys.end(); ++it) {
            ///先找出对应的session
            s = Singleton<Server>::Instance().FindSession(it->userId);
            if (s) {
                OutStream jos;
                // 包头命令
                jos<<cmd;
                size_t lengthPos = jos.Length();
                jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
                // 包头cnt、seq、error_code、error_msg
                jos<<cnt<<seq<<error_code;
                jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
                
                // 包体
                jos<<user.userId;
                jos<<user.username;
                jos<<user.regDate;
                jos<<user.signature;
                jos<<user.gender;
                jos<<user.relation;
                jos<<user.status;
                jos<<user.statusName;
                
                FillOutPackage(jos, lengthPos, cmd);
                
                s->Send(jos.Data(), jos.Length());
                LOG_INFO<<"已经通知userId :"<<s->GetIMUser().userId<<" userId: "<<user.userId<<" 的在线状态";
            } else {
                LOG_ERROR<<"没找出在线用户对应的session, userId: "<<it->userId;
            }
        }
    } else {
        LOG_INFO<<"无在线好友要通知 userId: "<<user.userId;
    }
}

void PushService::PushBuddyRequestResult(const etim::IMUser &user, const int from, bool accept, bool peer, etim::DataService &dao) {
    uint16 cnt = 0;
	uint16 seq = 0;
    uint16 cmd = PUSH_BUDDY_REQUEST_RESULT;;
    Session *s;
    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    s = Singleton<Server>::Instance().FindSession(from);
    if (s) {
        OutStream jos;
        // 包头命令
        jos<<cmd;
        size_t lengthPos = jos.Length();
        jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
        // 包头cnt、seq、error_code、error_msg
        jos<<cnt<<seq<<error_code;
        jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
        
        // 包体
        jos<<user.userId;
        jos<<user.username;
        jos<<user.regDate;
        jos<<user.signature;
        jos<<user.gender;
        jos<<user.relation;
        jos<<user.status;
        jos<<user.statusName;
        if (accept) {
            jos<<1;
            jos<<(peer ? 1 : 0);
        } else {
            jos<<0;
            jos<<0;
        }
        
        FillOutPackage(jos, lengthPos, cmd);
        
        s->Send(jos.Data(), jos.Length());
        LOG_INFO<<"通知在线请求方我的结果, userId: "<<user.userId<<" 请求方 from: "<<from;
    } else {
        LOG_INFO<<"无在线请求方要通知 userId: "<<user.userId<<" 请求方 from: "<<from;
    }
}
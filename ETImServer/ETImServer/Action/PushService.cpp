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
#include "glog/logging.h"
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
        LOG(INFO)<<"通知在线好友我上线, userId: "<<user.userId;
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
                LOG(INFO)<<"已经通知userId :"<<s->GetIMUser().userId<<" userId: "<<user.userId<<" 的在线状态";
            } else {
                LOG(ERROR)<<"没找出在线用户对应的session, userId: "<<it->userId;
            }
        }
    } else {
        LOG(INFO)<<"无在线好友要通知 userId: "<<user.userId;
    }
}

void PushService::PushBuddyRequestResult(const etim::IMUser &user, const int from, bool accept, bool peer, const std::string &reqId, etim::DataService &dao) {
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
        //更新ACTION SEND time
        dao.UpdateActionSendTime(reqId, accept);
        LOG(INFO)<<"通知在线请求方我的结果, userId: "<<user.userId<<" 请求方 from: "<<from;
    } else {
        LOG(INFO)<<"无在线请求方要通知 userId: "<<user.userId<<" 请求方 from: "<<from;
    }
}

void PushService::PushRequestAddBuddy(const etim::IMUser &user, const std::string &to, const std::string &reqId, etim::DataService &dao) {
    uint16 cnt = 0;
	uint16 seq = 0;
    uint16 cmd = PUSH_REQUEST_ADD_BUDDY;
    Session *s;
    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    s = Singleton<Server>::Instance().FindSession(Convert::StringToInt(to));
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
//        jos<<user.relation;
        jos<<kBuddyRelationStranger;
        jos<<user.status;
        jos<<user.statusName;
        
        FillOutPackage(jos, lengthPos, cmd);
        
        s->Send(jos.Data(), jos.Length());
        //更新request_send发出时间
        dao.UpdateRequestSendTime(reqId);
        LOG(INFO)<<"通知在线请求方我请求加为好友, userId: "<<user.userId<<" 对方 to: "<<to;
    } else {
        LOG(INFO)<<"对方不在线, 对方登录后会从服务器拉取请求信息, userId: "<<user.userId<<" 对方 to: "<<to;
    }

}

void PushService::PushSendMsg(const std::string &from, const std::string &to, etim::DataService &dao) {
    int ret;
    uint16 cmd = PUSH_SEND_MSG;
    Session *s;
    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    s = Singleton<Server>::Instance().FindSession(Convert::StringToInt(to));
    std::list<IMMsg> msgs;
    if (s) {
        ret = dao.RetrieveUnreadMsg(to, msgs);
        if (ret == kErrCode00) {
            uint16 cnt = static_cast<uint16>(msgs.size());    //总共多少
            uint16 seq = 0;                                     //序列号
            list<IMMsg>::const_iterator it;
            for (it = msgs.begin(); it != msgs.end(); ++it) {
                OutStream jos;
                // 包头命令
                jos<<cmd;
                size_t lengthPos = jos.Length();
                jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
                // 包头cnt、seq、error_code、error_msg
                
                jos<<cnt<<seq<<error_code;
                seq++;
                jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
                
                // 包体
                jos<<it->msgId;
                jos<<it->fromId;
                jos<<it->fromName;
                jos<<it->toId;
                jos<<it->toName;
                jos<<it->text;
                jos<<it->sent;
                jos<<it->requestTime;
                jos<<it->sendTime;
                LOG(INFO)<<it->sendTime;
                FillOutPackage(jos, lengthPos, cmd);

                s->Send(jos.Data(), jos.Length());
            }
            LOG(INFO)<<"用户在线 userId :"<<to<<" 已推送";
        } else {
            assert(error_code < kErrCodeMax);
            strcpy(error_msg, gErrMsg[error_code].c_str());
            LOG(ERROR)<<"用户在线 查询未读消息失败: "<<error_msg <<" from userId: "<<from<<" to userId: "<<to;
        }
    } else {
        LOG(INFO)<<"用户不在线 userId :"<<to<<" 不需要推送";
    }
}
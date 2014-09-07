    //
//  SwitchStatus.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "SwitchStatus.h"
#include "Endian.h"
#include "OutStream.h"
#include "InStream.h"
#include "MD5.h"
#include "Idea.h"
#include "Logging.h"
#include "DataService.h"
#include "DataStruct.h"

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;

void SwitchStatus::Execute(Session *s) {
    
}


void SwitchStatus::PushBuddyUpdate(etim::IMUser &user, etim::DataService &dao) {
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
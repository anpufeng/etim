//
//  SendMsg.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "SendMsg.h"
#include "OutStream.h"
#include "InStream.h"
#include "MD5.h"
#include "Idea.h"
#include "Logging.h"
#include "DataService.h"
#include "DataStruct.h"

#include <sstream>
#include <iomanip>

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;

void SendMsg::Execute(Session *s) {
    
}



void RetrieveUnreadMsg::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    if (cmd == CMD_UNREAD) {
        cmd = CMD_RETRIEVE_UNREAD_MSG;
    }
    
	// 登录id
	string userId;
	jis>>userId;
	
    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
	//TODO 获取未读消息 查询数据库未读消息并send
	DataService dao;
    std::list<IMMsg> msgs;
	int ret = kErrCode00;
    //ret = dao.RetrieveUnreadMsg(userId, msgs);
    ret = kErrCode06;
	if (ret == kErrCode00) {
		LOG_INFO<<"查询未读消息成功 userId: "<<userId <<" 未读消息条数: "<<msgs.size();
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
            jos<<it->from.userId;
            jos<<it->from.username;
            jos<<it->from.regDate;
            jos<<it->from.signature;
            jos<<it->from.gender;
            jos<<it->from.relation;
            jos<<it->from.status;
            jos<<it->from.statusName;
            jos<<it->text;
            jos<<it->sent;
            jos<<it->requestTime;
            jos<<it->sendTime;
            
            FillOutPackage(jos, lengthPos, cmd);
            
            s->Send(jos.Data(), jos.Length());
        }
        //TODO 发送后更新消息状态

	} else  {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_INFO<<"查询未读消息: "<<error_msg;
        
        OutStream jos;
        // 包头命令
        jos<<cmd;
        size_t lengthPos = jos.Length();
        jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
        // 包头cnt、seq、error_code、error_msg
        uint16 cnt = 0;
        uint16 seq = 0;
        jos<<cnt<<seq<<error_code;
        jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
        
        // 空包体
        
        FillOutPackage(jos, lengthPos, cmd);
        
        s->Send(jos.Data(), jos.Length());
	}
}
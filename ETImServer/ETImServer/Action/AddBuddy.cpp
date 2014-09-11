//
//  AddBuddy.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "AddBuddy.h"
#include "PushService.h"
#include "OutStream.h"
#include "InStream.h"
#include "MD5.h"
#include "Idea.h"
#include "Logging.h"
#include "Endian.h"
#include "DataService.h"
#include "DataStruct.h"

#include <sstream>
#include <iomanip>

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;

void RequestAddBuddy::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	// 好友请求
	string fromName;
    string toName;
    jis>>fromName;
	jis>>toName;
	
	int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    
    
	// 实际的添加操作
	DataService dao;
	int ret;
    string toId;
    string reqId;
	ret = dao.RequestAddBuddy(fromName, toName, toId, reqId);
	if (ret == kErrCode00) {
        strcpy(error_msg, "请求发送成功");
		LOG_INFO<<"添加好友请求成功 from: "<<fromName<<" to: "<<toName;
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_INFO<<"添加好友请求成功 from: "<<fromName<<" to: "<<toName<<" "<<error_msg;
	}
    
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
    if (ret == kErrCode00) {
        
        PushService push;
        //通知在线请求方同意结果
        push.PushRequestAddBuddy(s->GetIMUser(), toId, reqId, dao);
    }
}



void SearchBuddy::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	// 搜索名
	string name;
	jis>>name;
	
	int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    
    
	// 实际的搜索操作
	DataService dao;
    IMUser user;
    user.username = name;
	int ret;
	ret = dao.UserSearch(name, s, user);
	if (ret == kErrCode00) {
		LOG_INFO<<"查询用户成功 查询名: "<<name;
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		LOG_INFO<<"查询用户失败 查询名: "<<name<<" "<<error_msg;
	}
    
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
    
	// 包体
    if (ret == kErrCode00) {
        jos<<user.userId;
        jos<<user.username;
        jos<<user.regDate;
        jos<<user.signature;
        jos<<user.gender;
        jos<<user.relation;
        jos<<user.status;
        jos<<user.statusName;
    }
    FillOutPackage(jos, lengthPos, cmd);
	s->Send(jos.Data(), jos.Length());
}

void AcceptAddBuddy::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	string reqId, fromId, addPeer;
	jis>>reqId;
    jis>>fromId;
    jis>>addPeer;
	
	int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    
    
	// 添加
	DataService dao;
	int ret;
    bool peer =  static_cast<bool>(Convert::StringToInt(addPeer));
    int userId = s->GetIMUser().userId;
    IMUser fromUser;    // 用于返回请求方最新资料(主要是否在线)
    ret = dao.AcceptAddBuddy(fromId, Convert::IntToString(userId), reqId, peer, fromUser);
	if (ret == kErrCode00) {
		LOG_INFO<<"接受用户 " <<(Convert::StringToInt(addPeer) ? "并且添加对方为好友" : "") <<
                "fromUserId: "<<fromId<< " toUserId: "<<userId<< " 成功";
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
        LOG_INFO<<"接受用户 " <<(Convert::StringToInt(addPeer) ? "并且添加对方为好友" : "") <<
        "fromUserId: "<<fromId<< " toUserId: "<<userId<< " 失败: "<<error_msg;
	}
    
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
    
	// 包体
    if (ret == kErrCode00) {
        jos<<fromUser.userId;
        jos<<fromUser.username;
        jos<<fromUser.regDate;
        jos<<fromUser.signature;
        jos<<fromUser.gender;
        jos<<fromUser.relation;
        jos<<fromUser.status;
        jos<<fromUser.statusName;
        jos<<addPeer;
    }
 
    FillOutPackage(jos, lengthPos, cmd);
	s->Send(jos.Data(), jos.Length());
    
    if (ret == kErrCode00) {
        
        PushService push;
        //通知在线请求方同意结果
        push.PushBuddyRequestResult(s->GetIMUser(), Convert::StringToInt(fromId), true, peer, reqId, dao);
    }
}


void RejectAddBuddy::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	string reqId, fromId;
	jis>>reqId;
    jis>>fromId;
	
	int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};
    
    
	// 拒绝
	DataService dao;
    int userId = s->GetIMUser().userId;
	int ret = dao.RejectAddBuddy(fromId, Convert::IntToString(userId), reqId);

	if (ret == kErrCode00) {
		LOG_INFO<<"拒绝用户 " << "fromUserId: "<<fromId<< " toUserId: "<<userId<< " 成功";
	} else {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
        LOG_INFO<<"拒绝用户 " << "fromUserId: "<<fromId<< " toUserId: "<<userId<< " 失败: "<<error_msg;
	}
    
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
    
    ///空包体
    
    FillOutPackage(jos, lengthPos, cmd);
    
	s->Send(jos.Data(), jos.Length());
    
    if (ret == kErrCode00) {
        //通知在线请求方被拒绝结果
        PushService push;
        push.PushBuddyRequestResult(s->GetIMUser(), Convert::StringToInt(fromId), false, false, reqId, dao);

    }
}
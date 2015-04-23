//
//  DataStruct.h
//  ETImServer
//
//  Created by Ethan on 14/8/8.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef ETImServer_DataStruct_h
#define ETImServer_DataStruct_h

#include <iostream>
#include "Endian.h"

///好友关系

enum BuddyRelation {
    kBuddyRelationSelf,         //自己
    kBuddyRelationStranger,     //陌生人
    kBuddyRelationFriend        //好友
};

///请求好友状态
enum BuddyRequestStatus {
    kBuddyRequestNoSent     = 0,                //0请求未发送(用户未在线或其它原因)
    kBuddyRequestSent       = 1 << 0,           //1请求已发送 用户还未响应
    kBuddyRequestRejected     = 1 << 1,           //2用户拒绝添加为好友且未发送到请求方
    kBuddyRequestAccepted   = 1 << 2,            //4用户接受添加为好友且未发送到请求方
    kBuddyRequestRejectedSent = (kBuddyRequestRejected|kBuddyRequestSent), //3拒绝并且发送至请求方
    kBuddyRequestAcceptedSent = (kBuddyRequestAccepted|kBuddyRequestSent), //5同意且发送到请求方
    kBuddyRequestInvalid    = 127                   //此req已失效
};

enum MsgSentStatus {
    kMsgUnsent = 0,                 //用户信息未发出
    kMsgSent                    //用户信息已发出
};

///在线状态
enum BuddyStatus {
    kBuddyOnline = 1,
    kBuddyInvisible,
    kBuddyAway,
    kBuddyOffline
};

namespace etim  {

    ///用户
    struct IMUser {
        int             userId;
        std::string     username;
        std::string     regTime;
        std::string     signature;
        int8            gender;
        BuddyRelation   relation;
        BuddyStatus     status;
        std::string     statusName;
    };
    
    ///消息
    struct IMMsg {
        int             msgId;
        int             fromId;
        std::string     fromName;
        int             toId;
        std::string     toName;
        std::string     text;
        int8            sent;
        std::string     requestTime;
        std::string     sendTime;
    };
    
    ///请求
    struct IMReq {
        int                 reqId;
        IMUser              from;
        BuddyRequestStatus  status;
        std::string         reqTime;
        std::string         reqSendTime;
        std::string         actionTime;
        std::string         actionSendTime;
    };

}   //end etim
#endif

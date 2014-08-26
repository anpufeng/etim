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


enum BuddyRequestStatus {
    kBuddyRequestNoSent,        //请求未发送(用户未在线或其它原因)
    kBuddyRequestSent,          //请求已发送 用户还未响应
    kBuddyRequestReject,        //用户拒绝添加为好友
    kBuddyRequestAccepted,      //用户接受添加为好友
};

namespace etim  {
    
    ///用户
    struct IMUser {
        std::string     userId;
        std::string     username;
        std::string     regDate;
        std::string     signature;
        int8            gender;
        BuddyRelation   relation;
        std::string     status;
    };
    
    ///消息
    struct IMMsg {
        int             msgId;
        IMUser          *from;
        IMUser          *to;
        std::string     text;
        int8            sent;
        std::string     sendTime;
    };
    
}   //end etim

#endif

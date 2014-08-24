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

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

namespace etim  {

///用户
struct IMUser {
    std::string username,
    std::string password,
    bool gender,
    
};

///消息
struct IMMsg {
    int msgId,
    IMUser *from,
    IMUser *to,
    std::string text,
    bool sent,
    std::string sendTime
};

}   //end etim
#endif

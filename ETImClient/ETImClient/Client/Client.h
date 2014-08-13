//
//  Client.h
//  ETImClient
//
//  Created by ethan on 8/6/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#ifndef __ETImServer__Client__
#define __ETImServer__Client__

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#include "Session.h"

#define HOST_SERVER                "127.0.0.1"
#define HOST_PORT                   8888

///根据cmd获取要发送的通知名
inline NSString *notiNameFromCmd(const int16_t cmd) {
    std::string noti = etim::gCmdNoti[cmd];
    NSString *notiName = [[NSString alloc] initWithUTF8String:noti.c_str()];
    
    return notiName;
}

inline NSString *stdStrToNsStr(const std::string & str) {
    
    return [[NSString alloc] initWithUTF8String:str.c_str()];
}

inline std::string nsStrToStdStr(NSString *str) {
    return std::string(str.UTF8String);
}

@interface Client : NSObject {
    dispatch_queue_t _queueId;
}


+ (Client *)sharedInstance;

///获取session对象
- (etim::Session *)session;
- (void)doAction:(etim::Session &)s;

@end

#endif  //end

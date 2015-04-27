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
#include "Endian.h"

typedef NS_OPTIONS(NSUInteger, ConnOffline) {
    ConnOfflineSelf,
    ConnOfflineServer
};
///根据cmd获取要发送的通知名
inline NSString *notiNameFromCmd(const int16_t cmd) {
    int cmdCount = sizeof(etim::gCmdNoti)/sizeof(etim::gCmdNoti[0]);
    if (cmd < cmdCount) {
        std::string noti = etim::gCmdNoti[cmd];
        NSString *notiName = [[NSString alloc] initWithUTF8String:noti.c_str()];
        
        return notiName;

    } else {
        std::string noti = etim::gPushNoti[cmd-PUSH_BUDDY_UPDATE];
        NSString *notiName = [[NSString alloc] initWithUTF8String:noti.c_str()];
        
        return notiName;
    }
}

///将std::string转换为NSString
inline NSString *stdStrToNsStr(const std::string & str) {
    
    NSString *nsstr = [[NSString alloc] initWithUTF8String:str.c_str()];
    return nsstr;
}

///将NSString转换为std::string
inline std::string nsStrToStdStr(NSString *str) {
    return std::string(str.UTF8String);
}

@protocol Client <NSObject>

@required
- (void)socketConnectSuccess;
- (void)socketConnectFailure;

/*
@optional
- (void)clientDidLoginSuccess;
- (void)clientDidLoginFailure;
- (void)clientDidLogoutSuccess;
- (void)clientDidLogoutFailure;
- (void)clientDidRegSuccess;
- (void)clientDidRegFailure;
 */

@end

#endif  //end


@class BuddyModel;


@interface Client : NSObject <Client> {
    NSOperationQueue *_sendedOpeartionQueue;
    dispatch_queue_t _connQueue;
    dispatch_queue_t _recvQueue;
}

///当前登录的用户信息
@property (nonatomic, strong) BuddyModel *user;
///TODO 用户信息加密存储 传输
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, strong) NSObject *receivedObj;
///上次是否成功登录过
@property (nonatomic, assign) BOOL login;
///上次登出过
@property (nonatomic, assign) BOOL logout;
@property (nonatomic, assign) BOOL appActive;
@property (nonatomic, weak) id<Client> delegate;


+ (Client *)sharedInstance;


///获取session对象
- (etim::Session *)session;
///往服务端发送CMD 获取消息
- (void)doAction:(etim::Session &)s cmd:(etim::uint16)cmd param:(NSMutableDictionary *)params;
///获取消息, 登录成功后获取最新消息(好友信息, 聊天信息等)
- (void)pullUnread;
- (void)pullWithCommand:(etim::uint16)cmd;
- (void)startReachabilityNoti;
- (void)doRecvAction;


- (void)connectWithDelegate:(id<Client>)delegate;
- (void)reconnect;
- (BOOL)connected;
- (void)disconnect;
- (void)reLogin;

- (void)resetStatus;

///config
+ (NSString *)serverIp;
+ (NSString *)serverPort;

+ (char *)stdServerIp;
+ (unsigned short)stdServerPort;

+ (void)updateServerIp:(NSString *)ip;
+ (void )updateserverPort:(NSString *)port;

@end




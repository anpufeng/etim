//
//  ReceivedManager.h
//  ETImClient
//
//  Created by xuqing on 15/4/1.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

struct SendMsgReturn {
    int msgId;
    int uuid;
};
typedef struct SendMsgReturn SendMsgReturn;

@class BuddyModel;
@class RequestModel;
@class MsgModel;

/** 主要用于管理接收到的数据
  本来想统一放一个基础类型  后来发现 一些数据后来也要用， 所以针对一些不同的数据都存储
 */

@interface ReceivedManager : NSObject



//@property (nonatomic, strong) NSObject *receivedObj;
///好友
@property (nonatomic, strong) NSMutableArray *buddyArr;
///用户请求的数组
@property (nonatomic, strong) NSMutableArray *reqBuddyArr;
///请求列表
@property (nonatomic, strong) NSMutableArray *reqArr;
///登录的用户
@property (nonatomic, strong) BuddyModel *loginBuddy;
///搜索用户结果
@property (nonatomic, strong) BuddyModel *searchedBuddy;
///用户状态改变 上下线
@property (nonatomic, strong) BuddyModel *statusChangedBuddy;
///正在请求的用户
@property (nonatomic, strong) BuddyModel *requestingBuddy;
///请求通过
@property (nonatomic, strong) BuddyModel *acceptedBuddy;
///未读消息数组
@property (nonatomic, strong) NSMutableArray *unreadMsgArr;
///收到一条消息
@property (nonatomic, strong) MsgModel *receivedMsg;

@property (nonatomic, assign) SendMsgReturn sendMsgReturn;



+(ReceivedManager *)sharedInstance;

- (void)resetData;

@end

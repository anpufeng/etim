//
//  DBManager.h
//  ETImClient
//
//  Created by xuqing on 15/4/17.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceivedManager.h"

@class MsgModel;


@interface DBManager : NSObject

+(DBManager*)sharedInstance;
+ (void)destory;

/**
 @info 插入一条消息
 @fromServer bool 消息是从服务器来的 还是本地的
 **/
- (BOOL)insertOneMsg:(MsgModel *)msg fromServer:(BOOL)fromServer msgId:(int *)msgId;
- (BOOL)insertMsgs:(NSMutableArray *)msgs;
- (BOOL)updateLocalMsgStatus:(SendMsgReturn)msgReturn;

/**
 插入用户  有则更新 无则插入
 **/

- (BOOL)insertOneBuddy:(BuddyModel *)buddy;
- (BOOL)insertBuddys:(NSMutableArray *)buddys;

- (NSMutableArray *)allBuddys;

/**
 @info 获取某人最近消息(20条)
 @param msgId 上一条的消息id 默认为0时从最新的取
 @param peerId 对话方的uid
 **/
- (NSMutableArray *)peerRecentMsgs:(int)peerId  msgId:(int)msgId;

- (NSMutableArray *)peerRecentMsgs:(int)peerId;

///所有 最近的消息
- (NSMutableArray *)allRecentMsgs;


@end

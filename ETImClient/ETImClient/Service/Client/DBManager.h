//
//  DBManager.h
//  ETImClient
//
//  Created by xuqing on 15/4/17.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MsgModel;

@interface DBManager : NSObject

+(DBManager*)sharedInstance;

- (BOOL)insertOneMsg:(MsgModel *)msg;
- (BOOL)insertMsgs:(NSMutableArray *)msgs;

/**
 @info 获取最近消息(20条)
 @param msgId 上一条的消息id 默认为0时从最新的取
 @param peerId 对话方的uid
 **/
- (NSMutableArray *)recentMsgs:(int)msgId peerId:(int)peerId;

- (NSMutableArray *)recentMsgs:(int)peerId;

@end

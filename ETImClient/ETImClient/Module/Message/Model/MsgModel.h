//
//  MsgModel.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuddyModel.h"

#include "Endian.h"
#include "DataStruct.h"
#include <list>


typedef NS_ENUM(NSInteger, MsgSource) {
    kMsgSourceOther,
    kMsgSourceSelf
};


@class BuddyModel;

///消息模型

@interface MsgModel : NSObject

@property (nonatomic, assign) int msgId;
@property (nonatomic, assign) int fromId;
@property (nonatomic, assign) int toId;
@property (nonatomic, copy) NSString *fromName;
@property (nonatomic, copy) NSString *toName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) etim::int8 sent;
///请求发送时间
@property (nonatomic, copy) NSString *requestTime;
@property (nonatomic, copy) NSString *sendTime;

//
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) MsgSource source;
///是否成功发到服务器
@property (nonatomic, assign) MsgSentStatus sentStatus;

///时间戳
@property (nonatomic, readonly) NSDate *sendDate;

- (id)initWithMsg:(etim::IMMsg)msg;

///自己发出的消息
- (id)initWithToId:(int)toId toName:(NSString *)toName text:(NSString *)text;

///以聊天对方ID作为key
- (NSString *)peerIdStr;
///对方姓名
- (NSString *)peerName;

+ (NSMutableArray *)msgs:(const std::list<etim::IMMsg> &)msgs;

@end




///消息列表界面  用于MsgViewController展示的消息

@interface ListMsgModel : NSObject

///聊天对方id
@property (nonatomic, assign) int peerId;
@property (nonatomic, strong) MsgModel *lastestMsg;

- (NSInteger)unreadMsgCount;

@end



@interface ChatCellFrame : NSObject

@property (nonatomic, strong) MsgModel *message;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end


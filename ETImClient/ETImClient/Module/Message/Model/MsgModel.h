//
//  MsgModel.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (nonatomic, copy) NSString *requestTime;
@property (nonatomic, copy) NSString *sendTime;

//
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) MsgSource source;
@property (nonatomic, assign) MsgSentStatus sentStatus;

- (id)initWithMsg:(etim::IMMsg)msg;

///自己发出的消息
- (id)initWithToBuddy:(BuddyModel *)toBuddy text:(NSString *)text;

+ (NSMutableArray *)msgs:(const std::list<etim::IMMsg> &)msgs;

@end




@interface ChatCellFrame : NSObject

@property (nonatomic, strong) MsgModel *message;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end


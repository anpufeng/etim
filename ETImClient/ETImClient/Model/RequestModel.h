//
//  RequestModel.h
//  ETImClient
//
//  Created by Ethan on 14/9/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "DataStruct.h"
#include <list>

@class BuddyModel;

///每条好友请求

@interface RequestModel : NSObject

@property (nonatomic, assign) int reqId;
@property (nonatomic, strong) BuddyModel *from;
@property (nonatomic, assign) BuddyRequestStatus status;
@property (nonatomic, strong) NSString *reqTime;
@property (nonatomic, strong) NSString *reqSendTime;
@property (nonatomic, strong) NSString *actionTime;
@property (nonatomic, strong) NSString *actionSendTime;


- (id)initWithRequest:(etim::IMReq)req;
///请求状态
- (NSString *)reqStatus;

///将list类型请求转换为NSMutableArray
+ (NSMutableArray *)request:(const std::list<etim::IMReq> &)reqs;

@end

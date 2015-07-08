//
//  BuddyModel.h
//  ETImClient
//
//  Created by Ethan on 14/9/1.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "DataStruct.h"
#include <list>


///用户模型

@interface BuddyModel : NSObject

@property (nonatomic, assign) int userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *regTime;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) etim::uint8 gender;
@property (nonatomic, assign) BuddyRelation relation;
@property (nonatomic, assign) BuddyStatus status;
@property (nonatomic, copy) NSString *statusName;

- (id)initWithUser:(etim::IMUser)user;
///用户性别文本
- (NSString *)buddyGender;

///将list类型用户转换为NSMutableArray
+ (NSMutableArray *)buddys:(const std::list<etim::IMUser> &)users;

@end

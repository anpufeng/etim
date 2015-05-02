//
//  BuddyModel.m
//  ETImClient
//
//  Created by Ethan on 14/9/1.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BuddyModel.h"
#import "Client.h"

using namespace etim;

@implementation BuddyModel

- (id)init {
    if (self = [super init]) {
        self.userId = -1;
    }
    
    return self;
}

- (id)initWithUser:(etim::IMUser)user {
    if (self = [super init]) {
        self.userId = user.userId;
        self.username = stdStrToNsStr(user.username);
        self.regTime = stdStrToNsStr(user.regTime);
        self.signature = stdStrToNsStr(user.signature);
        self.gender = user.gender;
        self.relation = user.relation;
        self.status = user.status;
        self.statusName = stdStrToNsStr(user.statusName);
    }
    
    return self;
}

- (NSString *)buddyGender {
    return self.gender ? @"男" : @"女";
}

- (NSString *)statusName {
    if (_statusName) {
        return _statusName;
    }
    
    NSString *status = @"离线";
    switch (self.status) {
        case kBuddyOnline:
        {
            status = @"在线";
        }
            break;
            
        case kBuddyInvisible:
        {
            status = @"离线";
        }
            break;
            
        case kBuddyAway:
        {
            status = @"离开";
        }
            break;
            
        case kBuddyOffline:
        {
            status = @"离线";
        }
            break;
            
        default:
            break;
    }
    
    return status;
}

- (NSString *)buddyRelation {
    NSString *relation;
    switch (self.relation) {
        case kBuddyRelationFriend:
            relation = @"好友";
            break;
            
        case kBuddyRelationStranger:
            relation = @"陌生人";
            break;
            
        case kBuddyRelationSelf:
            relation = @"自己";
            break;
            
        default:
            relation = @"陌生人";
            break;
    }
    
    return relation;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"用户id: %06d, 用户名:%@, 注册日期: %@, 签名:%@, 性别:%@, 状态:%@ 关系:%@",
            self.userId,
            self.username,
            self.regTime,
            self.signature,
            [self buddyGender],
            self.statusName,
            [self buddyRelation]];
}

+ (NSMutableArray *)buddys:(const std::list<etim::IMUser> &)users {
    NSMutableArray *result = [NSMutableArray array];
    std::list<IMUser>::const_iterator it;
    for (it = users.begin(); it != users.end(); ++it) {
        BuddyModel *model = [[BuddyModel alloc] initWithUser:*it];
        [result addObject:model];
    }

    return result;
}

@end

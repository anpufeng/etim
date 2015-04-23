//
//  ReceivedManager.m
//  ETImClient
//
//  Created by xuqing on 15/4/1.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "ReceivedManager.h"
#import "BuddyModel.h"
#import "MsgModel.h"
#import "RequestModel.h"

@implementation ReceivedManager

static ReceivedManager *sharedReceived = nil;
static dispatch_once_t predicate;

+(ReceivedManager *)sharedInstance{
    dispatch_once(&predicate, ^{
        sharedReceived = [[ReceivedManager alloc]init];
        //忽略send产生的sigpipe信号
        signal(SIGPIPE, SIG_IGN);
    });
    
    return sharedReceived;
}

/*
+ (void)destory {
    if (sharedReceived) {
        sharedReceived = nil;
        predicate = 0;
    }
}
 */

- (void)dealloc {
    DDLogDebug(@"======= ReceivedManager DEALLOC ========");
}
- (id)init {
    if (self = [super init]) {
        [self resetData];
}
    
    return self;
}

- (void)resetData {
    int capacity = 10;
    self.buddyArr = [NSMutableArray arrayWithCapacity:capacity];
    self.reqArr = [NSMutableArray arrayWithCapacity:capacity];
    self.reqBuddyArr = [NSMutableArray arrayWithCapacity:capacity];
    
    self.loginBuddy = [[BuddyModel alloc] init];
    self.searchedBuddy = [[BuddyModel alloc] init];
    self.statusChangedBuddy = [[BuddyModel alloc] init];
    self.requestingBuddy = [[BuddyModel alloc] init];
    self.acceptedBuddy = [[BuddyModel alloc] init];
    
    self.unreadMsgArr = [NSMutableArray arrayWithCapacity:capacity];
    self.receivedMsg = [[MsgModel alloc] init];

}

@end

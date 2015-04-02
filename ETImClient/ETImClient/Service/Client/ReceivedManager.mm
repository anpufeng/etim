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

- (id)init {
    if (self = [super init]) {
        int capacity = 10;
        self.buddyArr = [NSMutableArray arrayWithCapacity:capacity];
        self.reqArr = [NSMutableArray arrayWithCapacity:capacity];
        self.reqBuddyArr = [NSMutableArray arrayWithCapacity:capacity];

        self.loginBuddy = [[BuddyModel alloc] init];
        self.searchedBuddy = [[BuddyModel alloc] init];
        self.unreadMsgArr = [NSMutableArray arrayWithCapacity:10];
        self.receivedMsg = [[MsgModel alloc] init];
    }
    
    return self;
}

@end

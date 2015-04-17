//
//  DBManager.m
//  ETImClient
//
//  Created by xuqing on 15/4/17.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "DBManager.h"

static NSString *const localDbName = @"etim.db";


@implementation DBManager

static DBManager *sharedDBManager = nil;
static dispatch_once_t predicate;


+(DBManager*)sharedInstance{
    dispatch_once(&predicate, ^{
        sharedDBManager = [[DBManager alloc]init];
        //忽略send产生的sigpipe信号
        signal(SIGPIPE, SIG_IGN);
    });
    
    return sharedDBManager;
}

- (id)init {
    if (self = [super init]) {
        [self initDataBase];
    }
    
    return self;
}

- (void)initDataBase {
    
}

- (NSString *)localDbPath {
    return nil;
}
@end

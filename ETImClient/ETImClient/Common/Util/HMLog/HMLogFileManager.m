//
//  HMLogFileManager.m
//  TestHMLog
//
//  Created by xuqing on 15/3/4.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMLogFileManager.h"



@implementation HMLogFileManager

+ (NSString *)logDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"ETIMLogs"];
    
    return logsDirectory;
}

- (id)init {
    if (self = [super initWithLogsDirectory:[[self class] logDirectory]]) {
        
    }
    
    return self;
}


@end



@implementation HMDebugLogFileManager

+ (NSString *)logDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"DebugLogs"];
    
    return logsDirectory;
}

- (id)init {
    if (self = [super initWithLogsDirectory:[[self class] logDirectory]]) {
        
    }
    
    return self;
}


@end

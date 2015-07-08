//
//  HMLog.m
//  TestHMLog
//
//  Created by xuqing on 15/3/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMLog.h"
#import "Util.h"
#import "HMLogFileManager.h"
#import "HMLogFormatter.h"
#import "HMFileLogger.h"
#import "DDLog.h"

@interface HMLog () {
}

@property (nonatomic, strong, readwrite) HMFileLogger *fileLogger;


@end

@implementation HMLog

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)start {
    _fileLogger = [[HMFileLogger alloc] initWithLogFileManager:[[HMLogFileManager alloc] init]];
    
    _fileLogger.maximumFileSize  = 1024 * 1  * 500;  // 500 KB
    _fileLogger.rollingFrequency =   60 * 60 * 24 * 7;  // 7 days
    
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [_fileLogger setLogFormatter:[[HMLogFormatter alloc] init]];
    
    [[DDTTYLogger sharedInstance] setLogFormatter:[[HMTTYLogFormatter alloc] init]];
    
    [DDLog addLogger:_fileLogger];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // Sends log statements to Xcode console - if available
    //setenv("XcodeColors", "YES", 1);
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
}

@end

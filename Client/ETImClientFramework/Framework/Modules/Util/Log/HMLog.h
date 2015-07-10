//
//  HMLog.h
//  TestHMLog
//
//  Created by xuqing on 15/3/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

#ifdef DEBUG

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

#define NSLog(...) NSLog(__VA_ARGS__)

#else

static const DDLogLevel ddLogLevel = DDLogLevelOff;

#define NSLog(...) {}
#define assert(e) ((void)0)
#define NSAssert(condition, desc, ...) do {} while (0)
#define NSCAssert(condition, desc, ...) do {} while (0)

#endif

#define HMLogVerbose(frmt, ...) DDLogVerbose(frmt, ##__VA_ARGS__)

#define HMLogDebug(frmt, ...) DDLogDebug(frmt, ##__VA_ARGS__)

#define HMLogInfo(frmt, ...) DDLogInfo(frmt, ##__VA_ARGS__)

#define HMLogWarn(frmt, ...) DDLogWarn(frmt, ##__VA_ARGS__)

#define HMLogError(frmt, ...) DDLogError(frmt, ##__VA_ARGS__)


@class HMFileLogger;

////上传及记录日志管理 

@interface HMLog : NSObject

@property (nonatomic, strong, readonly) HMFileLogger *fileLogger;

- (void)start;


@end

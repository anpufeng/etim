//
//  HMLogFormatter.h
//  TestHMLog
//
//  Created by xuqing on 15/3/4.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SPECIAL_LOG_ERROR_PREFIX       @"__HMSpecialLogPrefix"
#define SPECIAL_LOG_POST_PARAM          @"__HMSpecialLogPostParam"

////日志格式文件

@interface HMLogFormatter : NSObject <DDLogFormatter>

- (NSDictionary *)formatLogMessageDic:(DDLogMessage *)logMessage;
///根据logbody返回info
- (NSDictionary *)logInfo:(id)logBody;

@end


@interface HMTTYLogFormatter : NSObject <DDLogFormatter>


@end

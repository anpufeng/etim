//
//  HMLog.h
//  TestHMLog
//
//  Created by xuqing on 15/3/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMFileLogger;

////上传及记录日志管理 

@interface HMLog : NSObject

@property (nonatomic, strong, readonly) HMFileLogger *fileLogger;

- (void)start;


@end

//
//  NSDate+Additions.h
//  ETImClient
//
//  Created by xuqing on 15/4/22.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ///yyyy-MM-dd
    DateFormatTypeShort = 0,
    ///yyyy-MM-dd HH:mm:ss
    DateFormatTypeLong,
    ///HH:MM
    DateFormatTypeShortTime,
    ///yyyymmddhh24miss
    DateFormatTypeNoDashLong,
    ///MM-dd HH:mm
    DateFormatTypeSimple
} DateFormatType;



@interface NSDate (Additions)

///根据类型及日期返回日期字符串
+ (NSString *)dateStr:(NSDate *)date type:(DateFormatType)type;
///根据类型返回datefomatter
+ (NSDateFormatter *)dateFormatterWithType:(DateFormatType)type;
///根据日期字符串及类型返回日期
+ (NSDate *)dateFromStr:(NSString *)dateStr type:(DateFormatType)type;

@end

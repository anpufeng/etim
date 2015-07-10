//
//  NSDate+Formatter.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)


+ (NSString *)dateStr:(NSDate *)date type:(DateFormatType)type {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (type == DateFormatTypeLong) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else if (type == DateFormatTypeShortTime){
        [dateFormatter setDateFormat:@"HH:mm"];
    } else if (type == DateFormatTypeNoDashLong) {
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    } else if(type == DateFormatTypeSimple){
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSDateFormatter *)dateFormatterWithType:(DateFormatType)type {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (type == DateFormatTypeLong) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else if (type == DateFormatTypeShortTime){
        [dateFormatter setDateFormat:@"HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    return dateFormatter;
}

+ (NSDate *)dateFromStr:(NSString *)dateStr type:(DateFormatType)type {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (type == DateFormatTypeLong) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    return [dateFormatter dateFromString:dateStr];
}


@end

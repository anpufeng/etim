//
//  NSDate+Additions.m
//  ETImClient
//
//  Created by xuqing on 15/4/22.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSString *)dateStr:(NSDate *)date type:(DateFormatType)type {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (type == DateFormatTypeLong) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else if (type == DateFormatTypeShortTime){
        [dateFormatter setDateFormat:@"HH:mm"];
    } else if (type == DateFormatTypeNoDashLong) {
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    }else if(type == DateFormatTypeSimple){
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }else {
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
//
//  NSNumber+Safe.m
//  Juanpi
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "NSNumber+Safe.h"

@implementation NSNumber (Safe)

- (BOOL)safeIsEqualToNumber:(NSNumber *)number
{
    if (number == nil) {
        return NO;
    } else {
        return [self isEqualToNumber:number];
    }
}

- (NSComparisonResult)safeCompare:(NSNumber *)otherNumber
{
    if (otherNumber == nil) {
        return NSOrderedDescending;
    } else {
        return [self compare:otherNumber];
    }
}

@end

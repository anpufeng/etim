//
//  NSString+Safe.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSString+Safe.h"
#import "JRSwizzle.h"

@implementation NSString (Safe)

+ (void)load {

}

- (NSString *)hm_substringFromIndex:(NSUInteger)from
{
    if (from > self.length) {
        return nil;
    } else {
        return [self hm_substringFromIndex:from];
    }
}

- (NSString *)hm_substringToIndex:(NSUInteger)to
{
    if (to > self.length) {
        return nil;
    } else {
        return [self hm_substringToIndex:to];
    }
}

- (NSString *)hm_substringWithRange:(NSRange)range
{
    if (range.location + range.length > self.length) {
        return nil;
    } else {
        return [self hm_substringWithRange:range];
    }
}

- (NSRange)hm_rangeOfString:(NSString *)aString
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self hm_rangeOfString:aString];
    }
}

- (NSRange)hm_rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self hm_rangeOfString:aString options:mask];
    }
}

- (NSString *)hm_stringByAppendingString:(NSString *)aString
{
    if (aString == nil) {
        return [self hm_stringByAppendingString:@""];
    } else {
        return [self hm_stringByAppendingString:aString];
    }
}

- (id)hm_initWithString:(NSString *)aString
{
    if (aString == nil) {
        return [self hm_initWithString:@""];
    } else {
        return [self hm_initWithString:aString];
    }
}

+ (id)hm_stringWithString:(NSString *)string
{
    if (string == nil) {
        return [self hm_stringWithString:@""];
    } else {
        return [self hm_stringWithString:string];
    }
}

@end

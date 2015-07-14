//
//  NSString+Safe.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Safe)

- (NSString *)hm_substringFromIndex:(NSUInteger)from;

- (NSString *)hm_substringToIndex:(NSUInteger)to;

- (NSString *)hm_substringWithRange:(NSRange)range;

- (NSRange)hm_rangeOfString:(NSString *)aString;

- (NSRange)hm_rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask;

- (NSString *)hm_stringByAppendingString:(NSString *)aString;

- (id)hm_initWithString:(NSString *)aString;

+ (id)hm_stringWithString:(NSString *)string;

@end

//
//  NSArray+Safe.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)

- (id)hm_objectAtIndex:(NSUInteger)index;
//mutable array
- (id)hm_objectAtIndexMutable:(NSUInteger)index;

+ (instancetype)hm_ArrayWithObject:(id)object;

@end

//
//  NSArray+Safe.m
//  Juanpi
//
//  Created by huang jiming on 13-1-17.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import "NSArray+Safe.h"
#import "NSObject+Swizzle.h"

@implementation NSArray (Safe)

+ (void)load
{
    [self overrideMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safeObjectAtIndexedSubscript:)];
}

- (id)safeObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

+ (instancetype)safeArrayWithObject:(id)object
{
    if (object == nil) {
        return [self array];
    } else {
        return [self arrayWithObject:object];
    }
}

@end

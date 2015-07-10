//
//  NSMutableArray+Safe.m
//  Juanpi
//
//  Created by xuexiang on 13-8-21.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableArray (Safe)

+ (void)load
{
    [self overrideMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(safeSetObject:atIndexedSubscript:)];
}

- (void)safeSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    if (obj == nil) {
        return ;
    }

    if (self.count < idx) {
        return ;
    }

    if (idx == self.count) {
        [self addObject:obj];
    } else {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
}

- (void)safeAddObject:(id)object
{
	if (object == nil) {
		return;
	} else {
        [self addObject:object];
    }
}

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index
{
	if (object == nil) {
		return;
	} else if (index > self.count) {
		return;
	} else {
        [self insertObject:object atIndex:index];
    }
}

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs
{
    if (indexs == nil) {
        return;
    } else if (indexs.count!=objects.count || indexs.firstIndex>=objects.count || indexs.lastIndex>=objects.count) {
        return;
    } else {
        [self insertObjects:objects atIndexes:indexs];
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
	if (index >= self.count) {
		return;
	} else {
        [self removeObjectAtIndex:index];
    }
}

@end

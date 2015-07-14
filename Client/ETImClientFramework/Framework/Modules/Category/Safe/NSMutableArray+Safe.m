//
//  NSMutableArray+Safe.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "JRSwizzle.h"

@implementation NSMutableArray (Safe)

+ (void)load {
    NSError *err1;
    NSError *err2;
    NSError *err3;
    BOOL result = ([[[NSMutableArray array] class] jr_swizzleMethod:@selector(addObject:)
                                                            withMethod:@selector(hm_addObject:)
                                                                 error:&err1]
                   && [[[NSMutableArray array] class] jr_swizzleMethod:@selector(insertObject:atIndex:)
                                                                      withMethod:@selector(hm_insertObject:atIndex:)
                                                                           error:&err2]
                   && [[[NSMutableArray array] class] jr_swizzleMethod:@selector(insertObjects:atIndexes:)
                                                            withMethod:@selector(hm_insertObjects:atIndexes:)
                                                                 error:&err2]
                   && [[[NSMutableArray array] class] jr_swizzleMethod:@selector(removeObjectAtIndex:)
                                                            withMethod:@selector(hm_removeObjectAtIndex:)
                                                                 error:&err3]);
    
#ifdef DEBUG
    NSAssert(result, ([NSString stringWithFormat:@"err1 : %@, err2: %@", err1, err2]));
#endif
}


- (void)hm_addObject:(id)object
{
	if (object == nil) {
		return;
	} else {
        [self hm_addObject:object];
    }
}

- (void)hm_insertObject:(id)object atIndex:(NSUInteger)index
{
	if (object == nil) {
		return;
	} else if (index > self.count) {
		return;
	} else {
        [self hm_insertObject:object atIndex:index];
    }
}

- (void)hm_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs
{
    if (indexs == nil) {
        return;
    } else if (indexs.count!=objects.count || indexs.firstIndex>=objects.count || indexs.lastIndex>=objects.count) {
        return;
    } else {
        [self hm_insertObjects:objects atIndexes:indexs];
    }
}

- (void)hm_removeObjectAtIndex:(NSUInteger)index
{
	if (index >= self.count) {
		return;
	} else {
        [self hm_removeObjectAtIndex:index];
    }
}

@end

//
//  NSArray+Safe.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSArray+Safe.h"
#import "JRSwizzle.h"

@implementation NSArray (Safe)

+ (void)load {
    NSError *err1;
    NSError *err2;
    NSError *err3;
    BOOL result = ([[[NSArray array] class] jr_swizzleMethod:@selector(objectAtIndex:)
                                                  withMethod:@selector(hm_objectAtIndex:)
                                                       error:&err1]
                   && [[[NSMutableArray array] class] jr_swizzleMethod:@selector(objectAtIndex:)
                                                         withMethod:@selector(hm_objectAtIndexMutable:)
                                                              error:&err2]
                   && [[[NSArray array] class] jr_swizzleMethod:@selector(arrayWithObject:)
                                                         withMethod:@selector(hm_ArrayWithObject:)
                                                                 error:&err3]);
    
#ifdef DEBUG
    NSAssert(result, ([NSString stringWithFormat:@"err1 : %@, err2: %@, err3 : %@", err1, err2, err3]));
#endif
}

- (id)hm_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
#ifdef DEBUG
        NSAssert(NO, @"out of bounds");
        HMLogError(@"self %@ out of bounds", self);
#endif
        return nil;
    } else {
        return [self hm_objectAtIndex:index];
    }
}

- (id)hm_objectAtIndexMutable:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return [self hm_objectAtIndexMutable:index];
    }
}

+ (instancetype)hm_ArrayWithObject:(id)object
{
    if (object == nil) {
        return [self array];
    } else {
        return [self hm_ArrayWithObject:object];
    }
}

@end

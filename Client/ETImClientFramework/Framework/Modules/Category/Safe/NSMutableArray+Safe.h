//
//  NSMutableArray+Safe.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

- (void)hm_addObject:(id)object;

- (void)hm_insertObject:(id)object atIndex:(NSUInteger)index;

- (void)hm_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs;

- (void)hm_removeObjectAtIndex:(NSUInteger)index;

@end

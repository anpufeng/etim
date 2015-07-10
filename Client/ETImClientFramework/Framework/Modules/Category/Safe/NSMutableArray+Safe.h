//
//  NSMutableArray+Safe.h
//  Juanpi
//
//  Created by xuexiang on 13-8-21.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

- (void)safeAddObject:(id)object;

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index;

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

@end

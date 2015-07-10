//
//  NSArray+Safe.h
//  Juanpi
//
//  Created by huang jiming on 13-1-17.
//  Copyright (c) 2013年 Juanpi. All rights reserved.//ii
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index;

+ (instancetype)safeArrayWithObject:(id)object;

@end

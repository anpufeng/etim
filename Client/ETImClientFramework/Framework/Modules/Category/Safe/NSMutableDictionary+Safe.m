//
//  NSMutableDictionary+Safe.m
//  Juanpi
//
//  Created by airspuer on 13-5-8.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableDictionary(Safe)

+ (void)load
{
    [self overrideMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(safeSetObject:forKeyedSubscript:)];
}

- (void)safeSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key) {
        return ;
    }

    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return ;
    }

    [self setObject:obj forKey:key];
}

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && ![aObj isKindOfClass:[NSNull class]] && aKey) {
        [self setObject:aObj forKey:aKey];
    } else {
        return;
    }
}

- (id)safeObjectForKey:(id<NSCopying>)aKey
{
    if (aKey != nil) {
        return [self objectForKey:aKey];
    } else {
        return nil;
    }
}

@end

//
//  NSMutableDictionary+Safe.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "JRSwizzle.h"

@implementation NSMutableDictionary (Safe)

+ (void)load {
    NSError *err1;
    BOOL result = ([[[NSMutableDictionary dictionary] class] jr_swizzleMethod:@selector(setObject:forKey:)
                                                            withMethod:@selector(hm_setObject:forKey:)
                                                                 error:&err1]);
    
#ifdef DEBUG
    NSAssert(result, ([NSString stringWithFormat:@"err1 : %@", err1]));
#endif
}

- (void)hm_setObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && ![aObj isKindOfClass:[NSNull class]] && aKey) {
        [self hm_setObject:aObj forKey:aKey];
    } else {
        return;
    }
}


@end

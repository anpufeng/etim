//
//  NSDictionary+Safe.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "JRSwizzle.h"

@implementation NSDictionary (Safe)

+ (void)load {
    NSError *err1;
    NSError *err2;
    BOOL result = ([[[NSDictionary dictionary] class] jr_swizzleMethod:@selector(objectForKey:)
                                                  withMethod:@selector(hm_objectForKey:)
                                                       error:&err1]
                   && [[[NSMutableDictionary dictionary] class] jr_swizzleMethod:@selector(objectForKey:)
                                                            withMethod:@selector(hm_objectForKeyMutable:)
                                                                 error:&err2]);
    
#ifdef DEBUG
    NSAssert(result, ([NSString stringWithFormat:@"err1 : %@, err2: %@", err1, err2]));
#endif
}

- (id)hm_objectForKey:(id<NSCopying>)aKey {
    if (aKey != nil) {
        return [self hm_objectForKey:aKey];
    } else {
        return nil;
    }
}
- (id)hm_objectForKeyMutable:(id<NSCopying>)aKey {
    if (aKey != nil) {
        return [self hm_objectForKeyMutable:aKey];
    } else {
        return nil;
    }
}

@end

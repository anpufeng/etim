//
//  NSMutableDictionary+Safe.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(Safe)

- (void)hm_setObject:(id)aObj forKey:(id<NSCopying>)aKey;


@end

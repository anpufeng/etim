//
//  NSDictionary+Safe.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (id)hm_objectForKey:(id<NSCopying>)aKey;
- (id)hm_objectForKeyMutable:(id<NSCopying>)aKey;

@end

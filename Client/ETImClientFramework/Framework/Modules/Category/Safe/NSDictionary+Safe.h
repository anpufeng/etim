//
//  NSDictionary+Safe.h
//  Juanpi
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key;

@end

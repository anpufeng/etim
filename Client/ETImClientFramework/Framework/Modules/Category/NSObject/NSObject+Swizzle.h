//
//  NSObject+swizzle.h
//  Juanpi
//
//  Created by Aimy on 14-1-2.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+ (BOOL)overrideMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;
+ (BOOL)exchangeMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)exchangeClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;

@end

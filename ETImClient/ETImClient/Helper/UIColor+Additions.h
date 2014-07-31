//
//  UIColor+Additions.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//
//  @author 
//  @abstract UIColor扩展
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

///hex string转颜色

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

///hex string转颜色+透明度
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

@end


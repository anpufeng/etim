//
//  UIColor+Hex.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/13.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

@end

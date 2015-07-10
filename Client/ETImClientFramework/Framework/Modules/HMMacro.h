//
//  HMMacro.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#ifndef ETImClientFramework_HMMacro_h
#define ETImClientFramework_HMMacro_h

///版本及屏幕类
#define IOS7                                    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS8                                    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define CURRENT_SYSTEM_VERSION                  [[[UIDevice currentDevice] systemVersion] floatValue]


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//4/4s      3.5inch
#define IS_IPHONE3_5  CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
//5/5c/5s   4 inch
#define IS_IPHONE4_0  CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
//6         4.7 inch
#define IS_IPHONE4_7  CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
//6 plus    5.5 inch
#define IS_IPHONE5_5  CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)

/*================================    尺寸相关      =============================================*/

#define RECT_ORIGIN_X(view)                         (CGRectGetMinX(view.frame))
#define RECT_ORIGIN_Y(view)                         (CGRectGetMinY(view.frame))
#define RECT_WIDTH(view)                            (CGRectGetWidth(view.frame))
#define RECT_HEIGHT(view)                           (CGRectGetHeight(view.frame))
#define RECT_MAX_X(view)                            (CGRectGetMaxX(view.frame))
#define RECT_MAX_Y(view)                            (CGRectGetMaxY(view.frame))

#define SCREEN_SIZE           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height          //包含状态bar的高度(e.g. 480)
#define SCREEN_SCALE          [[UIScreen mainScreen] scale]

#define APPLICATION_SIZE      [[UIScreen mainScreen] applicationFrame].size       //(e.g. 320,460)
#define APPLICATION_WIDTH     [[UIScreen mainScreen] applicationFrame].size.width //(e.g. 320)
#define APPLICATION_HEIGHT    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)



///角度
#define DEGREE_TO_RADIANS(d)  (d * M_PI / 180)
///release后置nil
#define CARELEASE(obj) { [obj release]; obj = nil; }

///常用的FONT
#define FONT(size)                                   ([UIFont systemFontOfSize:size])
#define BOLD_FONT(size)                              ([UIFont boldSystemFontOfSize:size])

///RGB颜色
#define RGB_TO_UICOLOR(r, g, b)                     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGB_TO_UICOLOR_ALPHA(r, g, b, a)            [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define UI_CLEAR_COLOR                              [UIColor clearColor]

///十六进制色值
#define HEX_COLOR(hex)                              ([UIColor colorWithHexString:hex])
///十六进制色值+透明度
#define HEX_COLOR_ALPHA(hex, alpha)                 ([UIColor colorWithHexString:hex alpha:alpha])


///普通图片获取
#define IMAGE(name)                                 ([UIImage imageWithBundleImageName:name])
///2x类png
#define IMAGE_PNG(name)                             ([UIImage imageWithBundleImageName:name ofType:@"png"])
///2x类jpg
#define IMAGE_JPG(name)                             ([UIImage imageWithBundleImageName:name ofType:@"jpg"])
///2x类type类的图片
#define IMAGE_TYPE(name, type)                      ([UIImage imageWithBundleImageName:name ofType:type])

///一些快捷类的
#define CAARRAY_LENGTH(arr)                         (sizeof(arr) / sizeof(*(arr)))
#define GET_STRING_FROM_CAARRAY_SAFELY(arr, idx)    (((idx) >= 0) && (((idx) < CArrayLength(arr))) ? (arr)[idx] : @"")
#define GET_NUMBER_FROM_CAARRAY_SAFELY(arr, idx)    (((idx) >= 0) && (((idx) < CArrayLength(arr))) ? (arr)[idx] : 0)
#define NSNUM_WITH_INT(i)                           ([NSNumber numberWithInt:(i)])
#define NSNUM_WITH_FLOAT(f)                         ([NSNumber numberWithFloat:(f)])
#define NSNUM_WITH_DOUBLE(d)                        ([NSNumber numberWithDouble:(d)])
#define NSNUM_WITH_BOOL(b)                          ([NSNumber numberWithBool:(b)])
#define NSNUM_WITH_UNSIGNED_INTEGER(u)              ([NSNumber numberWithUnsignedInteger:u])
#define INT_FROM_NSNUM(n)                           ([(n) intValue])
#define FLOAT_FROM_NSNUM(n)                         ([(n) floatValue])
#define BOOL_FROM_NSNUM(n)                          ([(n) boolValue])
#define NSOBJ_TO_STRING(o)                          [NSString stringWithFormat:@"%@", (o)]
#define INT_TO_STRING(i)                            [NSString stringWithFormat:@"%d", (i)]
#define DOUBLE_TO_STRING(i)                         [NSString stringWithFormat:@"%lf", (i)]

/// 常用判断
#define CONTINUE_IF(expr)                           if ((expr))  { continue;     }
#define BREAK_IF(expr)                              if ((expr))  { break;        }
#define RETURN_IF(expr)                             if ((expr))  { return;       }
#define RETURN_VAL_IF(expr, val)                    if ((expr))  { return (val); }
#define CONTINUE_IF_NOT(expr)                       if (!(expr)) { continue;     }
#define BREAK_IF_NOT(expr)                          if (!(expr)) { break;        }
#define RETURN_IF_NOT(expr)                         if (!(expr)) { return;       }
#define RETURN_VAL_IF_NOT(expr, val)                if (!(expr)) { return (val); }




#endif

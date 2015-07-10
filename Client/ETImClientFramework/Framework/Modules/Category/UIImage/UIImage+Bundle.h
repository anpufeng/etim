//
//  UIImage+Bundle.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 无缓存
 **/
@interface UIImage (Bundle)

+ (id)imageWithMainBundle:(NSString *)imgName;
+ (id)imageWithMainBundle:(NSString *)imgName type:(NSString *)type;

+ (id)imageWithBundle:(NSString *)aBundle imageName:(NSString *)imgName;
+ (id)imageWithBundle:(NSString *)aBundle imageName:(NSString *)imgName type:(NSString *)type;

///获取在main bundle中的图片
+ (id)imageWithBundleImageName:(NSString *)strImageName;

///获取在main bundle中的图片, 用于2x类图片
+ (id)imageWithBundleImageName:(NSString *)strImageName ofType:(NSString *)ext;

@end

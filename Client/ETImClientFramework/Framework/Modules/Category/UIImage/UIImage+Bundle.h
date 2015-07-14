//
//  UIImage+Bundle.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 无缓存 从对应的bundle获取图片
 **/
@interface UIImage (Bundle)

+ (id)imageWithMainBundle:(NSString *)name;
+ (id)imageWithMainBundle:(NSString *)name extension:(NSString *)extension;

+ (id)imageWithBundle:(NSString *)aBundle imageName:(NSString *)name;
+ (id)imageWithBundle:(NSString *)aBundle imageName:(NSString *)name extension:(NSString *)extension;


@end

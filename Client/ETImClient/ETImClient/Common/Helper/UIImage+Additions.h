//
//  UIImage+Additions.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//
//  @author
//  @abstract UIImage扩展
//

#import <UIKit/UIKit.h>



@interface UIImage (Additions)

///获取在main bundle中的图片
+ (id)imageWithBundleImageName:(NSString *)strImageName;

///获取在main bundle中的图片, 用于2x类图片
+ (id)imageWithBundleImageName:(NSString *)strImageName ofType:(NSString *)ext;

///根据图片生成生成圆角图片
+ (UIImage*)circleImage:(UIImage*)image inset:(CGFloat)inset radius:(CGFloat)radidus;

///图像伸缩 取图片的一半
+ (UIImage *)resizeImage:(NSString *)imageName cached:(BOOL)cache;

- (UIImage *)fixOrientation;
///获取灰色图像
- (UIImage *)grayImage;
@end

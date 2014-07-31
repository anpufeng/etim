//
//  UIImage+Additions.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)


+ (id)imageWithBundleImageName:(NSString *)strImageName {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:strImageName ofType:nil];
    
    NSAssert(strPath, @"image not exist in main bundle: %@", strImageName);
    
    return [UIImage imageWithContentsOfFile:strPath];
}

+ (id)imageWithBundleImageName:(NSString *)strImageName ofType:(NSString *)ext {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:strImageName ofType:ext];
    if (!strPath) {
        strPath = [[NSBundle mainBundle] pathForResource:[strImageName stringByAppendingString:@"@2x"] ofType:ext];
    }
    
    NSAssert(strPath, @"image not exist in main bundle: %@", strImageName);
    
    return [UIImage imageWithContentsOfFile:strPath];
}

+ (UIImage*)circleImage:(UIImage*)image inset:(CGFloat)inset radius:(CGFloat)radidus {
    CGFloat min = image.size.width > image.size.height ? image.size.height : image.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(min, min));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, min - inset * 2.0f, min - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
    
    //    UIGraphicsBeginImageContext(image.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(context, 15);
    //    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    //    CGRect rect = CGRectMake(inset, inset, radidus - inset * 2.0f, radidus - inset * 2.0f);
    //    CGContextAddEllipseInRect(context, rect);
    //    CGContextClip(context);
    //
    //    [image drawInRect:rect];
    //    CGContextAddEllipseInRect(context, rect);
    //    CGContextStrokePath(context);
    //    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return newimg;
}


- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end

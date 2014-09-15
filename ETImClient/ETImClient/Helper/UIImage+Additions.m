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

+ (UIImage *)resizeImage:(NSString *)imageName cached:(BOOL)cache
{
    UIImage *image = nil;
    if (cache) {
        image = [UIImage imageNamed:imageName];
    } else {
        image = IMAGE_PNG(imageName);
    }
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
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

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

- (UIImage *)grayImage {
    CGSize size = [self size];
    int width = size.width;
    int height = size.height;
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}
@end

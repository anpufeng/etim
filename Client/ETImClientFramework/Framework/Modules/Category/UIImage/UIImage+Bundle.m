//
//  UIImage+Bundle.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

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

@end

//
//  UIImage+Bundle.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (id)imageWithMainBundle:(NSString *)name {
    return [[self class] imageWithBundle:@"Main" imageName:name extension:@"png"];
}
+ (id)imageWithMainBundle:(NSString *)name extension:(NSString *)extension {
    return [[self class] imageWithBundle:@"Main" imageName:name extension:extension];
}

+ (id)imageWithBundle:(NSString *)aBundle imageName:(NSString *)name {
    return [[self class] imageWithBundle:aBundle imageName:name extension:@"png"];
}
+ (id)imageWithBundle:(NSString *)aBundle imageName:(NSString *)name extension:(NSString *)extension {
    NSBundle *bundle;
    if ([aBundle isEqualToString:@"Main"]) {
        bundle = [NSBundle mainBundle];
    } else {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundle withExtension:@"bundle"]];
    }
    NSString *strPath = [bundle pathForResource:name ofType:extension];
    if (!strPath) {
        strPath = [bundle pathForResource:[name stringByAppendingString:@"@2x"] ofType:extension];
    }

    
    NSAssert(strPath, @"image not exist in main bundle: %@", strPath);
    
     return [UIImage imageWithContentsOfFile:strPath];
}


@end

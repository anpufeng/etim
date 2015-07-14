//
//  NSString+App.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSString+App.h"

@implementation NSString (App)

// Get My Application Version number
+ (NSString *)appBundleVersion
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleVersion"];
    return version;
}

// Get My Application name
+ (NSString *)appDisplayName
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}

+ (NSString *)appShortVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *shortVersion = [info objectForKey:@"CFBundleShortVersionString"];
    return shortVersion;
}


@end

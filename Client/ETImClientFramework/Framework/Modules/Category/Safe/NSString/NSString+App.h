//
//  NSString+App.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (App)

/**
 CFBundleVersion  1  2
 */
+ (NSString *)appBundleVersion;
/**
 CFBundleDisplayName
 **/
+ (NSString *)appDisplayName;
/**
 1.0 1.1.0
 */
+ (NSString *)appShortVersion;


@end

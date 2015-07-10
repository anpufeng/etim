//
//  HMFileManager.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

///关于文件管理  例如创建 删除等, 文件存储

@interface HMFileManager : NSObject

/**
 file or directory
 **/
+ (BOOL)fileExist:(NSString *)path;
+ (BOOL)createDir:(NSString *)dir;
+ (BOOL)deleteItemAtPath:(NSString *)path;

/**
 沙盒document
 **/
+ (NSString *)documentDir;
/**
 沙盒caches
 **/
+ (NSString *)cachesDir;
/**
 沙盒tmp
 **/
+ (NSString *)tmpDir;

@end

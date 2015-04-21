//
//  UtilFileManager.h
//  Listening
//
//  Created by ethan on 15/1/24.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

///关于文件管理  例如创建 删除等, 文件存储

@interface UtilFileManager : NSObject

+ (BOOL)fileExist:(NSString *)path;
+ (BOOL)createDir:(NSString *)dir;
+ (BOOL)deleteDir:(NSString *)dir;
+ (NSString *)documentDir;
+ (NSString *)cachesDir;
+ (NSString *)tmpDir;

@end

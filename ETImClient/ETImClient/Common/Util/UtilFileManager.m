//
//  UtilFileManager.m
//  Listening
//
//  Created by ethan on 15/1/24.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "UtilFileManager.h"

#define defaultManager [NSFileManager defaultManager]

@implementation UtilFileManager

+ (BOOL)fileExist:(NSString *)path {
       BOOL result = [defaultManager fileExistsAtPath:path];
    if (!result) {
        DDLogWarn(@"file not exist : %@", path);
    }
    
    return result;
}

+ (BOOL)createDir:(NSString *)dir {
    __autoreleasing NSError *err;
    BOOL result = [defaultManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
    if (!result) {
        DDLogError(@"createDir error : %@ ", err);
    }
    
    return result;
}

+ (BOOL)deleteDir:(NSString *)dir {
    __autoreleasing NSError *err;
    BOOL result =  [defaultManager removeItemAtPath:dir error:&err];
    if (err) {
        DDLogWarn(@"deleteDir error: %@", err);
    }
    
    return result;
}
+ (NSString *)documentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSAssert([paths count], @"documentDir");
    NSString *docDir = [paths objectAtIndex:0];
    
    return docDir;
}

+ (NSString *)cachesDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSAssert([paths count], @"cachesDir");
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString *)tmpDir {
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

@end

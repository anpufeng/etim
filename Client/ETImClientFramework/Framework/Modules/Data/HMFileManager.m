//
//  HMFileManager.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMFileManager.h"

#define defaultManager [NSFileManager defaultManager]

@implementation HMFileManager

+ (BOOL)fileExist:(NSString *)path {
    BOOL result = [defaultManager fileExistsAtPath:path];
    if (!result) {
        HMLogWarn(@"file not exist : %@", path);
    }
    
    return result;
}

+ (BOOL)createDir:(NSString *)dir {
    __autoreleasing NSError *err;
    BOOL result = [defaultManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
    if (!result) {
        HMLogError(@"createDir error : %@ ", err);
    }
    
    return result;
}

+ (BOOL)deleteItemAtPath:(NSString *)path {
    __autoreleasing NSError *err;
    BOOL result =  [defaultManager removeItemAtPath:path error:&err];
    if (err) {
        HMLogWarn(@"deleteDir error: %@", err);
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

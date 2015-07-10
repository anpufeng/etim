//
//  UIViewController+Class.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSObject+Class.h"

@implementation NSObject (Class)

- (BOOL)isArrClass {
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)isMutableArrClass {
    return [self isKindOfClass:[NSMutableArray class]];
}

- (BOOL)isDicClass {
    return [self isKindOfClass:[NSDictionary class]];
}
- (BOOL)isMutableDicClass {
    return [self isKindOfClass:[NSMutableDictionary class]];
}
- (BOOL)isStrClass {
    return [self isKindOfClass:[NSString class]];
}
- (BOOL)isMutableStrClass {
    return [self isKindOfClass:[NSMutableString class]];
}
- (BOOL)isNumberClass {
    return [self isKindOfClass:[NSNumber class]];
}



- (BOOL)isMemberArrClass {
    return [self isMemberOfClass:[NSArray class]];
}
- (BOOL)isMemberMutableArrClass {
    return [self isMemberOfClass:[NSMutableArray class]];
}
- (BOOL)isMembeDicClass {
    return [self isMemberOfClass:[NSDictionary class]];
}
- (BOOL)isMembeMutableDicClass {
    return [self isMemberOfClass:[NSMutableDictionary class]];
}
- (BOOL)isMembeStrClass {
    return [self isMemberOfClass:[NSString class]];
}
- (BOOL)isMembeMutableStrClass {
    return [self isMemberOfClass:[NSMutableString class]];
}
- (BOOL)isMembeNumberClass {
    return [self isMemberOfClass:[NSNumber class]];
}

@end

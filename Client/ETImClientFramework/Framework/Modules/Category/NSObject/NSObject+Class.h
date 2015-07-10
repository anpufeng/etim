//
//  UIViewController+Class.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (Class)

- (BOOL)isArrClass;
- (BOOL)isMutableArrClass;
- (BOOL)isDicClass;
- (BOOL)isMutableDicClass;
- (BOOL)isStrClass;
- (BOOL)isMutableStrClass;
- (BOOL)isNumberClass;

- (BOOL)isMemberArrClass;
- (BOOL)isMemberMutableArrClass;
- (BOOL)isMembeDicClass;
- (BOOL)isMembeMutableDicClass;
- (BOOL)isMembeStrClass;
- (BOOL)isMembeMutableStrClass;
- (BOOL)isMembeNumberClass;

@end

//
//  BaseViewController.h
//  Listening
//
//  Created by ethan on 14/12/25.
//  Copyright (c) 2014年 ethan. All rights reserved.
//@author ethan

#import <UIKit/UIKit.h>

///所有VC的基类 定义一些通用处理

@interface HMViewController : UIViewController

- (void)addObserverKeyboard;
- (void)removeObserverKeyword;

@property (nonatomic) BOOL animating;


///添加默认背景
- (void)createDefaultBg;

@end

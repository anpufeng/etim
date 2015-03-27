//
//  BaseViewController.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKTokenController;

///所有ViewController的基类 后面所有的ViewController都要继承此基类(特殊用途除外)
///方便做一些通用处理

@interface BaseViewController : UIViewController


///添加默认背景
- (void)createDefaultBg;

@end


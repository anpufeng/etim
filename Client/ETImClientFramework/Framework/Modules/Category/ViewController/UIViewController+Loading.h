//
//  UIViewController+Loading.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 loading 协议
 **/

@protocol HMLoading <NSObject>

@required

- (void)showLoading;
- (void)showLoadingWithText:(NSString *)text;
- (void)showLoadingWithText:(NSString *)text hideAfter:(NSTimeInterval)seconds;
- (void)showLoadingWithText:(NSString *)text hideAfter:(NSTimeInterval)seconds inView:(UIView *)aView;

- (void)hideLoading;
- (void)hideLoadingInView:(UIView *)aView;

@end;

/**
 加载loading 扩展
 以此vc.view为父view
 **/

@interface UIViewController (Loading) <HMLoading>

@end

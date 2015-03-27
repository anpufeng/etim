//
//  HMScrollView.h
//  Listening
//
//  Created by xuqing on 15/1/29.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

///HMScrollView协议

@protocol HMScrollView <NSObject>

@required

///添加键盘监听
- (void)addKeyboardObserve;
///去除键盘监听
- (void)removeKeyboardObserve;

///显示无数据提示 使用默认图片与文字
- (void)showNoDataView;
/**显示无数据提示 将无数据时显示的图片及文字传进来
 @param noDataImg 无数据时显示的图片
 @param text 无数据时显示的文字
 **/
- (void)showNoDataView:(UIImage *)noDataImg text:(NSString *)text;
///去除无数据提示页面
- (void)removeNoDataView;

/**
 显示出错 例如网络错误或者服务器数据错误 使用默认图片与文字
 @param target 点击重试时响应的对象
 @param action 点击重试时响应的SEL
 **/
- (void)showErrorView:(id)target action:(SEL)action;
/**
 显示出错 例如网络错误或者服务器数据错误
 @param target 点击重试时响应的对象
 @param action 点击重试时响应的SEL
 @param errImg 出错时显示的图片
 @param text 出错时显示的文字
 **/
- (void)showErrorView:(id)target action:(SEL)action image:(UIImage *)errImg text:(NSString *)text;

///去除错误提示页面
- (void)removeErrView;

@end





///所有ScrollView的基类 提供一些通用方法

@interface HMScrollView : UIScrollView <HMScrollView>


@end

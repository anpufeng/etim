//
//  AppDelegate.h
//  ETImClient
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**跳到登录界面
 @param animated 是否有动画操作
*/
- (void)jumpToLogin:(BOOL)animated;

@end

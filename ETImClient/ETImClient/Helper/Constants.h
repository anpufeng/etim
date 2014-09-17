//
//  Constants.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWMessageBarManager.h"
#import "MBProgressHUD.h"

//float
extern const float kStatusBarHeight;
extern const float kNavigationBarHeight;
extern const float kTabBarHeight;
extern const float kCommonBtnHeight44;
extern const float kCommonCellHeight50;
extern const float kCommonCellHeight44;
extern const float kCommonCellHeight60;


extern NSString *const kServerAddress;
///示例, 服务器的请求API都单独拉出来


//enum

typedef enum {
    UserChooseDirectionAny = 0,
	UserChooseDirectionUp,
	UserChooseDirectionDown,
    UserChooseDirectionLeft,
    UserChooseDirectionRight
} UserChooseDirection;


//notification
extern NSString *const kNoConnectionNotification;
extern NSString *const kJumpToChatNotification;

@interface Constants : NSObject

@end

//
//  Constants.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWMessageBarManager.h"


//float
extern const float kStatusBarHeight;
extern const float kNavigationBarHeight;
extern const float kTabBarHeight;




extern NSString *const kServerAddress;
///示例, 服务器的请求API都单独拉出来
extern NSString *const kGetHospitalList;

//enum

typedef enum {
    UserChooseDirectionAny = 0,
	UserChooseDirectionUp,
	UserChooseDirectionDown,
    UserChooseDirectionLeft,
    UserChooseDirectionRight
} UserChooseDirection;


//notification

@interface Constants : NSObject

@end

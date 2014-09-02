//
//  BadgeButton.h
//  ETImClient
//
//  Created by Ethan on 14/8/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

///显示数字的btn

@interface BadgeButton : UIButton

@property (nonatomic, strong) NSString *badge;



- (id)initWithFrame:(CGRect)frame alignment:(JSBadgeViewAlignment)alignment;


@end

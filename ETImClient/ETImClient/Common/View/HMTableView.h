//
//  HMTableView.h
//  Listening
//
//  Created by ethan on 15/1/22.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMScrollView.h"
#import "MJRefresh.h"

///所有TABLEVIEW的基类 提供一些通用方法

@interface HMTableView : UITableView <HMScrollView>

- (void)showNoDataViewWithTableHeader:(UIView *)headerView;

@end

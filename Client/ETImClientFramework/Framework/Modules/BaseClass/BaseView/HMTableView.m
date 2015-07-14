//
//  HMTableView.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMTableView.h"

@implementation HMTableView

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (indexPath.section >= self.numberOfSections) {
        return ;
    }
    else if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return ;
    }
    else {
        return [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    if (indexPath.section >= self.numberOfSections) {
        return;
    }
    else if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return;
    }
    else {
        return [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    }
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.numberOfSections) {
        return nil;
    }
    else if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return nil;
    }
    else {
        return [super cellForRowAtIndexPath:indexPath];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

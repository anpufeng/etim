//
//  UITableView+Safe.m
//  Juanpi
//
//  Created by huang jiming on 14-1-23.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "UITableView+Safe.h"

@implementation UITableView (Safe)

- (void)safeScrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (indexPath.section >= self.numberOfSections) {
        return;
    } else if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return;
    } else {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

- (void)safeSelectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    if (indexPath.section >= self.numberOfSections) {
        return;
    } else if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return;
    } else {
        [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    }
}

- (UITableViewCell *)safeCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.numberOfSections) {
        return nil;
    } else if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return nil;
    } else {
        return [self cellForRowAtIndexPath:indexPath];
    }
}

@end

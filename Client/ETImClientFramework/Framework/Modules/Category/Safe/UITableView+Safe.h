//
//  UITableView+Safe.h
//  Juanpi
//
//  Created by huang jiming on 14-1-23.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (Safe)

- (void)safeScrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)safeSelectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

- (UITableViewCell *)safeCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

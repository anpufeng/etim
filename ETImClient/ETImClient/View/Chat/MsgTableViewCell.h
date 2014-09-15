//
//  ChatTableViewCell.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuddyTableViewCell.h"

///消息界面cell

@interface MsgTableViewCell : BuddyTableViewCell

- (void)update:(NSMutableDictionary *)msg;

@end

//
//  ChatTableViewCell.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTableViewCell.h"

#define textPadding 15

@class ChatCellFrame;

///聊天界面cell

@interface ChatTableViewCell : HMTableViewCell

@property (nonatomic, strong) ChatCellFrame *cellFrame;

@end

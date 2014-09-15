//
//  ChatTableViewCell.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define textPadding 15

@class ChatCellFrame;

///聊天界面cell

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) ChatCellFrame *cellFrame;

@end

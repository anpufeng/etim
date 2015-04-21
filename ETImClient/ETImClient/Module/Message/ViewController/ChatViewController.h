//
//  ChatViewController.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BackViewController.h"

@class ListMsgModel;

///聊天界面 

@interface ChatViewController : BackViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (id)initWithListMsg:(ListMsgModel *)listMsg;


@end

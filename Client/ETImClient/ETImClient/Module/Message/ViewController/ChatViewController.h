//
//  ChatViewController.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "HMBackViewController.h"

@class ListMsgModel;
@class BuddyModel;

///聊天界面 

@interface ChatViewController : HMBackViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (id)initWithUser:(BuddyModel *)user;
- (id)initWithListMsg:(ListMsgModel *)listMsg;

@end

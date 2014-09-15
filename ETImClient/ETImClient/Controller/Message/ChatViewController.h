//
//  ChatViewController.h
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BackViewController.h"

///聊天界面 

@interface ChatViewController : BackViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (id)initWithMsgs:(NSMutableArray *)msgs peer:(BuddyModel *)peer;

@end

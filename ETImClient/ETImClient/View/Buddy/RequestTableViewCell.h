//
//  RequestTableViewCell.h
//  ETImClient
//
//  Created by Ethan on 14/9/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BuddyTableViewCell.h"

@class RequestModel;

@interface RequestTableViewCell : BuddyTableViewCell

- (void)update:(RequestModel *)request;

@end

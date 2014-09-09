//
//  RequestTableViewCell.h
//  ETImClient
//
//  Created by Ethan on 14/9/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BuddyTableViewCell.h"


typedef NS_ENUM(NSInteger, RequestAction) {
    RequestActionReject = 343,
    RequestActionAccept
};

@class RequestModel;

///NewBuddyViewController的request cell

@interface RequestTableViewCell : BuddyTableViewCell

@property (nonatomic, readonly, strong) RequestModel *req;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action;

- (void)update:(RequestModel *)req indexPath:(NSIndexPath *)indexPath;

@end

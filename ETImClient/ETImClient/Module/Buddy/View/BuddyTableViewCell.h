//
//  BuddyTableViewCell.h
//  ETImClient
//
//  Created by Ethan on 14/9/1.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTableViewCell.h"

@class BuddyModel;


///好友的cell

@interface BuddyTableViewCell : HMTableViewCell {
    UIImageView     *_iconImgView;
    UILabel         *_nameLabel;
    UILabel         *_descLabel;
}

- (void)update:(BuddyModel *)buddy;

@end

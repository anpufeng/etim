//
//  RequestTableViewCell.m
//  ETImClient
//
//  Created by Ethan on 14/9/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "RequestTableViewCell.h"
#import "RequestModel.h"
#import "BuddyModel.h"

@interface RequestTableViewCell () {
    UIButton            *_actionBtn;
}

@end

@implementation RequestTableViewCell

/*
 UIImageView     *_iconImgView;
 UILabel         *_nameLabel;
 UILabel         *_descLabel;
 */

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_actionBtn];
    }
    return self;
}

- (void)update:(RequestModel *)req {
    if (req.from.status == kBuddyOnline) {
        _iconImgView.image = [UIImage imageNamed:@"login_avatar_default"];
    } else {
        _iconImgView.image = [[UIImage imageNamed:@"login_avatar_default"] grayImage];
    }
    
    _nameLabel.text = req.from.username;
    _descLabel.text = req.reqStatus;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

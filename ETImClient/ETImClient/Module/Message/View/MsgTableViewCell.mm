//
//  ChatTableViewCell.m
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "MsgTableViewCell.h"
#import "BuddyModel.h"
#import "MsgModel.h"

@interface MsgTableViewCell () {
    /*
     UIImageView     *_iconImgView;
     UILabel         *_nameLabel;
     UILabel         *_descLabel;
     */
    UILabel         *_badgeLabel;
}

@end

@implementation MsgTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(RECT_MAX_X(_iconImgView) - 10, RECT_ORIGIN_Y(_iconImgView) - 10, 30, 30)];
        
        [self.contentView addSubview:_badgeLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)update:(ListMsgModel *)listMsg {
    
    _iconImgView.image = [UIImage imageNamed:@"login_avatar_default"];
    
    _nameLabel.text = [[listMsg lastestMsg] peerName];
    _descLabel.text = listMsg.lastestMsg.text;
    _badgeLabel.textColor = [UIColor redColor];
    _badgeLabel.text = [NSString stringWithFormat:@"%ld", [listMsg unreadMsgCount]];
}

@end

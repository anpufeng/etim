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
    UILabel         *_timeLabel;
    UILabel         *_badgeLabel;
}

@end

@implementation MsgTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(RECT_MAX_X(self) - 180, RECT_ORIGIN_Y(_iconImgView) - 5, 170, 30)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = FONT(12);
        
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(RECT_WIDTH(self) - 30, RECT_ORIGIN_Y(_descLabel) + 4, 20, 20)];
        _badgeLabel.font = FONT(12);
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_timeLabel];
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
    _timeLabel.text = listMsg.lastestMsg.requestTime;
    
    if ([listMsg unreadMsgCount]) {
        //TODO badge模糊
        _badgeLabel.hidden = NO;
        _badgeLabel.text = [NSString stringWithFormat:@"%ld", [listMsg unreadMsgCount]];
        CGSize badgeSize = [_badgeLabel.text sizeWithFont:_badgeLabel.font];
        CGFloat width = badgeSize.width + 4;
        _badgeLabel.frame = CGRectMake(RECT_ORIGIN_X(_badgeLabel), RECT_ORIGIN_Y(_badgeLabel), width, width);
        _badgeLabel.layer.cornerRadius = width/2.0f;
        _badgeLabel.layer.masksToBounds = YES;
    } else {
        _badgeLabel.hidden = YES;
    }

}

@end

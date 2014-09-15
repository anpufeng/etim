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

- (void)update:(NSMutableDictionary *)msg {
    /**
     unread = {
     oneMsg {
     buddy->    BuddyModel,
     msgs->   {MsgModel, MsgModel, MsgModel}
     }
     
     oneMsg {
     ....
     }
     }
     */
    BuddyModel *buddy = [msg objectForKey:@"buddy"];
    NSMutableArray *msgs = [msg objectForKey:@"msgs"];
    MsgModel *lastMsg = [msgs lastObject];
    
    if (buddy.status == kBuddyOnline) {
        _iconImgView.image = [UIImage imageNamed:@"login_avatar_default"];
    } else {
        _iconImgView.image = [[UIImage imageNamed:@"login_avatar_default"] grayImage];
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"[%@] %@", buddy.username, buddy.statusName]; ;
    _descLabel.text = lastMsg.text;
    _badgeLabel.textColor = [UIColor redColor];
    _badgeLabel.text = [NSString stringWithFormat:@"%d", [msgs count]];
}

@end

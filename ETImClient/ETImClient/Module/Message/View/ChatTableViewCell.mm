//
//  ChatTableViewCell.m
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "MsgModel.h"

@interface ChatTableViewCell()
{
    UILabel         *_timeLabel;
    UIImageView     *_iconView;
    UIButton        *_textView;
}
@end

@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:14];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textView];

    }
    return self;
}


- (void)setCellFrame:(ChatCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    MsgModel *message = cellFrame.message;
    
    _timeLabel.frame = cellFrame.timeFrame;
    _timeLabel.text = message.requestTime;
    
    _iconView.frame = cellFrame.iconFrame;
    NSString *textBg;
    UIColor *textColor;
    
    if (message.source == kMsgSourceSelf) {
        textColor = [UIColor blackColor];
        textBg = @"chat_recive_nor";
        _iconView.image = [UIImage imageNamed:@"login_avatar_default"];
      
    } else {
        textColor = [UIColor whiteColor];
        textBg = @"chat_send_nor";
        _iconView.image = [[UIImage imageNamed:@"login_avatar_default"] grayImage];
    }
    _textView.frame = cellFrame.textFrame;
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg cached:YES] forState:UIControlStateNormal];
    [_textView setTitle:message.text forState:UIControlStateNormal];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

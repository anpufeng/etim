//
//  TextFieldTableViewCell.m
//  ETImClient
//
//  Created by ethan on 8/23/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "LeftMarginTextField.h"

@implementation TextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textField = [[LeftMarginTextField alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self), RECT_HEIGHT(self))];
        
        [self addSubview:_textField];
    }
    return self;
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

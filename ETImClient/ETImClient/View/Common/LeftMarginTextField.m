//
//  LeftMarginTextField.m
//  ETImClient
//
//  Created by ethan on 8/23/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import "LeftMarginTextField.h"

@implementation LeftMarginTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 5)];
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
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

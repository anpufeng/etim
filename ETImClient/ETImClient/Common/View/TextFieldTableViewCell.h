//
//  TextFieldTableViewCell.h
//  ETImClient
//
//  Created by ethan on 8/23/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTableViewCell.h"


///UITableViewCell当中含有textfield的行

@class LeftMarginTextField;

@interface TextFieldTableViewCell : HMTableViewCell

@property (nonatomic, strong) LeftMarginTextField *textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

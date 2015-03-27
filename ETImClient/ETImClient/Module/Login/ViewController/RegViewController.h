//
//  RegViewController.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BackViewController.h"

@class LeftMarginTextField;

///用户注册

@interface RegViewController : BackViewController <UITextFieldDelegate> {
    LeftMarginTextField *_nameTextField;
    LeftMarginTextField *_pwdTextField;
    UIButton            *_regBtn;
}

@end

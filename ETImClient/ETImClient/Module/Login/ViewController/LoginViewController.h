//
//  LoginViewController.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "HMViewController.h"

@class LeftMarginTextField;

///用户登录

@interface LoginViewController : HMViewController <UITextFieldDelegate> {
    UIImageView         *_iconImgView;
    LeftMarginTextField *_nameTextField;
    LeftMarginTextField *_pwdTextField;
    UIButton            *_forgotBtn;
    UIButton            *_loginBtn;
    UIButton            *_configBtn;
    UIButton            *_regBtn;
}

@end

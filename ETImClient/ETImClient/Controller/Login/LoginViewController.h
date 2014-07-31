//
//  LoginViewController.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseViewController.h"

///用户登录

@interface LoginViewController : BaseViewController <UITextFieldDelegate> {
    UIImageView         *_iconImgView;
    UITextField         *_nameTextField;
    UITextField         *_pwdTextField;
    UIButton            *_forgotBtn;
    UIButton            *_loginBtn;
    UIButton            *_regBtn;
}

@end

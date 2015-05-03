//
//  RegViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "RegViewController.h"
#import "LeftMarginTextField.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

@interface RegViewController () <MBProgressHUDDelegate, Client> {
    MBProgressHUD *_hud;
}

@end

@implementation RegViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_REGISTER) object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiToReg:) name:notiNameFromCmd(CMD_REGISTER) object:nil];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)createUI {
    [self createDefaultBg];
    
    self.title = @"用户注册";
    UIImageView *textBg = [[UIImageView alloc] initWithFrame:CGRectMake((RECT_WIDTH(self.view) - 302)/2.0f, kStatusBarHeight + kNavigationBarHeight + 10, 302, 90)];
    textBg.image = IMAGE_PNG(@"login_textfield");
    [self.view addSubview:textBg];
    
    _nameTextField = [[LeftMarginTextField alloc] initWithFrame:CGRectMake(RECT_ORIGIN_X(textBg) + 5, RECT_ORIGIN_Y(textBg) + 4, RECT_WIDTH(textBg) - 10, 45)];
    _nameTextField.placeholder = @"用户名";
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.delegate = self;
    [self.view addSubview:_nameTextField];
    
    _pwdTextField = [[LeftMarginTextField alloc] initWithFrame:CGRectMake(RECT_ORIGIN_X(_nameTextField), RECT_MAX_Y(_nameTextField), RECT_WIDTH(_nameTextField), RECT_HEIGHT(_nameTextField))];
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.backgroundColor = [UIColor clearColor];
    _pwdTextField.returnKeyType = UIReturnKeyGo;
    _pwdTextField.delegate = self;
    _pwdTextField.secureTextEntry = YES;
    [self.view addSubview:_pwdTextField];
    
    _regBtn = [[UIButton alloc] initWithFrame:CGRectMake((RECT_WIDTH(self.view) - 290)/2.0f, RECT_MAX_Y(_pwdTextField) + 20, 290, kCommonBtnHeight44)];
    UIImage *regImg = [IMAGE_PNG(@"common_btn_green_nor") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)
                                                                            resizingMode:UIImageResizingModeStretch];
    UIImage *regPressImg = [IMAGE_PNG(@"common_btn_green_press") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)
                                                                            resizingMode:UIImageResizingModeStretch];
    [_regBtn setBackgroundImage:regImg forState:UIControlStateNormal];
    [_regBtn setBackgroundImage:regPressImg forState:UIControlStateHighlighted];
    [_regBtn setBackgroundImage:regPressImg forState:UIControlStateSelected];
    [_regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_regBtn addTarget:self action:@selector(responseToRegBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_regBtn];

}

#pragma mark - reg
#pragma mark 

- (void)responseToRegBtn:(UIButton *)sender {
    if (![_nameTextField.text length] || ![_pwdTextField.text length]) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"温馨提示" description:@"请输入用户名和密码" type:TWMessageBarMessageTypeInfo];
        return;
    }
    
    [_nameTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Client sharedInstance] connectWithDelegate:self];
}

///注册结果
- (void)notiToReg:(NSNotification *)noti {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_REGISTER) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"注册错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
            [[Client sharedInstance] disconnect];
        } else {
            //注册成功
            [[Client sharedInstance] disconnect];
            _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
            [self.navigationController.view addSubview:_hud];
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MB_CHECKMARK_IMAGE]];
            
            // Set custom view mode
            _hud.mode = MBProgressHUDModeCustomView;
            
            _hud.delegate = self;
            _hud.labelText = @"注册成功";
            
            [_hud show:YES];
            [_hud hide:YES afterDelay:MB_CHECKMARK_DURATION];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"注册错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
        [[Client sharedInstance] disconnect];
    }
}

#pragma mark -
#pragma mark client delegate
- (void)socketConnectSuccess {
    [[Client sharedInstance] doRecvAction];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_nameTextField.text forKey:@"name"];
    [param setObject:_pwdTextField.text forKey:@"pass"];
    etim::Session *sess = [[Client sharedInstance] session];
    [[Client sharedInstance] doAction:*sess cmd:CMD_REGISTER param:param];
}

- (void)socketConnectFailure {
     [[Client sharedInstance] reconnect];
}
#pragma mark -
#pragma mark textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	hud = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

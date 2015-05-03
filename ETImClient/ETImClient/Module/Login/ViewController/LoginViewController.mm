//
//  LoginViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "LoginViewController.h"
#import "LeftMarginTextField.h"
#import "RegViewController.h"
#import "HMScrollView.h"
#import "HMTabBarController.h"
#import "ConfigViewController.h"
#import "ReceivedManager.h"
#import "AppDelegate.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;


@interface LoginViewController () <Client> {
    
}

@end

@implementation LoginViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_LOGIN) object:nil];
}

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiToLogin:) name:notiNameFromCmd(CMD_LOGIN) object:nil];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)createUI {
    [self createDefaultBg];
    
    HMScrollView *scrollView = [[HMScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.frame = CGRectMake((RECT_WIDTH(self.view) - 68)/2.0f, 40, 68, 68);
    _iconImgView.backgroundColor = [UIColor colorWithPatternImage:IMAGE_PNG(@"login_avatar")];
    _iconImgView.image = IMAGE_PNG(@"login_avatar_default");
    _iconImgView.layer.cornerRadius = 5.0f;
    _iconImgView.layer.masksToBounds = YES;
    [scrollView addSubview:_iconImgView];
    
    
    UIImageView *textBg = [[UIImageView alloc] initWithFrame:CGRectMake((RECT_WIDTH(self.view) - 302)/2.0f, RECT_MAX_Y(_iconImgView) + 20, 302, 90)];
    textBg.image = IMAGE_PNG(@"login_textfield");
    [scrollView addSubview:textBg];
    
    _nameTextField = [[LeftMarginTextField alloc] initWithFrame:CGRectMake(RECT_ORIGIN_X(textBg) + 5, RECT_ORIGIN_Y(textBg) + 4, RECT_WIDTH(textBg) - 10, 45)];
    _nameTextField.placeholder = @"用户名";
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.delegate = self;
    _nameTextField.placeholder = @"用户名";
    [scrollView addSubview:_nameTextField];
    
    _pwdTextField = [[LeftMarginTextField alloc] initWithFrame:CGRectMake(RECT_ORIGIN_X(_nameTextField), RECT_MAX_Y(_nameTextField), RECT_WIDTH(_nameTextField), RECT_HEIGHT(_nameTextField))];
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.backgroundColor = [UIColor clearColor];
    _pwdTextField.returnKeyType = UIReturnKeyGo;
    _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTextField.delegate = self;
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.secureTextEntry = YES;
    [scrollView addSubview:_pwdTextField];



    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((RECT_WIDTH(self.view) - 290)/2.0f, RECT_MAX_Y(_pwdTextField) + 20, 290, kCommonBtnHeight44)];
    [_loginBtn setBackgroundImage:IMAGE_PNG(@"login_btn_blue_nor") forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:IMAGE_PNG(@"login_btn_blue_press") forState:UIControlStateHighlighted];
    [_loginBtn setBackgroundImage:IMAGE_PNG(@"login_btn_blue_press") forState:UIControlStateSelected];
    [_loginBtn addTarget:self action:@selector(responseToLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:_loginBtn];
    
    _configBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, RECT_HEIGHT(self.view) - 50, 120, kCommonBtnHeight44)];
    [_configBtn setTitle:@"--服务器配置--" forState:UIControlStateNormal];
    [_configBtn addTarget:self action:@selector(responseToConfigBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:_configBtn];
    
    _regBtn = [[UIButton alloc] initWithFrame:CGRectMake(RECT_WIDTH(self.view) - 100, RECT_ORIGIN_Y(_configBtn), 80, kCommonBtnHeight44)];
    [_regBtn setTitle:@"--注册--" forState:UIControlStateNormal];
    [_regBtn addTarget:self action:@selector(responseToRegBtn:) forControlEvents:UIControlEventTouchUpInside];

    [scrollView addSubview:_regBtn];
    
   
}


#pragma mark -
#pragma mark response

- (void)responseToLoginBtn:(UIButton *)sender {
    if (![_nameTextField.text length] || ![_pwdTextField.text length]) {
         [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"温馨提示" description:@"请输入用户名和密码" type:TWMessageBarMessageTypeInfo];
        return;
    }
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Client sharedInstance] connectWithDelegate:self];
}

- (void)responseToConfigBtn:(UIButton *)sender {
    ConfigViewController *vc = [[ConfigViewController alloc] initWithNibName:@"ConfigViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)responseToRegBtn:(UIButton *)sender {
    RegViewController *vc = [[RegViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)notiToLogin:(NSNotification *)noti {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_LOGIN) {
        if (sess->IsError()) {
             [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登录错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
            [[Client sharedInstance] disconnect];
        } else {
            //登录成功
            DDLogDebug(@"登录成功 :%@", [[ReceivedManager sharedInstance] loginBuddy]);
            HMTabBarController *tabbar = [[HMTabBarController alloc] init];
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabbar];
            [[Client sharedInstance] setPwd:_pwdTextField.text];
            [[Client sharedInstance] pullUnread];
            [[Client sharedInstance] startReachabilityNoti];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登录错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
        [[Client sharedInstance] disconnect];
    }
}

- (void)socketConnectSuccess {
    [[Client sharedInstance] doRecvAction];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_nameTextField.text forKey:@"name"];
    [param setObject:_pwdTextField.text forKey:@"pass"];
    etim::Session *sess = [[Client sharedInstance] session];
    [[Client sharedInstance] doAction:*sess cmd:CMD_LOGIN param:param];
}
- (void)socketConnectFailure {
    [[Client sharedInstance] reconnect];
}

#pragma mark -
#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTextField) {
        [_pwdTextField becomeFirstResponder];
    } else {
        [_pwdTextField resignFirstResponder];
        
        [self responseToLoginBtn:_loginBtn];
    }
    
    return YES;
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

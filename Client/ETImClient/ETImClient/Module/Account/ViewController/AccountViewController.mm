//
//  AccountViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "AccountViewController.h"
#import "ProfileViewController.h"
#import "SignatureViewController.h"
#import "SettingViewController.h"
#import "BuddyModel.h"
#import "ReceivedManager.h"
#import "DBManager.h"
#import "AppDelegate.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

@interface AccountViewController ()

@property (nonatomic, strong) NSArray *accountKeyList;

@end

@implementation AccountViewController

- (void)dealloc {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_LOGOUT) object:nil];
}

- (id)init
{
    if (self = [super init]) {
        self.title = @"帐户信息";
        self.navigationItem.title = @"帐户信息";
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_me_press"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"tab_me_nor"]];
#pragma clang diagnostic pop
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiToLogout:) name:notiNameFromCmd(CMD_LOGOUT) object:nil];
    [self initData];
    [self createUI];
}

- (void)initData {
    self.accountKeyList = @[@"个性签名", @"设置"];
}

- (void)createUI {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self.tableView), 70)];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 15, 10, 15);
    [logoutBtn setBackgroundImage:[IMAGE_PNG(@"common_btn_red_nor")
                                   resizableImageWithCapInsets:inset
                                   resizingMode:UIImageResizingModeStretch]
                         forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[IMAGE_PNG(@"common_btn_red_press")
                                   resizableImageWithCapInsets:inset
                                   resizingMode:UIImageResizingModeStretch]
                         forState:UIControlStateHighlighted];
    [logoutBtn setBackgroundImage:[IMAGE_PNG(@"common_btn_red_press")
                                   resizableImageWithCapInsets:inset
                                   resizingMode:UIImageResizingModeStretch]
                         forState:UIControlStateSelected];
    [logoutBtn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
//    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(responseToLogoutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.accountKeyList count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }
    return kCommonCellHeight44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuddyModel *user = [Client sharedInstance].user;
    if (indexPath.row == 0) {
        static NSString *identifier = @"profileHeadCell";
        ProfileHeadTableViewCell *headCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!headCell) {
            headCell = [[ProfileHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            headCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        [headCell update:user];
        return headCell;
    } else {
        static NSString *identifier = @"profileCell";
        ProfileTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!commonCell) {
            commonCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSInteger index = indexPath.row -1;
        NSAssert(self.accountKeyList.count > index, @"accountKeyList out of range");
        commonCell.keyLabel.text = self.accountKeyList[index];
        switch (index) {
            case 0:
                commonCell.valueLabel.text = user.signature;
                break;
            case 1:
                //commonCell.valueLabel.text = user.signature;
                break;
            case 2:
                //commonCell.valueLabel.text = [NSString stringWithFormat:@"%d", user.gender];
                break;
                
            default:
                break;
        }
        
        return commonCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [[ProfileViewController alloc] initWithUser:[Client sharedInstance].user];
            break;
        case 1:
            vc = [[SignatureViewController alloc] init];
            break;
            
        case 2:
            vc = [[SettingViewController alloc] init];
            break;
        default:
            break;
    }
    
    NSAssert(vc, @"no vc to push");
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark response

- (void)responseToLogoutBtn:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Client sharedInstance] pullWithCommand:CMD_LOGOUT];
}


- (void)notiToLogout:(NSNotification *)noti {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_LOGOUT) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登出错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            [[Client sharedInstance] disconnect];
            [[Client sharedInstance] resetStatus];
            [[ReceivedManager sharedInstance] resetData];
            [DBManager destory];
            //登出成功
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate jumpToLogin:YES];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登出错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
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




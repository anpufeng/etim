//
//  AccountViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "AccountViewController.h"
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
         [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_me_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_me_nor"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToLogoutResult) name:notiNameFromCmd(CMD_LOGOUT) object:nil];
    [self initData];
    [self createUI];
}

- (void)initData {
    self.accountKeyList = @[@"用户帐号", @"注册日期", @"用户签名" , @"性别"];
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self.view), RECT_HEIGHT(self.view) - kTabBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(_tableView), 60)];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
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
    
    _tableView.tableHeaderView = [[AccountHeadView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self.view), 60)];
    _tableView.tableFooterView = footerView;
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.accountKeyList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"accountCell";
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    etim::Session *sess = [[Client sharedInstance] session];
    IMUser user = sess->GetIMUser();
    cell.keyLabel.text = self.accountKeyList[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.valueLabel.text = stdStrToNsStr(user.userId);
            break;
        case 1:
            cell.valueLabel.text = stdStrToNsStr(user.regDate);
            break;
        case 2:
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", user.gender];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark -
#pragma mark response

- (void)responseToLogoutBtn:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    sess->Clear();
    sess->SetCmd(CMD_LOGOUT);
    sess->SetAttribute("name", sess->GetIMUser().username);
    [[Client sharedInstance] doAction:*sess];
}


- (void)responseToLogoutResult {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetCmd() == CMD_LOGOUT) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登出错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            [Client sharedDealloc];
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

#pragma mark -
#pragma mark AccountHeadView

@implementation AccountHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _thumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _thumbImgView.backgroundColor = [UIColor brownColor];
        [self addSubview:_thumbImgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(RECT_MAX_X(_thumbImgView) + 10, RECT_ORIGIN_Y(_thumbImgView), 100, 20)];
        [self addSubview:_nameLabel];
        
        //update
        etim::Session *sess = [[Client sharedInstance] session];
        IMUser user = sess->GetIMUser();
        _nameLabel.text = stdStrToNsStr(user.username);
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


#pragma mark -
#pragma mark AccountTableViewCell

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 80, 20)];
        [self.contentView addSubview:_keyLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(RECT_MAX_X(_keyLabel) + 10,
                                                                RECT_ORIGIN_Y(_keyLabel),
                                                                120,
                                                                RECT_HEIGHT(_keyLabel))];
        _valueLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_valueLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


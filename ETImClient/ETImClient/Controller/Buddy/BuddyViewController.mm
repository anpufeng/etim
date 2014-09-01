//
//  BuddyViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BuddyViewController.h"
#import "AddBuddyViewController.h"
#import "BuddyTableViewCell.h"
#import "BaseTabBarViewController.h"
#import "ChatViewController.h"
#import "BuddyModel.h"
#import "BadgeButton.h"
#import "MBProgressHUD.h"
#import "JSBadgeView.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"



using namespace etim;
using namespace etim::pub;
using namespace std;

@interface BuddyViewController () {
    
}

@property (nonatomic, strong) NSMutableArray *buddyList;

@end

@implementation BuddyViewController

- (void)dealloc {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_RETRIEVE_BUDDY_LIST) object:nil];
}

- (id)init
{
    if (self = [super init]) {
        self.title = @"好友列表";
        self.navigationItem.title = @"好友列表";
         [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_buddy_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_buddy_nor"]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToRetrieveBuddyResult) name:notiNameFromCmd(CMD_RETRIEVE_BUDDY_LIST) object:nil];
    [self createUI];
}

- (void)createUI {
    BuddyTableHeaderView *headerView = [[BuddyTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self.tableView), 83 + 25)];
    [headerView addTarget:self action:@selector(responseToBuddyMenu:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableHeaderView = headerView;
    [self createRightNav];
}

- (void)createRightNav {
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(responseToAddContactBtn:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(0, 0, 44, 44);

    [addBtn setImage:[UIImage imageNamed:@"header_icon_add"] forState:UIControlStateNormal];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -10;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems = @[spaceItem, item];
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.buddyList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"buddyCell";
    BuddyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BuddyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [cell update:self.buddyList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BuddyModel *buddy = self.buddyList[indexPath.row];
    ChatViewController *vc = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark response

- (void)responseToRetrieveBuddyResult {
    [self.refreshControl endRefreshing];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_RETRIEVE_BUDDY_LIST) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友列表错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            //好友列表成功
            self.buddyList = [BuddyModel buddys:sess->GetBuddys()];
            [self.tableView reloadData];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友列表错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

- (void)responseToRefresh {
    etim::Session *sess = [[Client sharedInstance] session];
    sess->Clear();
    sess->SetSendCmd(CMD_RETRIEVE_BUDDY_LIST);
    sess->SetAttribute("name", sess->GetIMUser().username);
    [[Client sharedInstance] doAction:*sess];
}

- (void)responseToAddContactBtn:(UIButton *)sender {
    AddBuddyViewController *vc = [[AddBuddyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)responseToBuddyMenu:(BuddyTableHeaderView *)sender {
    ETLOG(@"点击按钮 : %d", sender.menu);
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




@implementation BuddyTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"新朋友"];
        NSArray *images = @[@"add_icon_friend"];
        
        float margin = (RECT_WIDTH(self)/4.0f - 50)/2.0f;
        float labelWidth = RECT_WIDTH(self)/4.0f;
        for (int i = 0; i < BuddyViewMenuMax; i++) {
            BadgeButton *btn = [[BadgeButton alloc] initWithFrame:CGRectMake(margin + i * labelWidth, 10, 50, 50)];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(responseToBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth, RECT_MAX_Y(btn), labelWidth, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titles[i];
            label.font = FONT(14);
            [self addSubview:label];
            btn.badge = @"10";
        }
        
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 83, RECT_WIDTH(self), 1)];
        lineImgView.image = [UIImage imageNamed:@"line"];
        [self addSubview:lineImgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, RECT_MAX_Y(lineImgView), RECT_WIDTH(self), RECT_HEIGHT(self) - RECT_MAX_Y(lineImgView))];
        label.backgroundColor = RGB_TO_UICOLOR(247, 247, 247);
        label.font = FONT(14);
        label.text = @"     好友列表";
        [self addSubview:label];
        
    }
    return self;
}

- (void)responseToBtn:(BadgeButton *)sender {
    self.menu = (BuddyViewMenu)sender.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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

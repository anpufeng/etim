//
//  BuddyViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BuddyViewController.h"
#import "AddBuddyViewController.h"
#import "NewBuddyViewController.h"
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
///请求好友列表(仅包括一些未处理的不同USER的request, 不同于NewBuddyViewController的reqList
@property (nonatomic, strong) NSMutableArray *reqBuddyList;

@end

@implementation BuddyViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notiNameFromCmd(CMD_RETRIEVE_BUDDY_LIST)
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notiNameFromCmd(PUSH_BUDDY_UPDATE)
                                                  object:nil];
    [self removeObserver:self forKeyPath:@"buddyList"];
    [self removeObserver:self forKeyPath:@"reqBuddyList"];
}

- (id)init
{
    if (self = [super init]) {
        self.title = @"好友列表";
        self.navigationItem.title = @"好友列表";
         [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_buddy_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_buddy_nor"]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(responseToRetrieveBuddyList)
                                                     name:notiNameFromCmd(CMD_RETRIEVE_BUDDY_LIST)
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(responseToRetrievePedingBuddyRequest)
                                                     name:notiNameFromCmd(CMD_RETRIEVE_PENDING_BUDDY_REQUEST)
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(responseToPushBuddyStatus)
                                                     name:notiNameFromCmd(PUSH_BUDDY_UPDATE)
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(responseToPushBuddyRequestResult)
                                                     name:notiNameFromCmd(PUSH_BUDDY_REQUEST_RESULT)
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(responseToPushRequestAddBuddy)
                                                     name:notiNameFromCmd(PUSH_REQUEST_ADD_BUDDY)
                                                   object:nil];
        
        
        [self addObserver:self forKeyPath:@"reqBuddyList" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"buddyList" options:NSKeyValueObservingOptionNew context:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
    addBtn.frame = CGRectMake(0, 0, kNavigationBarHeight, kNavigationBarHeight);

    [addBtn setImage:[UIImage imageNamed:@"header_icon_add"] forState:UIControlStateNormal];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -10;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems = @[spaceItem, item];
}

- (void)addBuddys:(NSMutableArray *)buddys {
    [self willChangeValueForKey:@"buddyList"];
    [self.buddyList addObjectsFromArray:buddys];
    [self didChangeValueForKey:@"buddyList"];
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.buddyList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCommonCellHeight60;
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

///好友列表结果
- (void)responseToRetrieveBuddyList {
    [self.refreshControl endRefreshing];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_RETRIEVE_BUDDY_LIST) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友列表错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            //好友列表成功
            self.buddyList = [BuddyModel buddys:sess->GetBuddys()];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友列表错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

///好友请求列表
- (void)responseToRetrievePedingBuddyRequest {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_RETRIEVE_PENDING_BUDDY_REQUEST) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友请求错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            //好友请求列表成功
            self.reqBuddyList = [BuddyModel buddys:sess->GetReqBuddys()];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友请求错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

///好友上下线或资料变动
- (void)responseToPushBuddyStatus {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == PUSH_BUDDY_UPDATE) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户状态错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            //成功
            BuddyModel *changedBuddy = [[BuddyModel alloc] initWithUser:sess->GetStatusChangedBuddy()];
            for (int i = 0; i < [self.buddyList count]; i++) {
                BuddyModel *model = self.buddyList[i];
                if (model.userId == changedBuddy.userId) {
                    [self.buddyList replaceObjectAtIndex:i withObject:changedBuddy];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户状态错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

///好友请求结果
- (void)responseToPushBuddyRequestResult {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == PUSH_BUDDY_REQUEST_RESULT) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户请求结果错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户请求结果" description:@"成功" type:TWMessageBarMessageTypeSuccess];
            [self willChangeValueForKey:@"buddyList"];
            NSMutableArray *acceptedBuddy = [BuddyModel buddys:sess->GetBuddys()];
            [self.buddyList addObjectsFromArray:acceptedBuddy];
            [self didChangeValueForKey:@"buddyList"];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户请求结果错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

///有好友请求通知
- (void)responseToPushRequestAddBuddy {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == PUSH_REQUEST_ADD_BUDDY) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户请求错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户请求" description:@"成功" type:TWMessageBarMessageTypeSuccess];
            NSMutableArray *tempReqList = [BuddyModel buddys:sess->GetReqBuddys()];
            [self willChangeValueForKey:@"reqBuddyList"];
            if (!self.reqBuddyList) {
                self.reqBuddyList = [NSMutableArray array];
                [self.reqBuddyList addObjectsFromArray:tempReqList];
            } else {
                [self.reqBuddyList addObjectsFromArray:tempReqList];
                //TODO 去重(因为可能有多条请求来自同一人)
            }
            [self didChangeValueForKey:@"reqBuddyList"];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取服务器推送用户请求错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

- (void)responseToRefresh {
  
    [[Client sharedInstance] pullWithCommand:CMD_RETRIEVE_BUDDY_LIST];
}

///搜索添加好友
- (void)responseToAddContactBtn:(UIButton *)sender {
    AddBuddyViewController *vc = [[AddBuddyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

///
- (void)responseToBuddyMenu:(BuddyTableHeaderView *)sender {
    switch (sender.menu) {
        case BuddyViewMenuNewFriend:
        {
            self.reqBuddyList = nil;
            NewBuddyViewController *vc = [[NewBuddyViewController alloc] initWithBuddyViewController:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark observer 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"reqBuddyList"]) {
        BuddyTableHeaderView *headerView = (BuddyTableHeaderView *)self.tableView.tableHeaderView;
        BadgeButton *badgeBtn = (BadgeButton *)[headerView viewWithTag:BuddyViewMenuNewFriend];
        if ([self.reqBuddyList count]) {
            [badgeBtn setBadge:[NSString stringWithFormat:@"%d", self.reqBuddyList.count]];
        } else {
            [badgeBtn setBadge:@"0"];
        }
    }
    
    if ([keyPath isEqualToString:@"buddyList"]) {
        if ([self.buddyList count]) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [self emptyTableView:@"暂无好友"];
        }
         [self.tableView reloadData];
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
        for (int i = BuddyViewMenuNewFriend; i < BuddyViewMenuMax; i++) {
            int realIndex = i-BuddyViewMenuNewFriend;
            BadgeButton *btn = [[BadgeButton alloc] initWithFrame:CGRectMake(margin + realIndex * labelWidth, 10, 50, 50)];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:images[realIndex]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(responseToBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(realIndex * labelWidth, RECT_MAX_Y(btn), labelWidth, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titles[realIndex];
            label.font = FONT(14);
            [self addSubview:label];
        }
        
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 83, RECT_WIDTH(self), 1)];
        lineImgView.image = [UIImage imageNamed:@"line"];
        [self addSubview:lineImgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, RECT_MAX_Y(lineImgView), RECT_WIDTH(self), RECT_HEIGHT(self) - RECT_MAX_Y(lineImgView))];
        label.backgroundColor = RGB_TO_UICOLOR(247, 247, 247);
        label.font = FONT(14);
        label.text = @"    好友列表";
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

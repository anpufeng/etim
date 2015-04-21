//
//  MsgViewController.m
//  ETImClient
//
//  Created by Ethan on 14/9/2.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "MsgViewController.h"
#import "ChatViewController.h"
#import "MBProgressHUD.h"
#import "MsgModel.h"
#import "BuddyModel.h"
#import "ReceivedManager.h"
#import "MsgTableViewCell.h"
#import "DBManager.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;
using namespace std;

@interface MsgViewController ()

/*
 为了防止过多的数据膨胀， msgList应该只存储用来显示未读消息及最新消息等一些基本信息
实际上的聊天信息应该在对应的聊天页面   测试QQ发现 多终端情况下  你在电脑上登录了QQ 用另外号往这个QQ发5条消息 手机上也显示
5条未读 可是一旦在电脑上回了一条消息 这个未读状态就被置0了  应该是依最近回复的消息后面的来判断未读的
 **/
@property (nonatomic, strong) NSMutableDictionary *msgDic;
@property (nonatomic, strong) NSArray *peerIdArr;


@end

@implementation MsgViewController


- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_RETRIEVE_UNREAD_MSG) object:nil];
}

- (id)init
{
    if (self = [super init]) {
        self.title = @"消息";
        self.navigationItem.title = @"消息";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_recent_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_recent_nor"]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiToRetrieveUnreadMsg:)
                                                     name:notiNameFromCmd(CMD_RETRIEVE_UNREAD_MSG)
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiToJumpToChat:)
                                                     name:kJumpToChatNotification
                                                   object:nil];
        
       
        self.msgDic = [NSMutableDictionary dictionary];
        self.peerIdArr = [NSArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiToPushSendMsg:)
                                                     name:notiNameFromCmd(PUSH_SEND_MSG)
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)createUI {
    
}

- (void)sortAllKeys {
    NSArray *arr = [self.msgDic allKeys];
    self.peerIdArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ListMsgModel *listMsg1 = [self.msgDic objectForKey:obj1];
        ListMsgModel *listMsg2 = [self.msgDic objectForKey:obj2];
        
        return [listMsg1.lastestMsg.sendTime compare:listMsg2.lastestMsg.sendTime];
    }];
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self sortAllKeys];
    
    return [self.peerIdArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCommonCellHeight60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"buddyCell";
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MsgTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [cell update:[self.msgDic objectForKey:self.peerIdArr[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *key = self.peerIdArr[indexPath.row];
    ListMsgModel *listMsg = [self.msgDic objectForKey:key];
    ChatViewController *vc = [[ChatViewController alloc] initWithListMsg:listMsg];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - response

- (void)responseToRefresh {
    [[Client sharedInstance] pullUnread];
}

- (void)notiToRetrieveUnreadMsg:(NSNotification *)noti {
    [self.refreshControl endRefreshing];
    etim::Session *sess = [[Client sharedInstance] session];
    NSMutableArray *unread = [[ReceivedManager sharedInstance] unreadMsgArr];
    
    for (int i = 0; i < [unread count]; i++) {
        //BOOL exist = NO;
        MsgModel *msg = unread[i];
        [self handleReceivedMsg:msg];
        ///TODO 未读及存储消息记录
    }
    
    [[DBManager sharedInstance] insertMsgs:unread];
    
    [self.tableView reloadData];
}


///收到服务器推送消息
- (void)notiToPushSendMsg:(NSNotification *)noti {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == PUSH_SEND_MSG) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"接收消息失败" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            MsgModel *newMsg = [[ReceivedManager sharedInstance] receivedMsg];
            [self handleReceivedMsg:newMsg];
            [[DBManager sharedInstance] insertOneMsg:newMsg];
        }
        
        [self.tableView reloadData];
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"接收消息错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

- (void)handleReceivedMsg:(MsgModel *)msg {
    ListMsgModel *listMsg = self.msgDic[[msg msgKey]];
    if (listMsg) {
        ///消息中已经存在与此用户聊天的记录
        listMsg.lastestMsg = msg;
    } else {
        listMsg = [[ListMsgModel alloc] init];
        listMsg.lastestMsg = msg;
        listMsg.peerId = [[msg msgKey] intValue];
        [self.msgDic setObject:listMsg forKey:[msg msgKey]];
    }

}

///直接给某人发送消息
- (void)notiToJumpToChat:(NSNotification *)noti {
    BuddyModel *user = (BuddyModel *)noti.object;
    ListMsgModel *model = self.msgDic[[NSNUM_WITH_INT(user.userId) stringValue]];
    ChatViewController *vc = [[ChatViewController alloc] initWithListMsg:model];
    [self.navigationController pushViewController:vc animated:YES];
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

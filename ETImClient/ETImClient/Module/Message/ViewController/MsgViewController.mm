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

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;
using namespace std;

@interface MsgViewController ()

@property (nonatomic, strong) NSMutableArray *msgList;

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
        self.msgList = [NSMutableArray array];
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
    self.refreshControl = nil;
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.msgList count];
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
    
    [cell update:self.msgList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = self.msgList[indexPath.row];
    MsgModel *msg = [[dic objectForKey:@"msgs"] lastObject];
    int toId = msg.source == kMsgSourceOther ? msg.fromId : msg.toId;
    NSString *toName = msg.source == kMsgSourceOther ? msg.fromName : msg.toName;
    
    ChatViewController *vc = [[ChatViewController alloc] initWithMsgs:[dic objectForKey:@"msgs"] toId:toId toName:toName];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - response

- (void)notiToRetrieveUnreadMsg:(NSNotification *)noti {
    /**
     unread = {
        oneMsg {
            fromId->    fromId,
            msgs->   {MsgModel, MsgModel, MsgModel}
        }
     
        oneMsg {
            ....
        }
     }
     */
    etim::Session *sess = [[Client sharedInstance] session];
    NSMutableArray *unread = [[ReceivedManager sharedInstance] unreadMsgArr];
    
    for (int i = 0; i < [unread count]; i++) {
        BOOL exist = NO;
        int myId = [Client sharedInstance].user.userId;
        MsgModel *msg = unread[i];
        if ([self.msgList count]) {
            //有添加过未读 找出存在的
            for (int j = 0; j < [self.msgList count]; j++) {
                NSMutableDictionary *dic = self.msgList[j];
                NSString *fromId = [dic objectForKey:@"fromId"];
                
                 NSMutableArray *buddyMsgs = [dic objectForKey:@"msgs"];
                if (msg.fromId == fromId.intValue) {
                    [buddyMsgs addObject:msg];
                    msg.source = kMsgSourceOther;
                    exist = YES;
                    break;
                } else if (msg.fromId == myId && msg.toId == fromId.intValue) {
                    [buddyMsgs addObject:msg];
                    msg.source = kMsgSourceSelf;
                    exist = YES;
                    break;
                }
            }
            
            if (!exist) {
                //不存在则添加进去
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSMutableArray *buddyMsgs = [NSMutableArray array];
                [buddyMsgs addObject:msg];
                if (msg.fromId == myId) {
                    //我发出的
                    [dic setObject:INT_TO_STRING(msg.toId) forKey:@"fromId"];
                    msg.source = kMsgSourceSelf;
                } else {
                    [dic setObject:INT_TO_STRING(msg.fromId) forKey:@"fromId"];
                    msg.source = kMsgSourceOther;
                }
                [dic setObject:buddyMsgs forKey:@"msgs"];
                [self.msgList addObject:dic];
            }
        } else {
            //从来没有添加过未读
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSMutableArray *buddyMsgs = [NSMutableArray array];
            [buddyMsgs addObject:msg];
            if (msg.fromId == myId) {
                //我发出的
                [dic setObject:INT_TO_STRING(msg.toId) forKey:@"fromId"];
                msg.source = kMsgSourceSelf;
            } else {
                [dic setObject:INT_TO_STRING(msg.fromId) forKey:@"fromId"];
                msg.source = kMsgSourceOther;
            }
            
            [dic setObject:buddyMsgs forKey:@"msgs"];
            [self.msgList addObject:dic];
        }

    }
    
    [self.tableView reloadData];
}

- (void)notiToJumpToChat:(NSNotification *)noti {
    BuddyModel *user = (BuddyModel *)noti.object;
    ChatViewController *vc = [[ChatViewController alloc] initWithMsgs:[NSMutableArray array] toId:user.userId toName:user.username];
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

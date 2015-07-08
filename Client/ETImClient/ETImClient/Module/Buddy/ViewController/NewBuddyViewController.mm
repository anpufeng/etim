//
//  NewBuddyViewController.m
//  ETImClient
//
//  Created by Ethan on 14/8/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "NewBuddyViewController.h"
#import "BuddyViewController.h"
#import "RequestTableViewCell.h"
#import "IndexPathButton.h"
#import "RequestModel.h"
#import "ReceivedManager.h"
#import "BuddyModel.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

@interface NewBuddyViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) BuddyViewController *buddyVC;
@property (nonatomic, strong) NSMutableArray *reqList;
@property (nonatomic, strong) RequestModel *actionRequest;

@end

@implementation NewBuddyViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_RETRIEVE_ALL_BUDDY_REQUEST) object:nil];
}

- (id)initWithBuddyViewController:(BuddyViewController *)vc {
    if (self = [super init]) {
        self.buddyVC = vc;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新朋友";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiToRetrieveAllBuddyRequest:)
                                                 name:notiNameFromCmd(CMD_RETRIEVE_ALL_BUDDY_REQUEST)
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiToRejectAddBuddy:)
                                                 name:notiNameFromCmd(CMD_REJECT_ADD_BUDDY)
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiToAcceptAddBuddy:)
                                                 name:notiNameFromCmd(CMD_ACCEPT_ADD_BUDDY)
                                               object:nil];
    
    [self createUI];
    [[Client sharedInstance] pullWithCommand:CMD_RETRIEVE_ALL_BUDDY_REQUEST];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)createUI {
    
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reqList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCommonCellHeight60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"requestCell";
    RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RequestTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:identifier
                                                    target:self
                                                    action:@selector(responseToRequestAction:)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell update:self.reqList[indexPath.row] indexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark response

- (void)notiToRetrieveAllBuddyRequest:(NSNotification *)noti {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_RETRIEVE_ALL_BUDDY_REQUEST) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友请求列表错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            //好友列表成功
            self.reqList = [[ReceivedManager sharedInstance] reqArr];
            if ([self.reqList count]) {
                [self.tableView removeNoDataView];
            } else {
                [self.tableView showNoDataView];
            }
            [self.tableView reloadData];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友请求列表错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

///同意/拒绝操作
- (void)responseToRequestAction:(IndexPathButton *)sender {
    self.actionRequest = self.reqList[sender.indexPath.row];
    if (sender.tag == RequestActionReject) {
        etim::Session *sess = [[Client sharedInstance] session];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSString stringWithFormat:@"%d", self.actionRequest.reqId] forKey:@"reqId"];
        [param setObject:[NSString stringWithFormat:@"%d", self.actionRequest.from.userId] forKey:@"fromId"];
        [[Client sharedInstance] doAction:*sess cmd:CMD_REJECT_ADD_BUDDY param:param];
    } else if (sender.tag == RequestActionAccept) {
        DDLogInfo(@"RequestActionAccept");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"接受好友请求" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"同意好友请求", @"同意并添加对方为好友", nil];
        [actionSheet showInView:self.view];
    }
}

///拒绝结果
- (void)notiToRejectAddBuddy:(NSNotification *)noti {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_REJECT_ADD_BUDDY) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"拒绝好友请求错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            self.actionRequest.status = kBuddyRequestRejected;
            [self.tableView reloadData];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"拒绝好友请求错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

///同意结果
- (void)notiToAcceptAddBuddy:(NSNotification *)noti {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_ACCEPT_ADD_BUDDY) {
        if (sess->IsError()) {
            DDLogInfo(@"拒绝好友请求错误 code: %d %@", sess->GetErrorCode(), stdStrToNsStr(sess->GetErrorMsg()));
                      
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"拒绝好友请求错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            //同时请求也添加对方为好友
            self.actionRequest.status = kBuddyRequestAccepted;
            self.actionRequest.from.relation = kBuddyRelationFriend;
            [self.tableView reloadData];
            NSMutableArray *addedPeer = [NSMutableArray arrayWithObject:[[ReceivedManager sharedInstance] acceptedBuddy]];
            [self.buddyVC addBuddys:addedPeer];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"拒绝好友请求错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

#pragma mark -
#pragma mark actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    etim::Session *sess = [[Client sharedInstance] session];
    sess->SetSendCmd(CMD_ACCEPT_ADD_BUDDY);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d", self.actionRequest.reqId] forKey:@"reqId"];
    [param setObject:[NSString stringWithFormat:@"%d", self.actionRequest.from.userId] forKey:@"fromId"];
    if (buttonIndex == 1) {
        DDLogInfo(@"同意好友请求");
        [param setObject:@"0" forKey:@"addPeer"];
    } else if (buttonIndex == 2) {
        [param setObject:@"1" forKey:@"addPeer"];
        DDLogInfo(@"同意并添加对方为好友");
    }
    [[Client sharedInstance] doAction:*sess cmd:CMD_ACCEPT_ADD_BUDDY param:param];
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

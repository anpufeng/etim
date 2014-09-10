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
                                             selector:@selector(responseToRetrieveAllBuddyRequest)
                                                 name:notiNameFromCmd(CMD_RETRIEVE_ALL_BUDDY_REQUEST)
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseToRejectAddBuddy)
                                                 name:notiNameFromCmd(CMD_REJECT_ADD_BUDDY)
                                               object:nil];
    self.refreshControl = nil;
    [[Client sharedInstance] pullWithCommand:CMD_RETRIEVE_ALL_BUDDY_REQUEST];
    [self createUI];
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

- (void)responseToRetrieveAllBuddyRequest {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_RETRIEVE_ALL_BUDDY_REQUEST) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"获取好友请求列表错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            //好友列表成功
            self.reqList = [RequestModel request:sess->GetAllReqs()];
            if ([self.reqList count]) {
                self.tableView.backgroundView = nil;
            } else {
                self.tableView.backgroundView = [self emptyTableView:@"暂无好友请求"];
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
        sess->Clear();
        sess->SetSendCmd(CMD_REJECT_ADD_BUDDY);
        sess->SetAttribute("reqId", Convert::IntToString(self.actionRequest.reqId));
        sess->SetAttribute("fromId", Convert::IntToString(self.actionRequest.from.userId));
        [[Client sharedInstance] doAction:*sess];
    } else if (sender.tag == RequestActionAccept) {
        ETLOG(@"RequestActionAccept");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"接受好友请求" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"同意好友请求", @"同意并添加对方为好友", nil];
        [actionSheet showInView:self.view];
    }
}

///拒绝结果
- (void)responseToRejectAddBuddy {
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
- (void)responseToAcceptAddBuddy {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_ACCEPT_ADD_BUDDY) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"拒绝好友请求错误" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            self.actionRequest.status = kBuddyRequestAccepted;
            [self.tableView reloadData];
            //将此好友添加到好友列表
            [self.buddyVC addBuddy:self.actionRequest.from];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"拒绝好友请求错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

#pragma mark -
#pragma mark actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    /*
     string reqId = s.GetAttribute("reqId");
     string fromId = s.GetAttribute("fromId");
     string addPeer = s.GetAttribute("addPeer");
     */
    etim::Session *sess = [[Client sharedInstance] session];
    sess->Clear();
    sess->SetSendCmd(CMD_REJECT_ADD_BUDDY);
    sess->SetAttribute("reqId", Convert::IntToString(self.actionRequest.reqId));
    sess->SetAttribute("fromId", Convert::IntToString(self.actionRequest.from.userId));
    if (buttonIndex == 1) {
        ETLOG(@"同意好友请求");
        sess->SetAttribute("fromId", Convert::IntToString(self.actionRequest.from.userId));
    } else if (buttonIndex == 2) {
        ETLOG(@"同意并添加对方为好友");
    }
    [[Client sharedInstance] doAction:*sess];
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

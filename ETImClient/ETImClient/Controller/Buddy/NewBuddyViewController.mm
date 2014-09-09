//
//  NewBuddyViewController.m
//  ETImClient
//
//  Created by Ethan on 14/8/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "NewBuddyViewController.h"
#import "RequestTableViewCell.h"
#import "RequestModel.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

@interface NewBuddyViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *reqList;

@end

@implementation NewBuddyViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_RETRIEVE_ALL_BUDDY_REQUEST) object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新朋友";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseToRetrieveAllBuddyRequestResult)
                                                 name:notiNameFromCmd(CMD_RETRIEVE_ALL_BUDDY_REQUEST)
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
    
    [cell update:self.reqList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}



#pragma mark -
#pragma mark response

- (void)responseToRetrieveAllBuddyRequestResult {
    [self.refreshControl endRefreshing];
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

///同意拒绝
- (void)responseToRequestAction:(UIButton *)sender {
    if (sender.tag == RequestActionReject) {
        ETLOG(@"RequestActionReject");
    } else if (sender.tag == RequestActionAccept) {
        ETLOG(@"RequestActionAccept");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"接受请求" delegate:self cancelButtonTitle:@"cancelButtonTitle" destructiveButtonTitle:@"destructiveButtonTitle" otherButtonTitles:@"other1", @"other2", nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark -
#pragma mark actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ETLOG(@"action sheet buttonIndex: %d", buttonIndex);
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

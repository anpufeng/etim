//
//  MsgViewController.m
//  ETImClient
//
//  Created by Ethan on 14/9/2.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "MsgViewController.h"
#import "MBProgressHUD.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

@interface MsgViewController ()

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToRetrieveUnreadMsg) name:notiNameFromCmd(CMD_RETRIEVE_UNREAD_MSG) object:nil];
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
    
}

#pragma mark -
#pragma mark - response

- (void)responseToRetrieveUnreadMsg {
    
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

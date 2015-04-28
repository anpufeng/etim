//
//  HMTabBarController.m
//  Listening
//
//  Created by ethan on 15/1/24.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMTabBarController.h"
#import "HMNavigationController.h"
#import "BuddyViewController.h"
#import "MsgViewController.h"
#import "MomentsViewController.h"
#import "AccountViewController.h"
#import "HMNavigationController.h"
#import "Client.h"
#import "DBManager.h"
#import "ReceivedManager.h"

@interface HMTabBarController ()

@end

@implementation HMTabBarController

- (void)dealloc {
    DDLogDebug(@"======= HMTabBarController DEALLOC ========");
}


- (id)init {
    if (self = [super init]) {
        BuddyViewController *buddy = [[BuddyViewController alloc] init];
        MsgViewController *msg = [[MsgViewController alloc] init];
        MomentsViewController *moments = [[MomentsViewController alloc] init];
        AccountViewController *account = [[AccountViewController alloc] init];
        
        HMNavigationController *buddyNav = [[HMNavigationController alloc] initWithRootViewController:buddy];
        HMNavigationController *msgNav = [[HMNavigationController alloc] initWithRootViewController:msg];
        HMNavigationController *momentsNav = [[HMNavigationController alloc] initWithRootViewController:moments];
        HMNavigationController *accountNav = [[HMNavigationController alloc] initWithRootViewController:account];
        self.viewControllers = @[msgNav, buddyNav, momentsNav, accountNav];
    }
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

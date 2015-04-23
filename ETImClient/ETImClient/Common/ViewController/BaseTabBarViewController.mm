//
//  BaseTabBarViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BuddyViewController.h"
#import "MsgViewController.h"
#import "MomentsViewController.h"
#import "AccountViewController.h"
#import "BaseNavigationController.h"
#import "Client.h"
#import "DBManager.h"
#import "ReceivedManager.h"

@interface BaseTabBarViewController () {

}

@end

@implementation BaseTabBarViewController

- (void)dealloc {
    DDLogDebug(@"======= BaseTabBarViewController DEALLOC ========");
}


- (id)init {
    if (self = [super init]) {
        BuddyViewController *buddy = [[BuddyViewController alloc] init];
        MsgViewController *msg = [[MsgViewController alloc] init];
        MomentsViewController *moments = [[MomentsViewController alloc] init];
        AccountViewController *account = [[AccountViewController alloc] init];
        
        BaseNavigationController *buddyNav = [[BaseNavigationController alloc] initWithRootViewController:buddy];
        BaseNavigationController *msgNav = [[BaseNavigationController alloc] initWithRootViewController:msg];
        BaseNavigationController *momentsNav = [[BaseNavigationController alloc] initWithRootViewController:moments];
        BaseNavigationController *accountNav = [[BaseNavigationController alloc] initWithRootViewController:account];
        self.viewControllers = @[msgNav, buddyNav, momentsNav, accountNav];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

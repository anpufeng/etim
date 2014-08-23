//
//  BaseTabBarViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BuddyViewController.h"
#import "OnlineViewController.h"
#import "MomentsViewController.h"
#import "AccountViewController.h"
#import "BaseNavigationController.h"

@interface BaseTabBarViewController () {

}

@end

@implementation BaseTabBarViewController

- (void)dealloc {
    ETLOG(@"======= BaseTabBarViewController DEALLOC ========");
}


- (id)init {
    if (self = [super init]) {
        BuddyViewController *buddy = [[BuddyViewController alloc] init];
        OnlineViewController *online = [[OnlineViewController alloc] init];
        MomentsViewController *moments = [[MomentsViewController alloc] init];
        AccountViewController *account = [[AccountViewController alloc] init];
        
        BaseNavigationController *buddyNav = [[BaseNavigationController alloc] initWithRootViewController:buddy];
        BaseNavigationController *onlineNav = [[BaseNavigationController alloc] initWithRootViewController:online];
        BaseNavigationController *momentsNav = [[BaseNavigationController alloc] initWithRootViewController:moments];
        BaseNavigationController *accountNav = [[BaseNavigationController alloc] initWithRootViewController:account];
        self.viewControllers = @[buddyNav, onlineNav, momentsNav, accountNav];
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

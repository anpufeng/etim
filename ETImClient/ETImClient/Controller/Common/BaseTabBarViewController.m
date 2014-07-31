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
#import "AccountViewController.h"
#import "BaseNavigationController.h"

@interface BaseTabBarViewController () {

}

@end

@implementation BaseTabBarViewController

- (id)init {
    if (self = [super init]) {
        BuddyViewController *buddy = [[BuddyViewController alloc] init];
        OnlineViewController *online = [[OnlineViewController alloc] init];
        AccountViewController *account = [[AccountViewController alloc] init];
        
        BaseNavigationController *buddyNav = [[BaseNavigationController alloc] initWithRootViewController:buddy];
        BaseNavigationController *onlineNav = [[BaseNavigationController alloc] initWithRootViewController:online];
        BaseNavigationController *accountNav = [[BaseNavigationController alloc] initWithRootViewController:account];
        self.viewControllers = @[buddyNav, onlineNav, accountNav];
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

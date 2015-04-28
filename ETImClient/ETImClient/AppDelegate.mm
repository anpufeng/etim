//
//  AppDelegate.m
//  ETImClient
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "AppDelegate.h"
#import "Client.h"
#import "HMNavigationController.h"
#import "LoginViewController.h"
#import "Logging.h"
#import "HMLog.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    HMLog *log = [[HMLog alloc] init];
    [log start];
    
    [self jumpToLogin:NO];

    [[Client sharedInstance] setAppActive:YES];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[Client sharedInstance] setAppActive:NO];
    [[Client sharedInstance] disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[Client sharedInstance] setAppActive:YES];
    [[Client sharedInstance] reconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)jumpToLogin:(BOOL)animated {
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *root = [[HMNavigationController alloc] initWithRootViewController:vc];
    if (animated) {
        [UIView transitionWithView:self.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.window.rootViewController = root;
                        }
                        completion:nil];
    } else {
        self.window.rootViewController = root;
    }
}
@end

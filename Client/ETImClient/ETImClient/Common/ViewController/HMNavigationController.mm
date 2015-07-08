//
//  BaseNavigationController.m
//  Listening
//
//  Created by ethan on 14/12/25.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "HMNavigationController.h"
#import "HMViewController.h"

@interface HMNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation HMNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak HMNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
}

#pragma mark -
#pragma mark overwritten

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if ([self.topViewController respondsToSelector:@selector(setAnimating:)]) {
        HMViewController *top = (HMViewController *)self.topViewController;
        if (top.animating) {
            NSLog(@"正在push不可再push");
            return;
        }
        top.animating = YES;
        if ([viewController respondsToSelector:@selector(setAnimating:)]) {
            HMViewController *vc = (HMViewController *)viewController;
            vc.animating = YES;
            [super pushViewController:vc animated:YES];
        } else {
            [super pushViewController:viewController animated:YES];
        }
    } else {
        if ([viewController respondsToSelector:@selector(setAnimating:)]) {
            HMViewController *vc = (HMViewController *)viewController;
            vc.animating = YES;
            [super pushViewController:vc animated:YES];
        } else {
            [super pushViewController:viewController animated:YES];
        }
    }
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return  [super popToRootViewControllerAnimated:animated];
    
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
    
}
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
    }
    
    return YES;
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

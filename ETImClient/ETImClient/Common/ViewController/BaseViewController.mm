//
//  BaseViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController () 

@property (nonatomic, retain, readwrite) JKTokenController *tokenController;

@end

@implementation BaseViewController

- (void)dealloc {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_TO_UICOLOR(238, 238, 238);
    
//    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
}

- (void)createDefaultBg {
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (IPHONE5) {
        bgImgView.image = IMAGE_JPG(@"login_bg_ip5");
    } else {
        bgImgView.image = IMAGE_JPG(@"login_bg");
    }
    [self.view addSubview:bgImgView];
}

- (void)removeBgImageView
{
    [[self.view viewWithTag:1111] removeFromSuperview];
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

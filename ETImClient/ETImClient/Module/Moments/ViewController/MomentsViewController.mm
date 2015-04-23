//
//  MomentsViewController.m
//  ETImClient
//
//  Created by Ethan on 14/8/1.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "MomentsViewController.h"

@interface MomentsViewController ()

@end

@implementation MomentsViewController

- (id)init
{
    if (self = [super init]) {
        
        self.title = @"朋友圈";
        self.navigationItem.title = @"朋友圈";
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_qworld_press"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"tab_qworld_nor"]];
#pragma clang diagnostic pop
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

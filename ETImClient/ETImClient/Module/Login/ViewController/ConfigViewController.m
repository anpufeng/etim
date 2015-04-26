//
//  ConfigViewController.m
//  ETImClient
//
//  Created by ethan on 15/4/25.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "ConfigViewController.h"
#import "LeftMarginTextField.h"

@interface ConfigViewController ()

@property (weak, nonatomic) IBOutlet LeftMarginTextField *ipTextField;
@property (weak, nonatomic) IBOutlet LeftMarginTextField *portTextField;


@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"服务器配置";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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

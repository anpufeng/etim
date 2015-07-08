//
//  AboutViewController.m
//  ETImClient
//
//  Created by xuqing on 15/4/24.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "AboutViewController.h"
#import "NSString+PJR.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"简易即时通讯学习";
    self.descTextView.text = @"作者: ethan\nbug请联系:327660681@qq.com";
    self.versionLabel.text = [NSString stringWithFormat:@"版本V%@", [NSString appShortVersion]];
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

//
//  SettingViewController.m
//  ETImClient
//
//  Created by xuqing on 15/4/24.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()

@property (nonatomic, strong) NSArray *accountKeyList;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self createUI];
}


- (void)initData {
    self.accountKeyList = @[@"关于"];
}

- (void)createUI {
    self.title = @"设置";
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.accountKeyList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCommonCellHeight44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"setttingTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.accountKeyList[indexPath.row];
    cell.detailTextLabel.text = @"关于作者";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            break;
        
        default:
            
            vc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            break;
    }
    
    NSAssert(vc, @"no vc to push");
    [self.navigationController pushViewController:vc animated:YES];
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

//
//  HMTableViewController.m
//  ETImClient
//
//  Created by xuqing on 15/4/28.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "HMTableViewController.h"

@interface HMTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[HMTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //self.view.backgroundColor = RGB_TO_UICOLOR(238, 238, 238);
    self.view.backgroundColor = RGB_TO_UICOLOR(240, 239, 244);
    self.tableView.backgroundColor = RGB_TO_UICOLOR(240, 239, 244);

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
}


- (UIView *)emptyTableView:(NSString *)info {
    UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake((RECT_WIDTH(emptyView) - 70)/2.0f,
                                                                              (RECT_HEIGHT(emptyView) - 70)/2.0f - 40,
                                                                              70,
                                                                              70)];
    emptyImgView.contentMode = UIViewContentModeCenter;
    emptyImgView.image = [UIImage imageNamed:@"table_empty"];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, RECT_MAX_Y(emptyImgView), RECT_WIDTH(emptyView), 40)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.font = FONT(14);
    infoLabel.text = info;
    
    [emptyView addSubview:emptyImgView];
    [emptyView addSubview:infoLabel];
    
    return emptyView;
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCommonCellHeight60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

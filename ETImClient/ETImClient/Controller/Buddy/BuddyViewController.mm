//
//  BuddyViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BuddyViewController.h"
#import "AddBuddyViewController.h"
#import "MBProgressHUD.h"
#import "JSBadgeView.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

@interface BuddyViewController ()

@end

@implementation BuddyViewController

- (void)dealloc {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_RETRIEVE_BUDDY_LIST) object:nil];
}

- (id)init
{
    if (self = [super init]) {
        self.title = @"好友列表";
        self.navigationItem.title = @"好友列表";
         [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_buddy_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_buddy_nor"]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToRetrieveBuddyResult) name:notiNameFromCmd(CMD_RETRIEVE_BUDDY_LIST) object:nil];
    [self createUI];
}

- (void)createUI {
    BuddyTableHeaderView *headerView = [[BuddyTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self.tableView), 50)];
    headerView.backgroundColor = [UIColor grayColor];
    self.tableView.tableHeaderView = headerView;
    [self createRightNav];
}

- (void)createRightNav {
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(responseToAddContactBtn:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(0, 0, 44, 44);

    [addBtn setImage:[UIImage imageNamed:@"header_icon_add"] forState:UIControlStateNormal];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = -10;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems = @[spaceItem, item];
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"buddyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark response

- (void)responseToRetrieveBuddyResult {
    
}

- (void)responseToRefresh {
    [self.refreshControl endRefreshing];
}

- (void)responseToAddContactBtn:(UIButton *)sender {
    AddBuddyViewController *vc = [[AddBuddyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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




@implementation BuddyTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 10, RECT_WIDTH(self)/4.0f, RECT_HEIGHT(self));
        [btn setTitle:@"新朋友" forState:UIControlStateNormal];
        [self addSubview:btn];
        
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgeText = @"19";
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

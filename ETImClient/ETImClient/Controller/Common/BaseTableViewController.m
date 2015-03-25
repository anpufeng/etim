//
//  BaseTableViewController.m
//  ETImClient
//
//  Created by ethan on 8/13/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = RGB_TO_UICOLOR(240, 239, 244);
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.refreshControl addTarget:self action:@selector(responseToRefresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


///子类实现
- (void)responseToRefresh {
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

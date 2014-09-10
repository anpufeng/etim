//
//  BuddyViewController.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"

@class BuddyModel;

///好友页面

@interface BuddyViewController : BaseTableViewController <UITableViewDataSource, UITableViewDelegate> {

}

- (void)addBuddy:(BuddyModel *)buddy;

@end



typedef NS_ENUM(NSInteger, BuddyViewMenu) {
    BuddyViewMenuNewFriend = 100,
    BuddyViewMenuMax
};

///朋友列表上面菜单
@interface BuddyTableHeaderView : UIControl {
    
}

@property (nonatomic, assign) BuddyViewMenu menu;

- (id)initWithFrame:(CGRect)frame;

@end
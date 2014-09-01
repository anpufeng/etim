//
//  BuddyViewController.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
///好友页面

@interface BuddyViewController : BaseTableViewController <UITableViewDataSource, UITableViewDelegate> {

}



@end





typedef NS_ENUM(NSInteger, BuddyViewMenu) {
    BuddyViewMenuNewFriend,
    BuddyViewMenuMax
};

///朋友列表上面菜单
@interface BuddyTableHeaderView : UIControl {
    
}

@property (nonatomic, assign) BuddyViewMenu menu;

- (id)initWithFrame:(CGRect)frame;

@end
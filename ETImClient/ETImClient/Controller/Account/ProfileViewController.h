//
//  ProfileViewController.h
//  ETImClient
//
//  Created by ethan on 8/24/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import "BackViewController.h"

#include "DataStruct.h"



///个人资料

@interface ProfileViewController : BackViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView         *_tableView;
}


- (id)initWithUser:(etim::IMUser)user;


@end


///资料的tableview第一个的cell
@interface ProfileHeadTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *thumbImgView;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)update:(etim::IMUser)user;

@end


///资料的tableview的cell
@interface ProfileTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end


///profile页面底部按钮
@interface ProfileActionView : UIView


@property (nonatomic, strong) UIButton *actionBtn;
- (id)initWithFrame:(CGRect)frame relation:(BuddyRelation)relation;

@end

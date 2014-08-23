//
//  AccountViewController.h
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseViewController.h"

///我的帐户

@interface AccountViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView         *_tableView;
}

@end



///帐户上方的tableview的headerview
@interface AccountHeadView : UIView


@property (nonatomic, strong) UIImageView *thumbImgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end


///帐户上方的tableview的cell
@interface AccountTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;


@end

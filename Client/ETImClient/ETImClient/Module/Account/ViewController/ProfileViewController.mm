//
//  ProfileViewController.m
//  ETImClient
//
//  Created by ethan on 8/24/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import "ProfileViewController.h"
#import "BuddyModel.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

static void *kBuddyRelationKVOKey = &kBuddyRelationKVOKey;

@interface ProfileViewController ()

@property (nonatomic, strong) BuddyModel *user;
@property (nonatomic, strong) NSArray *profileKeyList;

@end

@implementation ProfileViewController

- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"relation"];
}


- (id)initWithUser:(BuddyModel *)user {
    if (self = [super init]) {
        self.user = user;
        if (self.user.relation == kBuddyRelationStranger) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(notiToRequestAddBuddy:)
                                                         name:notiNameFromCmd(CMD_REQUEST_ADD_BUDDY)
                                                       object:nil];
        }
        
        [self addObserver:self forKeyPath:@"relation" options:NSKeyValueObservingOptionNew context:kBuddyRelationKVOKey];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人资料";
    self.view.backgroundColor = RGB_TO_UICOLOR(240, 239, 244);
    [self initData];
    [self createUI];
}

- (void)initData {
    self.profileKeyList = @[@"用户帐号", @"注册日期", @"用户签名" , @"性别"];
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self.view), RECT_HEIGHT(self.view) - kTabBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    ProfileActionView *footView = [[ProfileActionView alloc] initWithFrame:CGRectMake(0,
                                                                                      RECT_MAX_Y(_tableView),
                                                                                      RECT_WIDTH(self.view),
                                                                                      kTabBarHeight)
                                                                  relation:self.user.relation];
    [footView.actionBtn addTarget:self action:@selector(responseToActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footView];
}

#pragma mark -
#pragma mark observer 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kBuddyRelationKVOKey) {
        
    }
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.profileKeyList count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }
    return kCommonCellHeight44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *identifier = @"profileHeadCell";
        ProfileHeadTableViewCell *headCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!headCell) {
            headCell = [[ProfileHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [headCell update:self.user];
        return headCell;
    } else {
        static NSString *identifier = @"profileCell";
        ProfileTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!commonCell) {
            commonCell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSInteger index = indexPath.row -1;
        NSAssert(self.profileKeyList.count > index, @"profileKeyList out of range");
        commonCell.keyLabel.text = self.profileKeyList[index];
        switch (index) {
            case 0:
                commonCell.valueLabel.text = [NSString stringWithFormat:@"%06d", self.user.userId];
                break;
            case 1:
                commonCell.valueLabel.text = self.user.regTime;
                break;
            case 2:
                commonCell.valueLabel.text = self.user.signature;
                break;
                
            case 3:
                commonCell.valueLabel.text = [NSString stringWithFormat:@"%d", self.user.gender];
                break;
            default:
                break;
        }
        
        return commonCell;
    }
}

#pragma mark -
#pragma mark response

- (void)responseToActionBtn:(UIButton *)sender {
    switch (self.user.relation) {
        case kBuddyRelationSelf:
        {
            
        }
            break;
            
        case kBuddyRelationStranger:
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            etim::Session *sess = [[Client sharedInstance] session];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[Client sharedInstance].user.username forKey:@"friend_from"];
            [param setObject:self.user.username forKey:@"friend_to"];
            [[Client sharedInstance] doAction:*sess cmd:CMD_REQUEST_ADD_BUDDY param:param];
        }
            break;
            
        case kBuddyRelationFriend:
        {
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kJumpToChatNotification object:self.user userInfo:nil];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)notiToRequestAddBuddy:(NSNotification *)noti {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_REQUEST_ADD_BUDDY) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"请求添加好友出错" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"请求添加好友" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeSuccess];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"请求错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
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


#pragma mark -
#pragma mark ProfileHeadTableViewCell

@implementation ProfileHeadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _thumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _thumbImgView.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:_thumbImgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(RECT_MAX_X(_thumbImgView) + 10, RECT_ORIGIN_Y(_thumbImgView), 100, 20)];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)update:(BuddyModel *)user {
    _nameLabel.text = user.username;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


#pragma mark -
#pragma mark ProfileTableViewCell

@implementation ProfileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 80, 20)];
        [self.contentView addSubview:_keyLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(RECT_MAX_X(_keyLabel) + 10,
                                                                RECT_ORIGIN_Y(_keyLabel),
                                                                120,
                                                                RECT_HEIGHT(_keyLabel))];
        _valueLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_valueLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


#pragma mark -
#pragma mark ProfileActionView

@implementation ProfileActionView

- (id)initWithFrame:(CGRect)frame relation:(BuddyRelation)relation
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _actionBtn = [[UIButton alloc] init];
        _actionBtn.frame = self.bounds;
        NSString *title = @"编辑信息";
        NSString *normalImgName = @"pdi_bottom_edit_btn_nor";
        NSString *pressImgName = @"pdi_bottom_edit_btn_press";
        switch (relation) {
            case kBuddyRelationSelf:
            {
            }
                break;
                
            case kBuddyRelationStranger:
            {
                title = @"添加好友";
                normalImgName = @"contact_add_btn_nor";
                pressImgName = @"contact_add_btn_press";
            }
                break;
                
            case kBuddyRelationFriend:
            {
                title = @"发消息";
                normalImgName = @"contact_to_chat_btn_nor";
                pressImgName = @"contact_to_chat_btn_press";
            }
                break;
                
            default:
                break;
        }
        
        [_actionBtn setImage:IMAGE_PNG(normalImgName) forState:UIControlStateNormal];
        [_actionBtn setImage:IMAGE_PNG(pressImgName) forState:UIControlStateHighlighted];
        [_actionBtn setImage:IMAGE_PNG(pressImgName) forState:UIControlStateSelected];
        float vMargin = (frame.size.height-22)/2.0f;
        float lMargin = -10;
        [_actionBtn setImageEdgeInsets:UIEdgeInsetsMake(vMargin, lMargin, vMargin, 0)];
        [_actionBtn setTitle:title forState:UIControlStateNormal];
        [_actionBtn setTitleColor:RGB_TO_UICOLOR(0, 121, 255) forState:UIControlStateNormal];
        [_actionBtn setTitleColor:RGB_TO_UICOLOR_ALPHA(0, 121, 255, 0.4) forState:UIControlStateHighlighted];
        [_actionBtn setTitleColor:RGB_TO_UICOLOR_ALPHA(0, 121, 255, 0.4) forState:UIControlStateSelected];
        [self addSubview:_actionBtn];
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

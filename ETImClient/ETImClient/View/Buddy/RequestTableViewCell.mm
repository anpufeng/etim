//
//  RequestTableViewCell.m
//  ETImClient
//
//  Created by Ethan on 14/9/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "RequestTableViewCell.h"
#import "IndexPathButton.h"
#import "RequestModel.h"
#import "BuddyModel.h"

@interface RequestTableViewCell () {

}

@property (nonatomic, readwrite, strong) IndexPathButton *rejectBtn;
@property (nonatomic, readwrite, strong) IndexPathButton *acceptBtn;
@property (nonatomic, readwrite, strong) RequestModel *req;

@end

@implementation RequestTableViewCell

/*
 父类属性
 UIImageView     *_iconImgView;
 UILabel         *_nameLabel;
 UILabel         *_descLabel;
 */

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _rejectBtn = [IndexPathButton buttonWithType:UIButtonTypeCustom];
        _rejectBtn.frame = CGRectMake(RECT_WIDTH(self) - 120, 15, 50, 30);
        [_rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rejectBtn.titleLabel.font = FONT(14);
        [self.contentView addSubview:_rejectBtn];
        
        _acceptBtn = [IndexPathButton buttonWithType:UIButtonTypeCustom];
        _acceptBtn.frame = CGRectMake(RECT_MAX_X(_rejectBtn) + 10, RECT_ORIGIN_Y(_rejectBtn), RECT_WIDTH(_rejectBtn), RECT_HEIGHT(_rejectBtn));
        [_acceptBtn setTitleColor:_rejectBtn.tintColor forState:UIControlStateNormal];
        _acceptBtn.titleLabel.font = _rejectBtn.titleLabel.font;
        [self.contentView addSubview:_acceptBtn];
        
        _rejectBtn.tag = RequestActionReject;
        _acceptBtn.tag = RequestActionAccept;
        [_rejectBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_acceptBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)update:(RequestModel *)req indexPath:(NSIndexPath *)indexPath {
    self.req = req;
    _acceptBtn.indexPath = indexPath;
    _rejectBtn.indexPath = indexPath;
    
    if (req.from.status == kBuddyOnline) {
        _iconImgView.image = [UIImage imageNamed:@"login_avatar_default"];
    } else {
        _iconImgView.image = [[UIImage imageNamed:@"login_avatar_default"] grayImage];
    }
    switch (req.status) {
        case kBuddyRequestNoSent: case kBuddyRequestSent:
        {
            _rejectBtn.hidden = NO;
            
            UIColor *color = RGB_TO_UICOLOR(9, 116, 255);
            
            [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            _rejectBtn.layer.cornerRadius = 3.0f;
            _rejectBtn.layer.borderColor = color.CGColor;
            _rejectBtn.layer.borderWidth = 1.0f;
            _rejectBtn.layer.masksToBounds = YES;
            [_rejectBtn setTitleColor:color forState:UIControlStateNormal];
            _rejectBtn.userInteractionEnabled = YES;
            
            [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
            _acceptBtn.layer.cornerRadius = 3.0f;
            _acceptBtn.layer.borderColor = color.CGColor;
            _acceptBtn.layer.borderWidth = 1.0f;
            _acceptBtn.layer.masksToBounds = YES;
            [_acceptBtn setTitleColor:color forState:UIControlStateNormal];
            _acceptBtn.userInteractionEnabled = YES;
        }
            break;
            
            
        case kBuddyRequestRejected: case (kBuddyRequestRejectedSent):
        {
            _rejectBtn.hidden = YES;
            [_acceptBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [_acceptBtn setTitleColor:RGB_TO_UICOLOR(121, 121, 121) forState:UIControlStateNormal];
            _acceptBtn.layer.borderWidth = .0f;
            _acceptBtn.userInteractionEnabled = YES;
        }
            break;
            
        case kBuddyRequestAccepted: case (kBuddyRequestAcceptedSent):
        {
            _rejectBtn.hidden = YES;
            [_acceptBtn setTitle:@"已同意" forState:UIControlStateNormal];
            [_acceptBtn setTitleColor:RGB_TO_UICOLOR(121, 121, 121) forState:UIControlStateNormal];
            _acceptBtn.layer.borderWidth = .0f;
            _acceptBtn.userInteractionEnabled = NO;
        }
            break;
            
        default:
            break;
    }
    _nameLabel.text = req.from.username;
    _descLabel.text = req.from.signature;
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

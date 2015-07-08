//
//  HMScrollNoDataView.h
//  Listening
//
//  Created by xuqing on 15/1/29.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMView.h"

@class HMLabel;

////当UISCROLLVIEW或UITABLEVIEW无数据时的显示

@interface HMScrollNoDataView : HMView

@property (strong, nonatomic) UIImageView *noDataImgView;
@property (strong, nonatomic) HMLabel *noDataLabel;

- (void)setupConstraint;

@end

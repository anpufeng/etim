//
//  HMScrollNoDataView.m
//  Listening
//
//  Created by xuqing on 15/1/29.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMScrollNoDataView.h"
#import "UIView+Additions.h"
#import "HMLabel.h"

@interface HMScrollNoDataView ()


@end

@implementation HMScrollNoDataView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.noDataImgView = [[UIImageView alloc] init];
        self.noDataImgView.image = [UIImage imageNamed:@"table_empty"];
        self.noDataLabel = [[HMLabel alloc] init];
        self.noDataImgView.backgroundColor = [UIColor clearColor];
        self.noDataLabel.backgroundColor = [UIColor clearColor];
        self.noDataImgView.contentMode = UIViewContentModeCenter;
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.noDataLabel.text = @"暂无数据";
        self.noDataLabel.textColor = [UIColor grayColor];
        self.noDataLabel.font = FONT(14);
        
        [self addSubview:self.noDataImgView];
        [self addSubview:self.noDataLabel];
        
         [self.noDataImgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.noDataLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setupConstraint];
        
    }
    
    return self;
}

- (void)setupConstraint {
    NSDictionary *views = NSDictionaryOfVariableBindings(_noDataImgView, _noDataLabel);

    float vPadding = 100;
    float imageHeight = 100;
    float labelHeight = 30;
    NSDictionary *metrics = @{
                              @"vPadding":[NSNumber numberWithFloat:vPadding],
                              @"imageHeight":[NSNumber numberWithFloat:imageHeight],
                              @"labelHeight":[NSNumber numberWithFloat:labelHeight]
                              };
    
    
    NSString *vfl = @"|[_noDataImgView]|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    NSString *vfl1 = @"|[_noDataLabel]|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    NSString *vfl2 = @"V:|-vPadding-[_noDataImgView(imageHeight)][_noDataLabel(labelHeight)]";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    self.noDataLabel.text = @"暂无数据";

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

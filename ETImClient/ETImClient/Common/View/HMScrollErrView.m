//
//  HMScrollErrView.m
//  Listening
//
//  Created by xuqing on 15/1/29.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMScrollErrView.h"
#import "HMLabel.h"
#import "UIView+Additions.h"


@interface HMScrollErrView ()


@end

@implementation HMScrollErrView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.errImgView = [[UIImageView alloc] init];
        self.errLabel = [[HMLabel alloc] init];
        self.errImgView.contentMode = UIViewContentModeCenter;
        self.errLabel.textAlignment = NSTextAlignmentCenter;
        self.errLabel.text = @"加载出错, 轻触重试";
        
        self.errImgView.backgroundColor = [UIColor greenColor];
        self.errLabel.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:self.errImgView];
        [self addSubview:self.errLabel];
        
        [self.errImgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.errLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setupConstraint];
    }
    
    return self;
}

- (void)setupConstraint {
    NSDictionary *views = NSDictionaryOfVariableBindings(_errImgView, _errLabel);
    
    float vPadding = 100;
    float imageHeight = 100;
    float labelHeight = 30;
    NSDictionary *metrics = @{
                              @"vPadding":[NSNumber numberWithFloat:vPadding],
                              @"imageHeight":[NSNumber numberWithFloat:imageHeight],
                              @"labelHeight":[NSNumber numberWithFloat:labelHeight]
                              };
    
    
    NSString *vfl = @"|[_errImgView]|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    NSString *vfl1 = @"|[_errLabel]|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    NSString *vfl2 = @"V:|-vPadding-[_errImgView(imageHeight)][_errLabel(labelHeight)]";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

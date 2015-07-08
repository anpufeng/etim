//
//  HMTableView.m
//  Listening
//
//  Created by ethan on 15/1/22.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMTableView.h"
#import "HMScrollErrView.h"
#import "HMScrollNoDataView.h"
#import "UIView+Additions.h"
#import "HMLabel.h"

@interface HMTableView ()

@property (nonatomic, assign) BOOL observed;
@property (nonatomic, strong) HMScrollNoDataView *noDataView;
@property (nonatomic, strong) HMScrollErrView *errView;

@end

@implementation HMTableView

- (void)dealloc {
    if (self.observed) {
        [self removeKeyboardObserve];
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.tableFooterView = [[UIView alloc] init];
}

#pragma mark -
#pragma mark observer

- (void)addKeyboardObserve {
    if (!self.observed) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        self.observed = YES;
    }
}
- (void)removeKeyboardObserve {
    if (self.observed) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        self.observed = NO;
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {

}

- (void)keyboardWillHide:(NSNotification*)notification {

}


- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[HMScrollNoDataView alloc] init];
        [_noDataView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_noDataView];
        [UIView addAllEdgeConstraintSuperview:self subview:_noDataView];
        
        _noDataView.backgroundColor = RGB_TO_UICOLOR(240, 239, 244);
    }
    
    return _noDataView;
}

- (UIView *)errView {
    if (!_errView) {
        _errView = [[HMScrollErrView alloc] init];
        [_errView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_errView];
        [UIView addAllEdgeConstraintSuperview:self subview:_errView];
        
        _errView.backgroundColor = [UIColor grayColor];
        
    }
    
    return _errView;
}

#pragma mark -
#pragma mark 数据加载

///显示无数据提示
- (void)showNoDataView {
    [self noDataView];
    [self setNeedsUpdateConstraints];
}

- (void)showNoDataViewWithTableHeader:(UIView *)headerView {
    [self noDataView];
    [self removeConstraints:self.constraints];
    NSDictionary *views = NSDictionaryOfVariableBindings(_noDataView, headerView);
    
    float vPadding = RECT_HEIGHT(headerView);
    float height = RECT_HEIGHT(self) - RECT_HEIGHT(headerView);
    float width = RECT_WIDTH(self);
    NSDictionary *metrics = @{
                              @"vPadding":[NSNumber numberWithFloat:vPadding],
                              @"height":[NSNumber numberWithFloat:height],
                              @"width":[NSNumber numberWithFloat:width]
                              };
    
    
    NSString *vfl = @"|[_noDataView(width)]|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    NSString *vfl2 = @"V:|-vPadding-[_noDataView(height)]|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
}

- (void)removeNoDataView {
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

- (void)showNoDataView:(UIImage *)noDataImg text:(NSString *)text {
    self.noDataView.noDataImgView.image = noDataImg;
    self.noDataView.noDataLabel.text = text;
}

- (void)showErrorView:(id)target action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self.errView addGestureRecognizer:tap];
}

- (void)showErrorView:(id)target action:(SEL)action image:(UIImage *)errImg text:(NSString *)text {
    self.errView.errImgView.image = errImg;
    self.errView.errLabel.text = text;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.errView.errLabel.userInteractionEnabled = YES;
    [self.errView.errLabel addGestureRecognizer:tap];
}

- (void)removeErrView {
    if (_errView) {
        [_errView removeFromSuperview];
        _errView = nil;
    }
}

@end

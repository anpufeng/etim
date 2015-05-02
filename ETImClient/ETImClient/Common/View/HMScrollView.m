//
//  HMScrollView.m
//  Listening
//
//  Created by xuqing on 15/1/29.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMScrollView.h"
#import "HMScrollNoDataView.h"
#import "HMScrollErrView.h"
#import "HMLabel.h"
#import "UIView+Additions.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface HMScrollView () {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}

@property (nonatomic, assign) BOOL observed;
@property (nonatomic, strong) HMScrollNoDataView *noDataView;
@property (nonatomic, strong) HMScrollErrView *errView;

@end



@implementation HMScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    if (self.observed) {
        [self removeKeyboardObserve];
    }
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

#pragma mark - init

- (void)setup {
    _priorInsetSaved = NO;
    if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) ) {
        self.contentSize = self.bounds.size;
    }
}

-(id)initWithFrame:(CGRect)frame {
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

-(void)awakeFromNib {
    [self setup];
}


-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGSize contentSize = _originalContentSize;
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);
    [super setContentSize:contentSize];
    
    if ( _keyboardVisible ) {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

-(void)setContentSize:(CGSize)contentSize {
    _originalContentSize = contentSize;
    
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);
    [super setContentSize:contentSize];
    
    if ( _keyboardVisible ) {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - 
#pragma mark - keyboard show hide

- (void)keyboardWillShow:(NSNotification*)notification {
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardVisible = YES;
    
    UIView *firstResponder = [self findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }
    
    if (!_priorInsetSaved) {
        _priorInset = self.contentInset;
        _priorInsetSaved = YES;
    }
    
    // Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.contentInset = [self contentInsetForKeyboard];
    [self setContentOffset:CGPointMake(self.contentOffset.x,
                                       [self idealOffsetForView:firstResponder withSpace:[self keyboardRect].origin.y - self.bounds.origin.y])
                  animated:YES];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _keyboardRect = CGRectZero;
    _keyboardVisible = NO;
    
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    self.contentInset = _priorInset;
    _priorInsetSaved = NO;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark util

- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (UIEdgeInsets)contentInsetForKeyboard {
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = [self keyboardRect];
    newInset.bottom = keyboardRect.size.height - ((keyboardRect.origin.y+keyboardRect.size.height) - (self.bounds.origin.y+self.bounds.size.height));
    return newInset;
}

-(CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space {
    
    // Convert the rect to get the view's distance from the top of the scrollView.
    CGRect rect = [view convertRect:view.bounds toView:self];
    
    // Set starting offset to that point
    CGFloat offset = rect.origin.y;
    
    
    if ( self.contentSize.height - offset < space ) {
        // Scroll to the bottom
        offset = self.contentSize.height - space;
    } else {
        if ( view.bounds.size.height < space ) {
            // Center vertically if there's room
            offset -= floor((space-view.bounds.size.height)/2.0);
        }
        if ( offset + space > self.contentSize.height ) {
            // Clamp to content size
            offset = self.contentSize.height - space;
        }
    }
    
    if (offset < 0) offset = 0;
    
    return offset;
}

-(void)adjustOffsetToIdealIfNeeded {
    
    // Only do this if the keyboard is already visible
    if ( !_keyboardVisible ) return;
    
    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
    
    CGPoint idealOffset = CGPointMake(0, [self idealOffsetForView:[self findFirstResponderBeneathView:self] withSpace:visibleSpace]);
    
    [self setContentOffset:idealOffset animated:YES];
}

- (CGRect)keyboardRect {
    CGRect keyboardRect = [self convertRect:_keyboardRect fromView:nil];
    if ( keyboardRect.origin.y == 0 ) {
        CGRect screenBounds = [self convertRect:[UIScreen mainScreen].bounds fromView:nil];
        keyboardRect.origin = CGPointMake(0, screenBounds.size.height - keyboardRect.size.height);
    }
    return keyboardRect;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[HMScrollNoDataView alloc] init];
        [_noDataView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_noDataView];
        [UIView addAllEdgeConstraintSuperview:self subview:_noDataView];
        
        _noDataView.backgroundColor = [UIColor grayColor];
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

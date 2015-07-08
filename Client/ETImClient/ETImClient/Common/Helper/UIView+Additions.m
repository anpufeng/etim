//
//  UIView+GetViewController.m
//  PAInsurance
//
//  Created by ethan on 1/3/15.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (GetViewController)

- (UIViewController *)getViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *)getNavController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}

- (CGRect)getVCFrame {
    UIViewController *vc =[self getViewController];
    if (vc) {
        return vc.view.frame;
    } else {
        return CGRectZero;
    }
}

@end



@implementation UIView (Constraint)

+(void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(UIView *)superview subview:(UIView *)subview {
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:edge
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:edge
                                                         multiplier:1
                                                           constant:0]];
}

+(void)addAllEdgeConstraintSuperview:(UIView *)superview subview:(UIView *)subview {
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
}


@end


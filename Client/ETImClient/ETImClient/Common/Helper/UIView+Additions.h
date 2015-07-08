//
//  UIView+GetViewController.h
//  PAInsurance
//
//  Created by ethan on 1/3/15.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GetViewController)

- (UIViewController *)getViewController;
- (UINavigationController *)getNavController;
- (CGRect)getVCFrame;



@end


@interface UIView (Constraint)

///添加约束
+(void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(UIView *)superview subview:(UIView *)subview;
///添加四个方向约束
+(void)addAllEdgeConstraintSuperview:(UIView *)superview subview:(UIView *)subview;


@end




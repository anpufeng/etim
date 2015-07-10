//
//  UIViewController+Loading.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "UIView+Loading.h"
#import "MBProgressHUD.h"
#import "NSObject+Class.h"

@implementation UIView (Loading)

- (void)showLoading {
    [self showLoadingWithText:nil];
}
- (void)showLoadingWithText:(NSString *)text {
    [self showLoadingWithText:text hideAfter:0];
}
- (void)showLoadingWithText:(NSString *)text hideAfter:(NSTimeInterval)seconds {
    [self showLoadingWithText:text hideAfter:seconds inView:self];
}

- (void)showLoadingWithText:(NSString *)text hideAfter:(NSTimeInterval)seconds inView:(UIView *)aView {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    
    if (text && [text isStrClass]) {
        hud.labelText = text;
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    if (seconds > 0) {
        [hud hide:YES afterDelay:seconds];
    }
    
}

- (void)hideLoading {
    [self hideLoadingInView:self];
}

- (void)hideLoadingInView:(UIView *)aView {
    [MBProgressHUD hideAllHUDsForView:aView animated:YES];
}

@end

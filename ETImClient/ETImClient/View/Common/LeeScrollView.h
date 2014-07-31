//
//  LeeScrollView.h
//  Lawyer
//
//  Created by ideal on 13-5-21.
//  Copyright (c) 2013年 ideal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeeScrollView : UIScrollView
{
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}

- (void)adjustOffsetToIdealIfNeeded;

@end

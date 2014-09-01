//
//  BadgeButton.m
//  ETImClient
//
//  Created by Ethan on 14/8/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BadgeButton.h"


@interface BadgeButton () {
    JSBadgeView     *_badgeView;
}

@end


@implementation BadgeButton

+ (id)buttonWithType:(UIButtonType)buttonType alignment:(JSBadgeViewAlignment)alignment {
    NSAssert(0, @"不支持");
    id btn = [[self class] buttonWithType:buttonType];
    if (btn)  {
        
    }
    
    return btn;
}



+ (id)buttonWithType:(UIButtonType)buttonType {
    return [[self class] buttonWithType:buttonType alignment:JSBadgeViewAlignmentTopRight];
}

- (id)initWithFrame:(CGRect)frame alignment:(JSBadgeViewAlignment)alignment {
    self = [super initWithFrame:frame];
    if (self) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self alignment:alignment];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame alignment:JSBadgeViewAlignmentTopRight];
}

- (id)init {
    return [self initWithFrame:CGRectZero alignment:JSBadgeViewAlignmentTopRight];
}

- (void)setBadge:(NSString *)badge {
    [_badgeView setBadgeText:badge];
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

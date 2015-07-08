//
//  WUNSTimerTargetLifecycleTracker.m
//  NSTimer+WeakTarget
//
//  Created by YuAo on 3/12/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "WUNSTimerTargetLifecycleTracker.h"
#import "WUNSTimerProxyTarget.h"

@interface WUNSTimerTargetLifecycleTracker ()

@property (nonatomic, weak) WUNSTimerProxyTarget *proxyTarget;

@end

@implementation WUNSTimerTargetLifecycleTracker

- (id)initWithTimerProxyTarget:(WUNSTimerProxyTarget *)proxyTarget {
    if (self = [super init]) {
        _proxyTarget = proxyTarget;
    }
    return self;
}

- (void)dealloc {
    [self.proxyTarget.timer invalidate];
}

@end

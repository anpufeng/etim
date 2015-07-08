//
//  WUNSTimerTargetLifecycleTracker.h
//  NSTimer+WeakTarget
//
//  Created by YuAo on 3/12/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WUNSTimerProxyTarget;

@interface WUNSTimerTargetLifecycleTracker : NSObject

- (id)initWithTimerProxyTarget:(WUNSTimerProxyTarget *)proxyTarget;

@end

//
//  NSTimer+WeakTarget.m
//  NSTimer+WeakTarget
//
//  Created by YuAo on 3/10/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "NSTimer+WeakTarget.h"
#import "WUNSTimerProxyTarget.h"
#import "WUNSTimerTargetLifecycleTracker.h"
#import <objc/runtime.h>

@implementation NSTimer (WeakTarget)

- (id)initWithFireDate:(NSDate *)date
              interval:(NSTimeInterval)timeInterval
            weakTarget:(id)target selector:(SEL)selector
              userInfo:(id)userInfo
               repeats:(BOOL)repeats
{
    WUNSTimerProxyTarget *proxyTarget = [[WUNSTimerProxyTarget alloc] initWithTarget:target selector:selector];
    NSTimer *timer = [self initWithFireDate:date interval:timeInterval target:proxyTarget selector:@selector(timerFired:) userInfo:userInfo repeats:repeats];
    proxyTarget.timer = timer;
    WUNSTimerTargetLifecycleTracker *tracker = [[WUNSTimerTargetLifecycleTracker alloc] initWithTimerProxyTarget:proxyTarget];
    objc_setAssociatedObject(target, (__bridge void *)tracker, tracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return timer;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)timeInterval
                        weakTarget:(id)target
                          selector:(SEL)selector
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats
{
    WUNSTimerProxyTarget *proxyTarget = [[WUNSTimerProxyTarget alloc] initWithTarget:target selector:selector];
    NSTimer *timer = [self timerWithTimeInterval:timeInterval target:proxyTarget selector:@selector(timerFired:) userInfo:userInfo repeats:repeats];
    proxyTarget.timer = timer;
    WUNSTimerTargetLifecycleTracker *tracker = [[WUNSTimerTargetLifecycleTracker alloc] initWithTimerProxyTarget:proxyTarget];
    objc_setAssociatedObject(target, (__bridge void *)tracker, tracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                 weakTarget:(id)target
                                   selector:(SEL)selector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats
{
    WUNSTimerProxyTarget *proxyTarget = [[WUNSTimerProxyTarget alloc] initWithTarget:target selector:selector];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval target:proxyTarget selector:@selector(timerFired:) userInfo:userInfo repeats:repeats];
    proxyTarget.timer = timer;
    WUNSTimerTargetLifecycleTracker *tracker = [[WUNSTimerTargetLifecycleTracker alloc] initWithTimerProxyTarget:proxyTarget];
    objc_setAssociatedObject(target, (__bridge void *)tracker, tracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return timer;
}

@end

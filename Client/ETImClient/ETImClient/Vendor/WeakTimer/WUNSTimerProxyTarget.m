//
//  WUNSTimerWeakTarget.m
//  NSTimer+WeakTarget
//
//  Created by YuAo on 3/10/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "WUNSTimerProxyTarget.h"

@interface WUNSTimerProxyTarget()

@property (nonatomic, weak) id      target;
@property (nonatomic)       SEL     selector;

@end

@implementation WUNSTimerProxyTarget

- (id)initWithTarget:(id)target selector:(SEL)selector {
    if (self = [super init]) {
        _target = target;
        _selector = selector;
    }
    return self;
}

- (void)timerFired:(NSTimer *)timer {
    if ([self.target respondsToSelector:self.selector]) {
        NSMethodSignature *methodSignature = [self.target methodSignatureForSelector:self.selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        if (methodSignature.numberOfArguments > 2) [invocation setArgument:&timer atIndex:2];
        invocation.selector = self.selector;
        [invocation invokeWithTarget:self.target];
    } else {
        [self.target doesNotRecognizeSelector:self.selector];
    }
}

@end

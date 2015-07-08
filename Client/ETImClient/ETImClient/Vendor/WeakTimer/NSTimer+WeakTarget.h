//
//  NSTimer+WeakTarget.h
//  NSTimer+WeakTarget
//
//  Created by YuAo on 3/10/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (WeakTarget)

- (id)initWithFireDate:(NSDate *)date
              interval:(NSTimeInterval)timeInterval
            weakTarget:(id)target
              selector:(SEL)selector
              userInfo:(id)userInfo
               repeats:(BOOL)repeats;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)timeInterval
                        weakTarget:(id)target
                          selector:(SEL)selector
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                 weakTarget:(id)target
                                   selector:(SEL)selector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

@end

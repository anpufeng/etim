//
//  UtilUserDefaults.h
//  Listening
//
//  Created by ethan on 1/25/15.
//  Copyright (c) 2015 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

///USER DEFAULTS 数据存取

@interface UtilUserDefaults : NSObject

+ (BOOL)saveRepeatMode:(NSInteger)mode;
+ (NSInteger)getRepeatMode;

@end

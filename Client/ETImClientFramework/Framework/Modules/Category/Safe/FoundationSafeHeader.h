//
//  FoundationSafeHeader.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/14.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#ifndef ETImClientFramework_FoundationSafeHeader_h
#define ETImClientFramework_FoundationSafeHeader_h

//是否开启swizzle
#define FOUNDATION_SWIZZLE          1

#ifdef FOUNDATION_SWIZZLE

#import "NSArray+Safe.h"
#import "NSDictionary+Safe.h"
#import "NSMutableArray+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "NSNumber+Safe.h"
#import "NSString+Safe.h"

#endif


#endif

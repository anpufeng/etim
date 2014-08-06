//
//  Client.h
//  ETImClient
//
//  Created by ethan on 8/6/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#include "Session.h"

@interface Client : NSObject {
    dispatch_queue_t _queueId;
}


+ (Client *)sharedInstance;

///获取session对象
- (etim::Session *)session;
- (void)doAction:(etim::Session &)s;

@end

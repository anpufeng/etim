//
//  SendOperation.m
//  ETImClient
//
//  Created by Ethan on 14/9/12.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "SendOperation.h"
#import "Client.h"
#import "CmdParamModel.h"

#include "Singleton.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::action;
using namespace::etim::pub;
using namespace std;

@interface SendOperation  ()

@property (nonatomic, strong) CmdParamModel *cmdModel;
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@end

@implementation SendOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (id)initWithCmdParamModel:(CmdParamModel *)model {
    if (self = [super init]) {
        _executing = NO;
        _finished = NO;
        self.cmdModel = model;
    }
    
    return self;
}

- (void)start
{
    /*
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
     */
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    sendarg arg;
    NSArray *keys = [self.cmdModel.params allKeys];
    for (int i = 0; i < [keys count]; i++) {
        string key = nsStrToStdStr(keys[i]);
        string value = nsStrToStdStr([self.cmdModel.params objectForKey:keys[i]]);
        arg[key] = value;
    }
    etim::Session *sess = [[Client sharedInstance] session];
    Singleton<ActionManager>::Instance().SendPacket(*sess, self.cmdModel.cmd, arg);
   
}
- (void)finish {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}
- (BOOL)isExecuting {
    return _executing;
}
- (BOOL)isFinished {
    return _finished;
}

- (void)cancel
{
    if (self.isFinished) return;
    [super cancel];
}


@end

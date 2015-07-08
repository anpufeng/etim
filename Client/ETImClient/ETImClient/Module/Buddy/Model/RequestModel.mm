//
//  RequestModel.m
//  ETImClient
//
//  Created by Ethan on 14/9/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "RequestModel.h"
#import "BuddyModel.h"

#import "Client.h"

using namespace etim;

@implementation RequestModel

- (id)initWithRequest:(etim::IMReq)req {
    if (self = [super init]) {
        self.reqId = req.reqId;
        self.from = [[BuddyModel alloc] initWithUser:req.from];
        self.status = req.status;
        self.reqTime = stdStrToNsStr(req.reqTime);
        self.reqSendTime = stdStrToNsStr(req.reqSendTime);
        self.actionTime = stdStrToNsStr(req.actionTime);
        self.actionSendTime = stdStrToNsStr(req.actionSendTime);
    }
    
    return self;
}

- (NSString *)reqStatus {
    NSString *result = @"请求未发送";
    switch (self.status) {
        case kBuddyRequestNoSent:
            result = @"请求未发送";
            break;
            
        case kBuddyRequestSent:
            result = @"请求已发送";
            break;
            
        case (kBuddyRequestRejected):
            result = @"请求已拒绝未发送到请求方";
            break;
            
        case (kBuddyRequestRejectedSent):
            result = @"请求已拒绝已发送请求方向";
            break;
            
        case (kBuddyRequestAccepted):
            result = @"请求已同意未发送到请求方";
            break;
            
        case (kBuddyRequestAcceptedSent):
            result = @"请求已同意已发送到请求方";
            break;
            
        case (kBuddyRequestInvalid):
            result = @"此请求已失效";
            break;
            
        default:
            break;
    }
    
    return result;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"请求id: %06d, \n用户:%@\n, 请求状态: %@ 请求日期: %@, 请求发送日期:%@, 响应日期:%@, 响应发送日期:%@",
            self.reqId,
            self.from,
            [self reqStatus],
            self.reqTime,
            self.reqSendTime,
            self.actionTime,
            self.actionSendTime];
}

+ (NSMutableArray *)request:(const std::list<etim::IMReq> &)reqs {
    NSMutableArray *result = [NSMutableArray array];
    std::list<IMReq>::const_iterator it;
    for (it = reqs.begin(); it != reqs.end(); ++it) {
        RequestModel *model = [[RequestModel alloc] initWithRequest:*it];
        [result addObject:model];
    }
    
    return result;
}

@end

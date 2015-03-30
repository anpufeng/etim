//
//  CmdParamModel.m
//  ETImClient
//
//  Created by xuqing on 15/3/25.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "CmdParamModel.h"

@implementation CmdParamModel

- (NSString *)description {
    return [NSString stringWithFormat:@"cmd: 0X%04X params: %@", self.cmd, [self.params description]];
}

@end

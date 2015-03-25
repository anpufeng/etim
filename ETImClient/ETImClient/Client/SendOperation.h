//
//  SendOperation.h
//  ETImClient
//
//  Created by Ethan on 14/9/12.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <map>
#include "Session.h"
#include "Endian.h"

@class CmdParamModel;

///用来发送

@interface SendOperation : NSOperation

- (id)initWithCmdParamModel:(CmdParamModel *)model;

@end

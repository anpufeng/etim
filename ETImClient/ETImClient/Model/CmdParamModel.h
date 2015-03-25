//
//  CmdParamModel.h
//  ETImClient
//
//  Created by xuqing on 15/3/25.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "Socket.h"
#include "Endian.h"
#include <map>
#include <sstream>

using namespace etim;
using namespace etim::pub;
using namespace std;

@interface CmdParamModel : NSObject

@property (nonatomic, assign) etim::uint16 cmd;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

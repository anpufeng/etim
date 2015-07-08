//
//  HMLogFormatter.m
//  TestHMLog
//
//  Created by xuqing on 15/3/4.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMLogFormatter.h"
#import "NSDate+Additions.h"

@implementation HMLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    
    NSString *type;
    switch (logMessage.flag) {
        case DDLogFlagDebug:
            type = @"Debug  ";
            break;
            
        case DDLogFlagVerbose:
            type = @"Verbose";
            break;
            
        case DDLogFlagInfo:
            type = @"Info   ";
            break;
            
        case DDLogFlagWarning:
            type = @"Warning";
            break;
            
        case DDLogFlagError:
            type = @"Error  ";
            break;
            
        default:
            type = @"Info   ";
            break;
    }
    return [NSString stringWithFormat:@"%@ | %@ | %@ | %@ | LINE %@ | %@", type,
            [NSDate dateStr:[logMessage timestamp] type:DateFormatTypeLong],
            [logMessage fileName],
            logMessage->_function,
            @(logMessage->_line),
            logMessage->_message];
}


@end



@implementation HMTTYLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
 
    NSString *type;
    switch (logMessage.flag) {
        case DDLogFlagDebug:
            type = @"Debug  ";
            break;
            
        case DDLogFlagVerbose:
            type = @"Verbose";
            break;
            
        case DDLogFlagInfo:
            type = @"Info   ";
            break;
            
        case DDLogFlagWarning:
            type = @"Warning";
            break;
            
        case DDLogFlagError:
            type = @"Error  ";
            break;
            
        default:
            type = @"Info   ";
            break;
    }
     return [NSString stringWithFormat:@"%@ | %@ | %@ | %@ | LINE %@ | %@", type,
             [NSDate dateStr:[logMessage timestamp] type:DateFormatTypeLong],
             [logMessage fileName],
             logMessage->_function,
             @(logMessage->_line),
             logMessage->_message];
}

@end

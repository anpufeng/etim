//
//  HMFileLogger.m
//  TestHMLog
//
//  Created by xuqing on 15/3/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMFileLogger.h"



@interface HMFileLogger () {
}


@end

@implementation HMFileLogger

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark DDLogger Protocol
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static int exception_count = 0;
- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *message = logMessage->_message;
    BOOL isFormatted = NO;
    
    if (_logFormatter) {
        message = [_logFormatter formatLogMessage:logMessage];
        isFormatted = message != logMessage->_message;
    }
    
    if (message) {
        if ((!isFormatted || self.automaticallyAppendNewlineForCustomFormatters) &&
            (![message hasSuffix:@"\n"])) {
            message = [message stringByAppendingString:@"\n"];
        }
        
        NSData *logData = [message dataUsingEncoding:NSUTF8StringEncoding];
        
        @try {
            [[self currentLogFileHandle] writeData:logData];
            
            [self maybeRollLogFileDueToSize];
        } @catch (NSException *exception) {
            exception_count++;
            
            if (exception_count <= 10) {
                //NSLogError(@"DDFileLogger.logMessage: %@", exception);
                
                if (exception_count == 10) {
                    //NSLogError(@"DDFileLogger.logMessage: Too many exceptions -- will not log any more of them.");
                }
            }
        }
    }
}
*/
@end

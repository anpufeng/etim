//
//  HMLogFileManager.h
//  TestHMLog
//
//  Created by xuqing on 15/3/4.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

////日志文件管理 

@interface HMLogFileManager : DDLogFileManagerDefault

- (id)init;

@end



///用于DEBUG时的LOG查看
@interface HMDebugLogFileManager : DDLogFileManagerDefault

- (id)init;

@end

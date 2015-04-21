//
//  DBManager.m
//  ETImClient
//
//  Created by xuqing on 15/4/17.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "MsgModel.h"
#import "BuddyModel.h"
#import "Client.h"

static NSString *const localDbName = @"etim.db";

@interface DBManager () {
    FMDatabase      *_db;
}

@end


@implementation DBManager

- (void)dealloc {
    [_db close];
}

static DBManager *sharedDBManager = nil;
static dispatch_once_t predicate;


+(DBManager*)sharedInstance {
    dispatch_once(&predicate, ^{
        sharedDBManager = [[DBManager alloc]init];
        //忽略send产生的sigpipe信号
        signal(SIGPIPE, SIG_IGN);
    });
    
    return sharedDBManager;
}

- (id)init {
    if (self = [super init]) {
        [self initDataBase];
    }
    
    return self;
}

- (void)initDataBase {
    NSString *dbPath = [self defaultDbPath];
    BOOL created = NO;
    if (![UtilFileManager fileExist:dbPath]) {
        created = [UtilFileManager createDir:[self defaultDbDir]];
    }

    _db = [[FMDatabase alloc] initWithPath:dbPath];
    if (![_db open]) {
        DDLogError(@"open db faile : %@", dbPath);
    } else {
        if (created) {
            //第一次
            [_db beginTransaction];
            NSString *dropMessageSql = @"DROP TABLE IF EXISTS `message`;";
            NSString *messageSql =@"CREATE TABLE `message` (`msg_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `msg_from` integer NOT NULL, `msg_to` integer NOT NULL, `req_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `send_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `sent` integer NOT NULL, `message` text NOT NULL);";
            
            NSString *dropUserSql = @"DROP TABLE IF EXISTS `user`;";
            NSString *userSql =@"CREATE TABLE `user` (`user_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `username` text NOT NULL, `reg_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `last_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `signature` text NOT NULL, `gender` integer NOT NULL, `status_id` integer NOT NULL);";
            [_db executeUpdate:dropMessageSql];
            [_db executeUpdate:messageSql];
            [_db executeUpdate:dropUserSql];
            [_db executeUpdate:userSql];
            if (![_db commit]) {
                DDLogError(@"create table error %@", [_db lastError]);
                [_db close];
                [UtilFileManager deleteDir:[self defaultDbDir]];
            }
        }
    }

}

- (BOOL)insertOneMsg:(MsgModel *)msg {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO message (msg_id, msg_from, msg_to, req_time, send_time, sent, message) values('%@','%@','%@','%@','%@','%@','%@')", NSNUM_WITH_INT(msg.msgId), NSNUM_WITH_INT(msg.fromId), NSNUM_WITH_INT(msg.toId), msg.requestTime, msg.sendTime, NSNUM_WITH_INT((int)msg.sent), msg.text];

    BOOL result = [_db executeUpdate:sql];
    if (!result) {
        DDLogError(@"insertMsgs error: %@", [_db lastError]);
    }
    return result;
}
- (BOOL)insertMsgs:(NSMutableArray *)msgs {
    for (MsgModel *msg in msgs) {
        [self insertOneMsg:msg];
    }

    return YES;
}

- (NSMutableArray *)recentMsgs:(int)msgId peerId:(int)peerId {
    NSString *sql;
    if (msgId == 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM message m LEFT JOIN user u ON u.user_id = '%@' WHERE m.msg_from = %@ or m.msg_to = %@ ORDER BY req_time asc limit 20", NSNUM_WITH_INT(peerId), NSNUM_WITH_INT(peerId), NSNUM_WITH_INT(peerId)];
    } else {
        sql = [NSString stringWithFormat:@"SELECT * FROM message m  LEFT JOIN user u ON u.user_id = '%@' WHERE (m.msg_from = %@ or m.msg_to = %@) AND msg_id < '%@' ORDER BY req_time asc limit 20", NSNUM_WITH_INT(peerId), NSNUM_WITH_INT(peerId), NSNUM_WITH_INT(peerId), NSNUM_WITH_INT(msgId)];

    }
    
    NSMutableArray *msgArr = [NSMutableArray array];
    int myId = [[[Client sharedInstance] user] userId];
    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        
        MsgModel *msg = [[MsgModel alloc] init];
        msg.msgId = [rs intForColumn:@"msg_id"];
        msg.fromId = [rs intForColumn:@"msg_from"];
        msg.toId = [rs intForColumn:@"msg_to"];
        if (msg.fromId == myId) {
            ///我发出的
            msg.fromName = [[[Client sharedInstance] user] username];
            msg.toName = [rs stringForColumn:@"username"];
        } else {
            msg.fromName = [rs stringForColumn:@"username"];
            msg.toName = [[[Client sharedInstance] user] username];
        }
       
        msg.text = [rs stringForColumn:@"message"];
        msg.sent = [rs intForColumn:@"sent"];
        msg.requestTime = [rs stringForColumn:@"req_time"];
        msg.sendTime = [rs stringForColumn:@"send_time"];
        
        [msgArr addObject:msg];
    }
    
    return msgArr;
}

- (NSMutableArray *)recentMsgs:(int)peerId {
    return [self recentMsgs:0 peerId:peerId];
}




#pragma mark - util

- (NSString *)defaultDbDir  {
    NSString *dbDir = [[UtilFileManager documentDir] stringByAppendingPathComponent:@"etim"];
    return dbDir;
}

- (NSString *)defaultDbPath {
    return [[self defaultDbDir] stringByAppendingPathComponent:localDbName];
}
@end

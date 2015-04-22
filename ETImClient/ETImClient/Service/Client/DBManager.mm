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
#import "DataStruct.h"

static NSString *const localDbName = @"etim.db";
static NSString *const tableMessage = @"message";
static NSString *const tableDraft = @"draft";
static NSString *const tableUser = @"user";

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
            NSString *dropMessageSql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS `%@`;", tableMessage];
            ///此地的sent与服务器端的sent不同 服务器端是说有没有发送到对方  客户端是指有没有成功发送给服务器
            NSString *messageSql = [NSString stringWithFormat:@"CREATE TABLE `%@` (`msg_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `msg_from` integer NOT NULL, `msg_to` integer NOT NULL, `req_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `send_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `sent` integer NOT NULL, `message` text NOT NULL);", tableMessage];
            
            NSString *dropDraftSql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS `%@`;", tableDraft];
            ///此地的sent与服务器端的sent不同 服务器端是说有没有发送到对方  客户端是指有没有成功发送给服务器
            NSString *draftSql = [NSString stringWithFormat:@"CREATE TABLE `%@` (`msg_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `msg_from` integer NOT NULL, `msg_to` integer NOT NULL, `req_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `send_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `sent` integer NOT NULL, `message` text NOT NULL);", tableDraft];
            
            NSString *dropUserSql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS `%@`;", tableUser];
            NSString *userSql = [NSString stringWithFormat:@"CREATE TABLE `%@` (`user_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `username` text NOT NULL, `reg_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `last_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `signature` text NOT NULL, `gender` integer NOT NULL, `status_id` integer NOT NULL);", tableUser];
            
            [_db executeUpdate:dropMessageSql];
            [_db executeUpdate:messageSql];
            [_db executeUpdate:dropDraftSql];
            [_db executeUpdate:draftSql];
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

- (BOOL)insertOneMsg:(MsgModel *)msg fromServer:(BOOL)fromServer msgId:(int *)msgId {
    ///TODO  解决msg_id与hash的碰撞问题
    NSString *sql;
    if (fromServer) {
        sql = [NSString stringWithFormat:@"INSERT INTO %@ (msg_id, msg_from, msg_to, req_time, send_time, sent, message) values('%@','%@','%@','%@','%@','%@','%@')",
               tableMessage,
               NSNUM_WITH_INT(msg.msgId),
               NSNUM_WITH_INT(msg.fromId),
               NSNUM_WITH_INT(msg.toId),
               msg.requestTime,
               msg.sendTime,
               @1,
               msg.text];
    } else {
        sql = [NSString stringWithFormat:@"INSERT INTO %@ (msg_from, msg_to, req_time, send_time, sent, message) values('%@','%@','%@','%@','%@','%@')",
               tableDraft,
               NSNUM_WITH_INT(msg.fromId),
               NSNUM_WITH_INT(msg.toId),
               msg.requestTime,
               msg.sendTime,
               NSNUM_WITH_INT((int)msg.sentStatus),
               msg.text];
    }


    BOOL result = [_db executeUpdate:sql];
    if (!result) {
        DDLogError(@"insertMsgs error: %@", [_db lastError]);
    }
    
    if (!fromServer) {
        *msgId = (int)[_db lastInsertRowId];
    }
    return result;
}
- (BOOL)insertMsgs:(NSMutableArray *)msgs {
    for (MsgModel *msg in msgs) {
        [self insertOneMsg:msg fromServer:YES msgId:NULL];
    }

    return YES;
}

- (BOOL)updateLocalMsgStatus:(SendMsgReturn)msgReturn {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE msg_id = '%@'",
                     tableDraft,
                     NSNUM_WITH_INT(msgReturn.uuid)];
    
    FMResultSet *rs = [_db executeQuery:sql];

    [_db beginTransaction];
    while([rs next]){
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE msg_id = '%@'",
                               tableDraft,
                               NSNUM_WITH_INT(msgReturn.uuid)];
        
        [_db executeUpdate:deleteSql];
        
        MsgModel *msg = [[MsgModel alloc] init];
        msg.msgId = msgReturn.msgId;
        msg.fromId = [rs intForColumn:@"msg_from"];
        msg.toId = [rs intForColumn:@"msg_to"];

        
        msg.text = [rs stringForColumn:@"message"];
        msg.sent = kMsgUnsent;
        msg.requestTime = [rs stringForColumn:@"req_time"];
        msg.sendTime = [rs stringForColumn:@"send_time"];
        [self insertOneMsg:msg fromServer:YES msgId:NULL];
        
    }

    
    BOOL result = [_db commit];
    if (!result) {
        DDLogError(@"updateLocalMsgStatus error: %@", [_db lastError]);
    }
    return result;
}

- (NSMutableArray *)peerRecentMsgs:(int)peerId  msgId:(int)msgId {
    NSString *sql;
    if (msgId == 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ m LEFT JOIN user u ON u.user_id = '%@' WHERE m.msg_from = %@ or m.msg_to = %@ ORDER BY req_time asc limit 20",
               tableMessage,
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId)];
    } else {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ m  LEFT JOIN user u ON u.user_id = '%@' WHERE (m.msg_from = %@ or m.msg_to = %@) AND msg_id < '%@' ORDER BY req_time asc limit 20",
               tableMessage,
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(msgId)];

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
            msg.source = kMsgSourceSelf;
        } else {
            msg.fromName = [rs stringForColumn:@"username"];
            msg.toName = [[[Client sharedInstance] user] username];
            msg.source = kMsgSourceOther;
        }
       
        msg.text = [rs stringForColumn:@"message"];
        msg.sent = [rs intForColumn:@"sent"];
        msg.requestTime = [rs stringForColumn:@"req_time"];
        msg.sendTime = [rs stringForColumn:@"send_time"];
        
        [msgArr addObject:msg];
    }
    
    return msgArr;
}

- (NSMutableArray *)peerRecentMsgs:(int)peerId {
    return [self peerRecentMsgs:peerId msgId:0];
}


- (NSMutableArray *)allRecentMsgs {
    return nil;
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

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
#import "NSString+PJR.h"

#include "Client.h"

using namespace etim;
using namespace etim::pub;

static NSString *const localDbName = @"etim.db";
static NSString *const tableMessage = @"message";
static NSString *const tableDraft = @"draft";
static NSString *const tableUser = @"user";
static NSString *const userNoSignature = @"暂无签名";


@interface DBManager () {
    FMDatabase      *_db;
}

@end


@implementation DBManager

- (void)dealloc {
    DDLogDebug(@"======= DBManager DEALLOC ========");
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

+ (void)destory {
    if (sharedDBManager) {
        sharedDBManager = nil;
        predicate = 0;
    }
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
    DDLogInfo(@"用户数据库路径: %@", dbPath);
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
            NSString *userSql = [NSString stringWithFormat:@"CREATE TABLE `%@` (`user_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `username` text NOT NULL, `reg_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `last_time` Timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP, `signature` text NOT NULL DEFAULT '%@' , `gender` integer NOT NULL DEFAULT '0', `status_id` integer NOT NULL DEFAULT `%d`);", tableUser, userNoSignature, kBuddyOffline];
            
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
    BOOL result = NO;
    NSString *sql = [NSString stringWithFormat:@"SELECT msg_id FROM %@ WHERE  msg_id = '%@'",
                     fromServer ? tableMessage : tableDraft,
                     NSNUM_WITH_INT(msg.msgId)];
     FMResultSet *rs = [_db executeQuery:sql];
    if ([rs next]) {
        //已存在  执行更新
        if (fromServer) {
            ///从SERVER来的更新消息表, 用户表
            sql = [NSString stringWithFormat:@"UPDATE %@ SET req_time = '%@', send_time = '%@', message = '%@' WHERE msg_id = '%@'",
                   tableMessage,
                   msg.requestTime,
                   msg.sendTime,
                   msg.text,
                   NSNUM_WITH_INT(msg.msgId)];
            [_db executeUpdate:sql];
            sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (user_id, username) VALUES (%@, '%@')",
                   tableUser,
                   [msg peerIdStr],
                   [msg peerName]];
            [_db executeUpdate:sql];
        } else {
            ///更新草稿表
            sql = [NSString stringWithFormat:@"UPDATE %@ SET req_time = '%@', text = '%@', ", tableDraft, msg.requestTime, msg.text];
            [_db executeUpdate:sql];
        }
    } else {
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
        
        
        result = [_db executeUpdate:sql];
        if (!result) {
            DDLogError(@"insertMsgs error: %@", [_db lastError]);
        }
        
        if (!fromServer) {
            *msgId = (int)[_db lastInsertRowId];
        }
    }
    
    
    return result;
}
- (BOOL)insertMsgs:(NSMutableArray *)msgs {
    [_db beginTransaction];
    for (MsgModel *msg in msgs) {
        [self insertOneMsg:msg fromServer:YES msgId:NULL];
    }

    return [_db commit];
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
    int limit = 20;
    if (msgId == 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM %@ m LEFT JOIN user u ON u.user_id = '%@' WHERE m.msg_from = %@ or m.msg_to = %@ ORDER BY msg_id DESC limit %d) ORDER BY req_time ASC",
               tableMessage,
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId),
               limit];
    } else {
        sql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM %@ m  LEFT JOIN user u ON u.user_id = '%@' WHERE (m.msg_from = %@ or m.msg_to = %@) AND msg_id < '%@' ORDER BY  msg_id DESC limit %d)  ORDER BY req_time ASC",
               tableMessage,
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(peerId),
               NSNUM_WITH_INT(msgId),
               limit];

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
    NSString *sql = [NSString stringWithFormat:@"select max(req_time), m.msg_from, (select u.username from %@ u where m.msg_from = u.user_id) user_from, msg_to, (select u.username from %@ u where m.msg_to = u.user_id) user_to, message, send_time, sent, msg_id from %@ m group by msg_from, msg_to", tableUser, tableUser, tableMessage];
    
    NSMutableArray *msgArr = [NSMutableArray array];
    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        MsgModel *msg = [[MsgModel alloc] init];
        msg.msgId = [rs intForColumn:@"msg_id"];
         msg.fromId = [rs intForColumn:@"msg_from"];
         msg.toId = [rs intForColumn:@"msg_to"];
        msg.fromName = [rs stringForColumn:@"user_from"];
        msg.toName = [rs stringForColumn:@"user_to"];
        msg.text = [rs stringForColumn:@"message"];
        msg.sent = [rs intForColumn:@"sent"];
        msg.requestTime = [rs stringForColumn:@"max(req_time)"];
        msg.sendTime = [rs stringForColumn:@"send_time"];
        
        [msgArr addObject:msg];
    }
    
    return msgArr;
}

- (BOOL)insertOneBuddy:(BuddyModel *)buddy {
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (user_id, username, reg_time, last_time, signature, gender, status_id) VALUES(%d, '%@','%@','%@','%@','%@', '%@')",
                     tableUser,
                     buddy.userId,
                     buddy.username,
                     [buddy regTime],
                     @"NULL",
                     [buddy.signature isValid] ? buddy.signature : userNoSignature,
                     NSNUM_WITH_INT((int)buddy.gender),
                     NSNUM_WITH_INT(kBuddyOffline)];
    
    
    BOOL result = [_db executeUpdate:sql];
    if (!result) {
        DDLogError(@"insertOneBuddy error: %@", [_db lastError]);
    }
    return result;
}
- (BOOL)insertBuddys:(NSMutableArray *)buddys {
    for (BuddyModel *buddy in buddys) {
        [self insertOneBuddy:buddy];
    }
    
    return YES;
}

- (NSMutableArray *)allBuddys {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_id != %d", tableUser, [Client sharedInstance].user.userId];
    NSMutableArray *buddyArr = [NSMutableArray array];
    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        BuddyModel *buddy = [[BuddyModel alloc] init];
        buddy.userId = [rs intForColumn:@"user_id"];
        buddy.username = [rs stringForColumn:@"username"];
        buddy.regTime = [rs stringForColumn:@"reg_time"];
        buddy.signature = [rs stringForColumn:@"signature"];
        buddy.gender = [rs intForColumn:@"gender"];
        buddy.relation = kBuddyRelationFriend;
        buddy.status = kBuddyOffline;
        
        [buddyArr addObject:buddy];
    }
    
    return buddyArr;
}


#pragma mark - util

///每个用户一个DB目录
- (NSString *)defaultDbDir  {
    NSString *userId = [NSString stringWithFormat:@"%06d", [Client sharedInstance].user.userId];
    NSString *dbDir = [[[UtilFileManager documentDir] stringByAppendingPathComponent:userId] stringByAppendingPathComponent:@"etimdb"];
    return dbDir;
}

- (NSString *)defaultDbPath {
    return [[self defaultDbDir] stringByAppendingPathComponent:localDbName];
}
@end

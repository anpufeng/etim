//
//  Client.m
//  ETImClient
//
//  Created by ethan on 8/6/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

/**
09 - 01 遇到的问题主要是多个命令连续发的时候会产生SESSION被改变而这时上一个命令可能还未发出(因为发送用异步, 虽然BLOCK所在线程是SERIAL的 , 主线程先于发送执行)
 所以导致发的CMD及PARAM被改变 后面考虑做成OPERATIONQUQUE 每次把CMD及PARAM存到
 NSOPERATION去执行 解决命令顺序问题
 */

#import "Client.h"
#import "BuddyModel.h"
#import "SendOperation.h"
#import "Reachability.h"
#import "NSTimer+WeakTarget.h"
#import "CmdParamModel.h"
#import "ReceivedManager.h"

#include "Socket.h"
#include "Logging.h"
#include "ActionManager.h"
#include "Exception.h"
#include <string>
#include <signal.h>
#include <map>
#include <sstream>
#include <string.h>
#include <stdio.h>
#include <arpa/inet.h>

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

static NSString *configServerIp = @"104.131.147.16";
static NSString *configServerPort = @"8888";


@interface Client () {
    @private
    etim::Session *_session;
}

@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) NSTimer *heartBeatTimer;
@property (nonatomic, strong) NSMutableArray *queuedCmdArr;


- (void)connectCallBack:(bool)connected;


@end




@implementation Client

static Client *sharedClient = nil;
static dispatch_once_t predicate;

///连接结果回调
void clientConnectCallBack(bool connected)  {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Client sharedInstance] connectCallBack:connected];
    });
    
}

+(Client*)sharedInstance{
    dispatch_once(&predicate, ^{
        sharedClient = [[Client alloc]init];
        //忽略send产生的sigpipe信号
        signal(SIGPIPE, SIG_IGN);
    });
    
    return sharedClient;
}

- (void)dealloc {
    DDLogDebug(@"======= Client DEALLOC ========");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoConnectionNotification object:nil];
    [_heartBeatTimer invalidate];
    [_sendedOpeartionQueue cancelAllOperations];
    _delegate = nil;
    if (_session) {
        delete _session;
    }
}

- (id)init {
    if (self = [super init]) {
        
        sockaddr_in addr = {0};
        addr.sin_family = AF_INET;
        addr.sin_port = htons([Client stdServerPort]);
        addr.sin_addr.s_addr = inet_addr([Client stdServerIp]);
        self.hostReachability = [Reachability reachabilityWithAddress:&addr];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showNoConnection:)
                                                     name:kNoConnectionNotification
                                                   object:nil];
        
        [self resetStatus];
        self.appActive = YES;
        self.queuedCmdArr = [NSMutableArray arrayWithCapacity:10];
        
        _sendedOpeartionQueue = [[NSOperationQueue alloc] init];
        _recvQueue = dispatch_queue_create("com.ethan.clientRecv", NULL);
        _connQueue = dispatch_queue_create("com.ethan.socketConnect", NULL);
    }
    
    return self;
}

- (void)resetStatus {
    self.login = NO;
    self.logout = YES;
    if (_sendedOpeartionQueue) {
        [_sendedOpeartionQueue cancelAllOperations];
    }
    
    if (_queuedCmdArr) {
        [_queuedCmdArr removeAllObjects];
    }
    [_heartBeatTimer invalidate];
}

#pragma mark -
#pragma mark connect

- (void)connectCallBack:(bool)connected {
    if (connected) {
        DDLogInfo(@"连接成功 ");
        if (_delegate && [_delegate respondsToSelector:@selector(socketConnectSuccess)]) {
            [_delegate socketConnectSuccess];
        } else {
            DDLogWarn(@"无回调delegate");
        }
        
    } else {
        DDLogInfo(@"连接失败");
        if (_delegate && [_delegate respondsToSelector:@selector(socketConnectFailure)]) {
            [_delegate socketConnectFailure];
        } else {
            DDLogWarn(@"无回调delegate");
        }
    }
}

- (void)connectWithDelegate:(id<Client>)delegate {
    
    if (!self.appActive) {
        DDLogInfo(@"APP不在active状态 不需重连");
        return;
    }

//    if (!_session && !self.login) {
//        DDLogInfo(@"用户未成功登录过 不需重连");
//        return;
//    }
//    if (_session && self.logout) {
//        DDLogInfo(@"用户已登出 不需重连");
//        return;
//    }
    if (_session) {
        if (_session->IsConnected()) {
            return;
        }
        _session->Close();
        [_heartBeatTimer invalidate];
    }
    
    _delegate = delegate;
    dispatch_async(_connQueue, ^{
        if (!_session) {
            std::auto_ptr<Socket> connSoc(new Socket(-1, 0));
                _session = new Session(connSoc, clientConnectCallBack, [Client stdServerIp], [Client stdServerPort]);
            
        } else {
            _session->Reconnect([Client stdServerIp], [Client stdServerPort]);
        }
        
        DDLogInfo(@"连接服务器 ip: %@, 端口: %@", configServerIp, configServerPort);
    });
}

- (void)reconnect {
    DDLogInfo(@"尝试重连");
    if ([self connected]) {
                DDLogInfo(@"已连接, 放弃重连");
        return;
    }
    
//    if (!_delegate) {
//        DDLogInfo(@"无delegate, 放弃重连");
//        return;
//    }
    

    
    [self connectWithDelegate:self];
}

- (BOOL)connected {
    if (_session) {
    return _session->IsConnected();
    } else {
        return NO;
    }

}
- (void)disconnect {
    if (_session) {
        _session->Close();
        _delegate = nil;
        DDLogInfo(@"关闭连接");
    }
}

- (void)startReachabilityNoti {
    [self.hostReachability startNotifier];
}

- (etim::Session *)session {
    if (_session) {
        return _session;
    }
    
    return NULL;
}
- (void)pullUnread {
    [self pullWithCommand:CMD_UNREAD];
}

- (void)autoLogin {
    if (_session && _session->IsConnected()) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.user.username forKey:@"name"];
        [param setObject:self.pwd forKey:@"pass"];
        [self doAction:*_session cmd:CMD_LOGIN param:param];
    } else {
        DDLogWarn(@"重登时无可用session或无连接");
    }

}

///只有参数为userId时的命令操作
- (void)pullWithCommand:(uint16)cmd {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    string value = Convert::IntToString(_user.userId);
    [param setObject:stdStrToNsStr(value) forKey:@"userId"];
    [self doAction:*_session cmd:cmd param:param];
}

- (void)heartBeart {
    if (_session && _session->IsConnected()) {
            [self pullWithCommand:CMD_HEART_BEAT];
    }
}

#pragma mark -
#pragma mark send & recv action

- (void)doAction:(etim::Session &)s cmd:(etim::uint16)cmd param:(NSMutableDictionary *)params {
    CmdParamModel *model = [[CmdParamModel alloc] init];
    model.cmd = cmd;
    model.params = params;
    
    if (&s) {
        if (s.IsConnected()) {
            try {
                DDLogInfo(@"发送cmd: 0X%04X, 通知名称: %@， 参数: %@", cmd, notiNameFromCmd(cmd), params);

                SendOperation *operation = [[SendOperation alloc] initWithCmdParamModel:model];
                [_sendedOpeartionQueue addOperation:operation];
            } catch (Exception &e) {
                DDLogError(@"出错发送cmd: 0X%04X, 通知名称: %@", cmd, notiNameFromCmd(cmd));
                s.SetErrorCode(kErrCodeMax);
                s.SetErrorMsg(e.what());
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(cmd) object:nil];
                });
                
            }
        } else {
            s.SetErrorCode(kErrCodeMax);
            s.SetErrorMsg("无服务器连接");
            [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(cmd) object:nil];
            [self.queuedCmdArr addObject:model];
            [self reconnect];
        }
    } else {
        DDLogWarn(@"还未建立连接 无可用session");
        [self.queuedCmdArr addObject:model];
        [self reconnect];
    }
   
}

- (void)doRecvAction {
    dispatch_async(_recvQueue, ^{
        while (1) {
            if (!_session) {
                DDLogWarn(@"无可用session");
                break;
            }
            
            if (!_session->IsConnected()) {
                DDLogDebug(@"session 无连接");
                sleep(1);
                continue;
            }
            
            try {
                DDLogInfo(@"有可用session doRecvAction");
                Singleton<ActionManager>::Instance().RecvPacket(*_session);
                ///必须dispatch_sync,不然如果多个命令连续的话会导致重新发出相同的最后一个命令名称
                dispatch_sync(dispatch_get_main_queue(), ^{
                    DDLogInfo(@"接收cmd: 0X%04X, 通知名称: %@", _session->GetRecvCmd(), notiNameFromCmd(_session->GetRecvCmd()));
                    ///一些特殊命令回调
                    if (_session->GetRecvCmd() == CMD_LOGIN) {
                        if (!_session->IsError()) {
                            self.login = YES;
                            self.logout = NO;
                        }
                    } else if (_session->GetRecvCmd() == CMD_LOGOUT) {
                        if (!_session->IsError()) {
                            self.logout = YES;
                        }
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(_session->GetRecvCmd())
                                                                        object:nil];

                    
                });
                
            } catch (RecvException &e) {
                DDLogInfo(@"RecvException: %s", e.what());
                if (e.GetReceived() == 0) {
                    DDLogError(@"服务端关闭");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reconnect];
                    });
                    break;
                    
                    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"服务器错误" description:@"服务端关闭" type:TWMessageBarMessageTypeError];
                
                    break;
                } else if (e.GetReceived() == -1) {
                    DDLogError(@"接收出错 %s", e.what());
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reconnect];
                    });
                    break;
                } else {
                    _session->SetErrorCode(kErrCodeMax);
                    _session->SetErrorMsg(e.what());
                    DDLogError(@"%s", e.what());
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(_session->GetRecvCmd()) object:nil];
                    });
                }
            } catch (Exception &e) {
                DDLogInfo(@"Exception: %s", e.what());
            }

        }
    });
}

#pragma mark -
#pragma mark Reachability
/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
        {
            [self disconnect];
        }
            
            break;
        case ReachableViaWWAN:
        case ReachableViaWiFi:
        {
            //[self connect];
        }
            break;
    }
}

- (void)showNoConnection:(NSNotification *)note {
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    DDLogInfo(@"status : %ld", reach.currentReachabilityStatus);
    if (reach.currentReachabilityStatus == NotReachable) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"网络错误" description:@"无网络连接" type:TWMessageBarMessageTypeError];
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"服务器错误" description:@"无法连接至服务器" type:TWMessageBarMessageTypeError];
    }
    
}

#pragma mark -
#pragma mark Client delegate

- (void)socketConnectSuccess {
    [self doRecvAction];
    _heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT_SECONDS weakTarget:self selector:@selector(heartBeart) userInfo:nil repeats:YES];
    if (self.login) {
        [self autoLogin];
    }
    
    [self.queuedCmdArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CmdParamModel *model = (CmdParamModel *)obj;
        SendOperation *operation = [[SendOperation alloc] initWithCmdParamModel:model];
        DDLogInfo(@"开始执行未完成的命令 %@", model);
        [_sendedOpeartionQueue addOperation:operation];
    }];
    [self.queuedCmdArr removeAllObjects];
    
}
- (void)socketConnectFailure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), _connQueue, ^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reconnect];
        });
    });

}

#pragma mark -
#pragma mark config


+ (NSString *)serverIp {
    return configServerIp;
}
+ (NSString *)serverPort {
    return configServerPort;
}

+ (char *)stdServerIp {
    return const_cast<char *>([configServerIp UTF8String]);
}
+ (unsigned short)stdServerPort {
    return static_cast<unsigned short>([configServerPort intValue]);
}

+ (void)updateServerIp:(NSString *)ip {
    configServerIp = ip;
}
+ (void )updateserverPort:(NSString *)port {
    configServerPort = port;
}

@end

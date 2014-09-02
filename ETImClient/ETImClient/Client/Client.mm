//
//  Client.m
//  ETImClient
//
//  Created by ethan on 8/6/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import "Client.h"
#include "Socket.h"
#include "Logging.h"
#include "ActionManager.h"
#include "Exception.h"
#include <string>
#include <signal.h>
#include <map>

using namespace etim;
using namespace etim::pub;


@interface Client () {
    @private
    etim::Session *_session;
}


@end

@implementation Client

static Client *sharedClient = nil;
static dispatch_once_t predicate;

+(Client*)sharedInstance{
    dispatch_once(&predicate, ^{
        sharedClient=[[Client alloc]init];
        //忽略send产生的sigpipe信号
        signal(SIGPIPE, SIG_IGN);
    });
    
    return sharedClient;
}

+ (void)sharedDealloc {
    if (sharedClient) {
        sharedClient = nil;
        predicate = 0;
    }
    
    return;
}

- (void)dealloc {
    ETLOG(@"======= Client DEALLOC ========");
    delete _session;
}

- (id)init {
    if (self = [super init]) {
        _actionQueue = dispatch_queue_create("clientSend", NULL);
        _recvQueue = dispatch_queue_create("clientRecv", NULL);
        std::auto_ptr<Socket> connSoc(new Socket(-1, 0));
        ///令人头痛的命名冲突
        _session = new Session(connSoc);
        [self doRecv:*_session];
    }
    
    return self;
}

- (etim::Session *)session {
    return _session;
}

- (void)pullUnread {
    
    [self pullWithCommand:CMD_UNREAD];
}

///获取未读消息
- (void)pullWithCommand:(uint16)cmd {
    _session->Clear();
    _session->SetSendCmd(cmd);
    _session->SetAttribute("name", _session->GetIMUser().username);
    [self doAction:*_session];
}
 

#pragma mark -
#pragma mark send & recv action

- (void)doAction:(etim::Session &)s {
    if (s.IsConnected()) {
        __weak Client *wself = self;
        dispatch_async(_actionQueue, ^{
            if (!wself)
                return;
            try {
                ETLOG(@"发送cmd: %0X, 通知名称: %@", s.GetSendCmd(), notiNameFromCmd(s.GetSendCmd()));
                std::map<std::string, std::string> request = s.GetRequest();
                std::map<std::string, std::string>::iterator it;
                for(it = request.begin(); it != request.end(); it++) {
                    std::cout<<it->first <<"->"<<it->second<<std::endl;
                }
                
                Singleton<ActionManager>::Instance().SendPacket(s);
            } catch (Exception &e) {
                if (!wself)
                    return;
                ETLOG(@"出错发送cmd: %0X, 通知名称: %@", s.GetSendCmd(), notiNameFromCmd(s.GetSendCmd()));
                s.SetErrorCode(kErrCodeMax);
                s.SetErrorMsg(e.what());
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(s.GetSendCmd()) object:nil];
                });
            }
            
        });
    } else {
        s.SetErrorCode(kErrCodeMax);
        s.SetErrorMsg("无服务器连接");
        [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(s.GetSendCmd()) object:nil];
    }
   
}

- (void)doRecv:(etim::Session &)s {
    if (s.IsConnected()) {
        __weak Client *wself = self;
        dispatch_async(_recvQueue, ^{
            while (1) {
                if (!wself)
                    break;
                try {
                    Singleton<ActionManager>::Instance().RecvPacket(s);
                    if (!wself)
                        break;
                    ///必须dispatch_sync,不然如果多个命令连续的话会导致重新发出相同的最后一个命令名称
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        ETLOG(@"接收cmd: %0X, 通知名称: %@", s.GetRecvCmd(), notiNameFromCmd(s.GetRecvCmd()));
                        [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(s.GetRecvCmd()) object:nil];
                    });
                } catch (RecvException &e) {
                    if (!wself)
                        return;
                    LOG_INFO<<e.what();
                    if (e.GetReceived() == 0) {
                        LOG_ERROR<<"服务端关闭";
                        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"服务器错误" description:@"服务端关闭" type:TWMessageBarMessageTypeError];
                        
                        s.SetErrorCode(kErrCodeMax);
                        s.SetErrorMsg(e.what());
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(s.GetSendCmd()) object:nil];
                        });

                        break;
                    } else if (e.GetReceived() == -1) {
                        LOG_ERROR<<"接收出错";
                    } else {
                        s.SetErrorCode(kErrCodeMax);
                        s.SetErrorMsg(e.what());
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(s.GetRecvCmd()) object:nil];
                        });
                    }
                }
                
                catch (Exception &e) {
                    if (!wself)
                        return;
                    LOG_INFO<<e.what();
                }

                
            }
        });
    } else {
        s.SetErrorCode(kErrCodeMax);
        s.SetErrorMsg("无服务器连接");
        [[NSNotificationCenter defaultCenter] postNotificationName:notiNameFromCmd(s.GetSendCmd()) object:nil];
    }
}

@end

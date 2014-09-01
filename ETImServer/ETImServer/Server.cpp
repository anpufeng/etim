//
//  Server.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Server.h"
#include "Logging.h"
#include "ActionManager.h"
#include "Exception.h"
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

using namespace etim;
using namespace etim::pub;

fd_set Server::readFds_;

Server::Server() : fdMax_(-1) {
    
}

Server::~Server() {
    LOG_INFO<<"~Server析构";
    typedef std::vector<Session *>::iterator iter;
    for (iter it = sessions_.begin(); it != sessions_.end(); it++) {
        Session *ps = *it;
        delete ps;
    }
}

int Server::Start() {
    LOG_INFO<<"服务器启动";
    Socket soc;
    soc.Create();
    soc.Bind(nullptr);
    soc.Listen();
    LOG_INFO<<"开始监听";
    int listenFd = soc.GetFd();
    fdMax_ = listenFd;
    
    ///将监听fd加入到集合中

    
    
    //fd_set writeFds;
    
    while (1) {
        FD_ZERO(&readFds_);
        FD_SET(listenFd, &readFds_);
        
        typedef std::vector<Session *>::iterator iter;
        for (iter it = sessions_.begin(); it != sessions_.end(); ++it) {
            Session *s = *it;
            int fd = s->GetFd();
            FD_SET(fd, &readFds_);
        }
        
        struct timeval timeout;
        timeout.tv_sec = 3;
        timeout.tv_usec = 0;
        
        int ready = select(fdMax_ + 1, &readFds_, nullptr, nullptr, &timeout);
        if (ready == -1) {
            LOG_ERROR<<"select error: "<<strerror(errno);
            continue;
        }
        
        //继续监听
        if (ready <= 0) {
            continue;
        }
        
        ///如果监听端口有可读
        if (FD_ISSET(listenFd, &readFds_)) {
            int connFd = soc.Accept();
            LOG_INFO<<"有新客户端连接 :";
            if (connFd == -1) {
                printf("accept error");
                continue;
            }
            if (connFd > fdMax_) {
                fdMax_ = connFd;
            }
            
            std::auto_ptr<Socket> connSoc(new Socket(connFd, 0));
            Session *s = new Session(connSoc);
            sessions_.push_back(s);
        }
        
        //检测是否有sesion有可读
        for (iter it = sessions_.begin(); it != sessions_.end();) {
            Session *s = *it;
            int fd = s->GetFd();
            if (FD_ISSET(fd, &readFds_)) {
                ///取消事件
                FD_CLR(fd, &readFds_);
                int result = 1;
                try {
                    s->Recv(&result);
                    //根据接收的数据做出相应的操作
                    Singleton<ActionManager>::Instance().DoAction(s);
                    ++it;
                } catch (Exception &e) {
                    if (result == 0) {
                        //服务端关闭
                        delete s;
                        sessions_.erase(std::remove(sessions_.begin(), sessions_.end(), s));
                    } else {
                        ++it;
                        //TODO 其它出错的处理
                    }
                    LOG_ERROR<<e.what();
                }
                
            } else {
                ++it;
            }
        }
    } //end while
    
    return 0;
}


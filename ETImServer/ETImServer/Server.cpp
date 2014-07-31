//
//  Server.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Server.h"
#include "ActionManager.h"
#include <sys/select.h>

using namespace etim;
using namespace etim::pub;

fd_set Server::readFds_;

Server::Server() : fdMax_(-1) {
    
}

Server::~Server() {
    
}

int Server::Start() {
    Socket soc;
    soc.Create();
    soc.Bind(nullptr);
    soc.Listen();
    int listenFd = soc.GetFd();
    fdMax_ = listenFd;
    
    ///将监听fd加入到集合中
    FD_ZERO(&readFds_);
    FD_SET(listenFd, &readFds_);
    
    fd_set writeFds;
    struct timeval timeout;
    timeout.tv_sec = 10;
    timeout.tv_usec = 0;
    
    while (1) {
        int ready = select(fdMax_ + 1, &readFds_, &writeFds, nullptr, &timeout);
        if (ready == -1) {
            printf("select error");
            exit(EXIT_FAILURE);
        }
        
        //继续监听
        if (ready <= 0) {
            continue;
        }
        
        ///如果监听端口有可读
        if (FD_ISSET(listenFd, &readFds_)) {
            int connFd = soc.Accept();
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
        std::vector<Session *>::iterator iter;
        for (iter = sessions_.begin(); iter != sessions_.end(); iter++) {
            Session s = **iter;
            int fd = s.GetFd();
            if (FD_ISSET(fd, &readFds_)) {
                Singleton<ActionManager>::Instance().DoAction(s);
                ///取消事件
                FD_CLR(fd, &readFds_);
            }
        }
        
    } //end while
    
    return 0;
}


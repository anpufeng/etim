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
#include <unistd.h>
#include <signal.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/time.h>
#include <time.h>
#include <algorithm>

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
    
    int listenFd = soc.GetFd();
    gettimeofday(&lastKick_, NULL);
    
    LOG_INFO<<"开始监听";
    //fd_set writeFds;
    
    while (1) {
        FD_ZERO(&readFds_);  //将监听fd加入到集合中
        FD_SET(listenFd, &readFds_);
        fdMax_ = listenFd;
        
        for (iter it = sessions_.begin(); it != sessions_.end(); ++it) {
            Session *s = *it;
            int fd = s->GetFd();
            if (fd > fdMax_) {
                fdMax_ = fd;
            }
            FD_SET(fd, &readFds_);
        }
        
        struct timeval timeout;
        timeout.tv_sec = 5;
        timeout.tv_usec = 0;
        
        int ready = select(fdMax_ + 1, &readFds_, nullptr, nullptr, &timeout);
        if (ready == -1) {
            LOG_ERROR<<"select error: "<<strerror(errno);
            continue;
        }
        
        //继续监听
        if (ready <= 0) {
            KickOut();
            continue;
        }
        
        ///如果监听端口有可读
        if (FD_ISSET(listenFd, &readFds_)) {
            int connFd = soc.Accept();
            
            if (connFd == -1) {
                LOG_ERROR<<"accept error"<<strerror(errno);
                continue;
            }
            LOG_INFO<<"有新客户端连接 :";
            if (connFd > fdMax_) {
                fdMax_ = connFd;
            }
            
            std::auto_ptr<Socket> connSoc(new Socket(connFd, 0));
            Session *s = new Session(connSoc);
            timeval now;
            gettimeofday(&now, NULL);
            s->SetLastTime(now);
            sessions_.push_back(s);
        }
        
        //找出有sesion->sock可读, 并执行相应操作
        timeval now;
        gettimeofday(&now, NULL);
        for (iter it = sessions_.begin(); it != sessions_.end();) {
            Session *s = *it;
            int fd = s->GetFd();
            if (FD_ISSET(fd, &readFds_)) {
                s->SetLastTime(now);
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
                        //服务端关闭此session
                        LOG_INFO<<"客户端关闭socket userId: "<<s->GetIMUser().userId;
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
        
        //踢出
        KickOut();
    } //end while
    
    return 0;
}


/*
 //循环找出超时session, 同时将此session踢出
 */
void Server::KickOut() {
    timeval now;
    gettimeofday(&now, NULL);
    if (!(now.tv_sec - lastKick_.tv_sec > HEART_BEAT_SECONDS)) {
        return;
    }
    
    for (iter it = sessions_.begin(); it != sessions_.end();) {
        Session *s = *it;
        long diff = now.tv_sec - s->GetLastTime().tv_sec;
        if (diff > 20 * HEART_BEAT_SECONDS) {
            LOG_INFO<<"客户端超时 socket userId: "<<s->GetIMUser().userId<<" 超时时间: "<<diff<<"s";
            //TODO 刷新用户状态
            delete s;
            sessions_.erase(std::remove(sessions_.begin(), sessions_.end(), s));
        } else {
            ++it;
        }
    }

}

Session *Server::FindSession(int userId) {
    iter it =  find_if(sessions_.begin(), sessions_.end(), SessionFinder(userId));
    if (it == sessions_.end()) {
        return NULL;
    } else {
        return *it;
    }
}

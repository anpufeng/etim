//
//  Socket.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Socket.h"
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

namespace etim {
    
    Socket::Socket() : fd_(-1), port_(8888) {
        
    }
    
    Socket::~Socket() {
        if (IsValid()) {
            ::close(fd_);
        }
    }
    
    bool Socket::Create() {
        fd_ = ::socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        if (fd_ == -1) {
            printf("socket error %s", strerror(errno));
            return false;
        }
        
        // set the SO_REUSEADDR
        int val = 1;
        int result = ::setsockopt(fd_, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
        if (result == -1) {
            printf("setsockopt error %s", strerror(errno));
        }

            return true;
    }
    
    bool Socket::Bind(char *ip) {
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(port_);
        addr.sin_addr.s_addr = INADDR_ANY;
        
        
        if (::bind(fd_, (struct sockaddr*) &addr, sizeof(addr)))
        {
            printf("bind error %s", strerror(errno));
            return false;
        }
        
        return true;
    }
    
    bool Socket::Listen() {
        if (::listen(fd_, 5) < 0) {
            printf("listen error %s", strerror(errno));
        }
        
        return true;
    }
    
    int Socket::Accept() {
        struct sockaddr_in clientAddr;
        int len = sizeof(struct sockaddr_in);
        int sock = ::accept(fd_, (struct sockaddr *)&clientAddr, (socklen_t *)&len);
        return sock;
    }
    
    bool Socket::Connect(char *ip, unsigned short port) {
        return true;
    }
    
 }   //end namespace etim

//
//  Socket.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Socket.h"
#include "Logging.h"
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>


using namespace etim;
    
Socket::Socket() : fd_(-1), port_(8888) {
    
}

Socket::Socket(int fd, short port) : fd_(fd), port_(port) {
    
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
    
    
    if (::bind(fd_, (struct sockaddr*) &addr, sizeof(addr))) {
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


/**
 接收连接
@return -1错误 其它为连接的fd
 */
int Socket::Accept() {
    struct sockaddr_in clientAddr;
    int len = sizeof(struct sockaddr_in);
    int sock = ::accept(fd_, (struct sockaddr *)&clientAddr, (socklen_t *)&len);

    printf("%d\n", clientAddr.sin_addr.s_addr);
    LOG_INFO<<"accept 客户端IP"<<inet_ntoa(clientAddr.sin_addr);

    return sock;
}

bool Socket::Connect(char *ip, unsigned short port) {
    sockaddr_in addr = {0};
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = inet_addr(ip);
    int ret = ::connect(fd_, (sockaddr*)&addr, sizeof(addr));
	if (ret < 0) {
        return false;
    }
    
	return true;
}
    

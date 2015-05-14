//
//  Socket.h
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Socket__
#define __ETImServer__Socket__


#define HOST_PORT                   8888

#include <iostream>

namespace etim {
    
///一些socket功能和基本封装
class Socket {
private:
    Socket(const Socket &rhs);
    void operator=(const Socket &rhs);
public:
    Socket();
    Socket(int fd, short port);
    ~Socket();
    bool Create();
    bool Bind(char *ip);
    bool Listen();
    int Accept();
    bool Connect(char *ip, unsigned short port);
    void Close();
    int SendN(const char* buf, size_t len);
    int RecvN(char* buf, size_t len);
    int GetFd() const { return fd_; }
    
    bool IsValid() const { return fd_ != -1; }
private:
    int fd_;
    short port_;
};
    
}   //end namespace etim

#endif /* defined(__ETImServer__Socket__) */

//
//  Socket.h
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Socket__
#define __ETImServer__Socket__

#include <iostream>

namespace etim {
    
///一些socket功能和基本封装
class Socket {
private:
    Socket(const Socket &rhs);
    void operator=(const Socket &rhs);
public:
    Socket();
    ~Socket();
    bool Create();
    bool Bind(char *ip);
    bool Listen();
    int Accept();
    bool Connect(char *ip, unsigned short port);
    void Close();
    int Send();
    int Recv();
    int SendN();
    int RecvN();
    
    bool IsValid() const { return fd_ == -1; }
private:
    int fd_;
    int port_;
};
    
}   //end namespace etim

#endif /* defined(__ETImServer__Socket__) */

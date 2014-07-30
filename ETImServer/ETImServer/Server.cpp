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

Server::Server() : fdMax_(-1) {
    
}

int Server::Start() {
    
    while (1) {
        RecvSend();
        ParsePacket();
    }
    return 0;
}

void Server::RecvSend() {
    fd_set writeFds;
    struct timeval timeout;
    timeout.tv_sec = 10;
    timeout.tv_usec = 0;
    
    int result = select(fdMax_ + 1, &readFds_, &writeFds, nullptr, &timeout);
    if (result <= 0) {
        printf("select error");
        return;
    }
    
    std::vector<Session>::iterator iter;
    for (iter = sessions_.begin(); iter != sessions_.end(); iter++) {
        Session s = *iter;
        Singleton<ActionManager>::Instance().DoAction(s);
    }
    
    
}

void Server::ParsePacket() {
    
}
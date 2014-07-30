//
//  Server.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Server.h"

using namespace etim;


int Server::Start() {
    
    while (1) {
        RecvSend();
        ParsePacket();
    }
    return 0;
}

void Server::RecvSend() {
    
}

void Server::ParsePacket() {
    
}
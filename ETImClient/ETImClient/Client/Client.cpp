//
//  Client.cpp
//  ETImClient
//
//  Created by Ethan on 14/8/4.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Client.h"
#include "Socket.h"
#include "Logging.h"
#include <string>

using namespace etim;

Client::Client()  {
    std::auto_ptr<Socket> connSoc(new Socket(-1, 0));
    session_ = new Session(connSoc);
}

Client::~Client() {
    delete session_;
}

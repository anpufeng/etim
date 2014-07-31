//
//  Session.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/29.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Session.h"

using namespace etim;

Session::Session(std::auto_ptr<Socket> &socket) : socket_(socket) {
    
}

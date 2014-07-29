//
//  Server.h
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Server__
#define __ETImServer__Server__

#include <iostream>
#include <vector>

namespace etim {

class Session;
    
///主服务
class Server {
private:
    
public:
    
    Server() {};
    ~Server() {};

    int Start();
public:
    static fd_set fdSet_;
    std::vector<Session> sessions_;
};

}   //end namespace etim


#endif /* defined(__ETImServer__Server__) */

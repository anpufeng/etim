//
//  Client.h
//  ETImClient
//
//  Created by Ethan on 14/8/4.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImClient__Client__
#define __ETImClient__Client__

#include <iostream>
#include "Singleton.h"
#include "Session.h"

namespace etim {
    
    
    ///主服务, 主要用来管理socket
    class Client {
        friend class pub::Singleton<Client>;
    private:
        
    public:
        
        Client();
        ~Client();
        
        Session *GetSession() { return session_; }
        int Start() const;

        
        int Connect() const;
        int Disconnet() const;
    private:
        Session *session_;
        bool isConnected_;
    };
    
}   //end etim

#endif /* defined(__ETImClient__Client__) */

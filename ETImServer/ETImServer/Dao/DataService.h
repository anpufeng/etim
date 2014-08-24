//
//  DataService.h
//  ETImServer
//
//  Created by Ethan on 14/8/8.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__DataService__
#define __ETImServer__DataService__

#include <iostream>
#include "DataStruct.h"

namespace etim  {
    
    class Session;
    
    class BDataService {
    public:
        virtual int UserRegister(const std::string& username, const std::string& pass) = 0;
        virtual int UserLogin(const std::string& username, const std::string& pass, IMUser &user) = 0;
        virtual int UserLogout(const std::string& username, Session *s) = 0;
        virtual int UserSearch(const std::string &username, Session *s, IMUser &user) = 0;
    };
    
    
    class DataService : public BDataService {
        public:
        int UserRegister(const std::string& username, const std::string& pass);
        int UserLogin(const std::string& username, const std::string& pass, IMUser &user);
        int UserLogout(const std::string& username, Session *s);
        int UserSearch(const std::string &username, Session *s, IMUser &user);
    };
}   //end etim

#endif /* defined(__ETImServer__DataService__) */

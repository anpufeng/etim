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
    
    class BDataService {
    public:
        virtual int UserRegister(const std::string& username, const std::string& pass) = 0;
        virtual int UserLogin(const std::string& username, const std::string& pass, IMUser &user) = 0;
        virtual int UserLogout(const std::string& username, double& interest) = 0;
    };
    
    
    
    
    class DataService : public BDataService {
        public:
        // 用户注册
        int UserRegister(const std::string& username, const std::string& pass);
        /*
         @return int 0为正常
         */
        // 用户登录
        int  UserLogin(const std::string& username, const std::string& pass, IMUser &user);
        // 用户登出
        int UserLogout(const std::string& username, double& interest);
    };
}   //end etim

#endif /* defined(__ETImServer__DataService__) */

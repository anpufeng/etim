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
#include <list>
#include "DataStruct.h"
#include "Session.h"

namespace etim  {
    
    class Session;
    
    class BDataService {
    public:
        virtual int UserRegister(const std::string& username, const std::string& pass) = 0;
        virtual int UserLogin(const std::string& username, const std::string& pass, IMUser &user) = 0;
        virtual int UserLogout(const std::string& username, Session *s) = 0;
        virtual int UserSearch(const std::string &username, Session *s, IMUser &user) = 0;
        virtual int RequestAddBuddy(const std::string &from, const std::string to) = 0;
        virtual int RetrieveBuddyList(const std::string &username, std::list<IMUser> &result) = 0;
        virtual int RetrieveUnreadMsg(const std::string &username, std::list<IMMsg> &result) = 0;
    };
    
    
    class DataService : public BDataService {
    public:
        int UserRegister(const std::string& username, const std::string& pass);
        int UserLogin(const std::string& username, const std::string& pass, IMUser &user);
        int UserLogout(const std::string& username, Session *s);
        int UserSearch(const std::string &username, Session *s, IMUser &user);
        int RequestAddBuddy(const std::string &from, const std::string to);
        int RetrieveBuddyList(const std::string &username, std::list<IMUser> &result);
        int RetrieveUnreadMsg(const std::string &username, std::list<IMMsg> &result);
        
    public:
        int UpdateStatus(const std::string &username, BuddyStatus status);
        int SearchUserStatus(const std::string &username);

    };
}   //end etim

#endif /* defined(__ETImServer__DataService__) */

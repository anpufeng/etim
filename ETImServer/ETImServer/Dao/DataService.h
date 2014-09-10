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
        virtual int UserRegister(const std::string &username, const std::string &pass) = 0;
        virtual int UserLogin(const std::string &username, const std::string &pass, IMUser &user) = 0;
        virtual int UserLogout(const std::string &userId, IMUser &user) = 0;
        virtual int UserSearch(const std::string &username, Session *s, IMUser &user) = 0;
        virtual int RequestAddBuddy(const std::string &from, const std::string &to, std::string &toId, std::string &reqId) = 0;
        virtual int AcceptAddBuddy(const std::string &from, const std::string &to, const std::string req, const bool peer, IMUser &fromUser) = 0;
        virtual int RejectAddBuddy(const std::string &from, const std::string &to, const std::string req) = 0;
        virtual int RetrieveBuddyList(const std::string &userId, const bool online, const bool my, std::list<IMUser> &result) = 0;
        virtual int RetrieveUnreadMsg(const std::string &userId, std::list<IMMsg> &result) = 0;
        virtual int RetrievePendingBuddyRequest(const std::string &userId, std::list<IMUser> &result) = 0;
        virtual int RetrieveAllBuddyRequest(const std::string &userId, std::list<IMReq> &result) = 0;
    };
    
    
    class DataService : public BDataService {
    public:
        int UserRegister(const std::string &username, const std::string &pass);
        int UserLogin(const std::string &username, const std::string &pass, IMUser &user);
        int UserLogout(const std::string &userId, IMUser &user);
        int UserSearch(const std::string &username, Session *s, IMUser &user);
        int RequestAddBuddy(const std::string &from, const std::string &to, std::string &toId, std::string &reqId);
        int AcceptAddBuddy(const std::string &from, const std::string &to, const std::string req, const bool peer, IMUser &fromUser);
        int RejectAddBuddy(const std::string &from, const std::string &to, const std::string req);
        int RetrieveBuddyList(const std::string &userId, const bool online, const bool my, std::list<IMUser> &result);
        int RetrieveUnreadMsg(const std::string &userId, std::list<IMMsg> &result);
        int RetrievePendingBuddyRequest(const std::string &userId, std::list<IMUser> &result);
        int RetrieveAllBuddyRequest(const std::string &userId, std::list<IMReq> &result);
        
    public:
        int UpdateUserStatus(const std::string &userId, BuddyStatus status);
        int SearchUserStatus(const std::string &username);
        int UpdateActionSendTime(const std::string reqId);
        int UpdateRequestSendTime(const std::string reqId);


    };
}   //end etim

#endif /* defined(__ETImServer__DataService__) */

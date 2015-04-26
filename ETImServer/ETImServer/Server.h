//
//  Server.h
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Server__
#define __ETImServer__Server__

#include "Singleton.h"
#include "Session.h"
#include "Socket.h"
#include "Config.h"
#include <sys/select.h>
#include <unistd.h>
#include <iostream>
#include <vector>

namespace etim {

    
    ///主服务
    class Server {
        friend class pub::Singleton<Server>;
    private:
        
    public:
        
        const std::string& GetServerIp() const
        {
            return serverIp_;
        }
        
        unsigned short GetPort() const
        {
            return port_;
        }
        
        const std::string& GetDbServerIp() const
        {
            return dbServerIp_;
        }
        
        unsigned short GetDbServerPort() const
        {
            return dbServerPort_;
        }
        
        const std::string& GetDbUser() const
        {
            return dbUser_;
        }
        
        const std::string& GetDbPass() const
        {
            return dbPass_;
        }
        
        const std::string& GetDbName() const
        {
            return dbName_;
        }

        int Start();
        void KickOut();
        Session *FindSession(int userId);
        void DeleteSession(Session *s);
    private:
        Server();
        Server(const Server& rhs);
        ~Server();
        
        pub::Config  config_;
        std::string serverIp_;
        unsigned short port_;
        std::string dbServerIp_;
        unsigned short dbServerPort_;
        std::string dbUser_;
        std::string dbPass_;
        std::string dbName_;
        
        typedef std::vector<Session *>::iterator iter;
        static fd_set readFds_;
        
        int fdMax_;
        std::vector<Session *> sessions_;
        timeval lastKick_;
    };

}   //end etim


#endif /* defined(__ETImServer__Server__) */

//
//  DataService.cpp
//  ETImServer
//
//  Created by Ethan on 14/8/8.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "DataService.h"
#include "MysqlDB.h"
#include "Logging.h"
#include "Exception.h"
#include "Session.h"

#include <sstream>

using namespace etim;
using namespace etim::pub;
using namespace std;

int DataService::UserRegister(const std::string &user, const std::string &pass) {
    MysqlDB db;
    
    try {
        db.Open();
        stringstream ss;
        //insert into user(user_id, username, password, reg_time, last_time, gender, status) values(null, 'admin', 'admin', now(), now(), 0, 3);
        ss<<"insert into user (user_id, username, password, reg_time, last_time, gender, status) values(null, '"<<
        user<<"', '"<<
        pass<<"', "<<
        " now(), "<<
        " now(), "<<
        0<<","<<
        kBuddyOffline<<");";
        
        unsigned long long ret = db.ExecSQL(ss.str().c_str());
        
        ret = db.ExecSQL(ss.str().c_str());
    } catch (Exception &e) {
        LOG_INFO<<e.what();
        db.Rollback();
        return kErrCode002;
    }
    
    return kErrCode000;
}

int DataService:: UserLogin(const std::string& user, const std::string& pass) {
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        ss<<"select user_id from user where username='"<<
        user<<"' and password='"<<
        pass<<"';";
        MysqlRecordset rs;
		rs = db.QuerySQL(ss.str().c_str());
		if (rs.GetRows() < 1)
			return kErrCode001;
    } catch (Exception &e) {
        LOG_INFO<<e.what();
        db.Rollback();
        return kErrCode002;
    }
    
    return kErrCode000;
}
int DataService::UserLogout(const std::string& user, double& interest) {
    return kErrCode000;
}



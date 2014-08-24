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
#include "Endian.h"

#include <sstream>

using namespace etim;
using namespace etim::pub;
using namespace std;


/**
 @return kErrCode000 成功 kErrCode003 用户已经存在
 */
int DataService::UserRegister(const std::string &username, const std::string &pass) {
    MysqlDB db;
    
    try {
        db.Open();
        stringstream ss;
        ///查询是否用户名已存在
        ss<<"select username from user where username = '"<<username<<"';";
        MysqlRecordset rs;
		rs = db.QuerySQL(ss.str().c_str());
		if (rs.GetRows() >= 1)
			return kErrCode003;
        
        ss.clear();
		ss.str("");
        
        //不存在则插入进行注册  insert into user(user_id, username, password, reg_time, last_time, gender, status)
        //values(null, 'admin', 'admin', now(), now(), 0, 3);
        ss<<"insert into user (user_id, username, password, reg_time, last_time, gender, status_id) values(null, '"<<
        username<<"', '"<<
        pass<<"', "<<
        " now(), "<<
        " now(), "<<
        0<<","<<
        kBuddyOffline<<");";
        
        unsigned long long ret = db.ExecSQL(ss.str().c_str());
        (void)ret;
    } catch (Exception &e) {
        LOG_INFO<<e.what();
    }
    
    return kErrCode000;
}

/**
 @return kErrCode000 成功 kErrCode001 用户或密码出错
 */
int DataService::UserLogin(const std::string& username, const std::string& pass, IMUser &user) {
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        ss<<"select a.user_id, a.username, a.reg_time, a.signature, a.gender, b.status_name from `user` as a, `status` as b " <<
        "where a.status_id = b.status_id and a.username='"<<
        username<<"' and a.password='"<<
        pass<<"';";
        MysqlRecordset rs;
		rs = db.QuerySQL(ss.str().c_str());
		if (rs.GetRows() < 1)
			return kErrCode001;
        
        user.userId = rs.GetItem(0, "a.user_id");
        string reg = rs.GetItem(0, "a.reg_time");
		user.regDate = reg.substr(0, reg.find(" "));
        
        user.signature = rs.GetItem(0, "a.signature");
        user.gender = Convert::StringToInt(rs.GetItem(0, "a.gender"));
        user.status =  rs.GetItem(0, "b.status_name");
        user.relation = kBuddyRelationSelf;
        
    } catch (Exception &e) {
        LOG_INFO<<e.what();
    }
    
    return kErrCode000;
}

/**
 @return
 */
int DataService::UserLogout(const std::string& username, Session *s) {
    return kErrCode000;
}


/**
 @param user 如果查询到了则通过user返回
 @return kErrCode000 成功 kErrCode004 无此用户
 */
int DataService::UserSearch(const std::string &username, Session *s, IMUser &user) {
    IMUser sessionUser = s->GetIMUser();
    if (s->GetIMUser().username == username) {
        user = s->GetIMUser();
        return kErrCode000;
    } else {
        LOG_INFO<<"查询的非当前用户";
        MysqlDB db;
        try {
            db.Open();
            stringstream ss;
            ss<<"select a.user_id, a.username, a.reg_time, a.signature, a.gender, b.status_name from `user` as a, `status` as b " <<
            "where a.status_id = b.status_id and a.username='"<<
            username<<"';";
            MysqlRecordset rs;
            rs = db.QuerySQL(ss.str().c_str());
            if (rs.GetRows() < 1)
                return kErrCode004;
            
            user.userId = rs.GetItem(0, "a.user_id");
            string reg = rs.GetItem(0, "a.reg_time");
            user.regDate = reg.substr(0, reg.find(" "));
            
            user.signature = rs.GetItem(0, "a.signature");
            user.gender = Convert::StringToInt(rs.GetItem(0, "a.gender"));
            user.status =  rs.GetItem(0, "b.status_name");
            
            ss.clear();
            ss.str("");
            ss<<"select a.username, b.friend_id from `user` as a, `friend` as b  where a.username='" <<
            username<<"' and a.user_id = b.friend_from;";
            
            rs = db.QuerySQL(ss.str().c_str());
            if (rs.GetRows() < 1)
                user.relation = kBuddyRelationStranger;
            else
                user.relation = kBuddyRelationFriend;
            
        } catch (Exception &e) {
            LOG_INFO<<e.what();
            return kErrCode002;
        }
    }
    return kErrCode000;
}



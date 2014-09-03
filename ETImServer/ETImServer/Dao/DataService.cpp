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
#include <list>

using namespace etim;
using namespace etim::pub;
using namespace std;


/**
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode003 用户已经存在
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
        return kErrCode002;
    }
    
    return kErrCode000;
}

/**
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode001 用户或密码出错
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
        
        ss.clear();
        ss.str("");
        ss<<"update user set status_id = "<<kBuddyOnline<<" where username = '"<<username<<"';";
        unsigned long long ret = db.ExecSQL(ss.str().c_str());
        (void)ret;
        
        ss.clear();
        ss.str("");
        ss<<"select a.user_id, a.username, a.reg_time, a.signature, a.gender, a.status_id, b.status_name from `user` as a, `status` as b " <<
        "where a.status_id = b.status_id and a.username='"<<
        username<<"' and a.password='"<<
        pass<<"';";
		rs = db.QuerySQL(ss.str().c_str());
        
        string userId = rs.GetItem(0, "a.user_id");
        user.userId = atoi(userId.c_str());
        string reg = rs.GetItem(0, "a.reg_time");
		user.regDate = reg.substr(0, reg.find(" "));
        
        user.signature = rs.GetItem(0, "a.signature");
        user.gender = Convert::StringToInt(rs.GetItem(0, "a.gender"));
        user.status =  static_cast<BuddyStatus>(atoi(rs.GetItem(0, "a.status_id").c_str()));
        user.statusName = rs.GetItem(0, "b.status_name");
        user.relation = kBuddyRelationSelf;
        
    } catch (Exception &e) {
        LOG_INFO<<e.what();
        return kErrCode002;
    }
    
    return kErrCode000;
}

/**
 客户端主动退出, 后面客户端会断开SOCKET, 服务器会删除对应的SESSION
 @return kErrCode000 成功 kErrCode002 数据库错误
 */
int DataService::UserLogout(const std::string& userId, Session *s) {
    ///更新状态为离线
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        ss<<"update user set status_id ="<<kBuddyOffline<<" where user_id = '"<<userId<<"';";
        MysqlRecordset rs;
        unsigned long long ret = db.ExecSQL(ss.str().c_str());
        (void)ret;
    } catch (Exception &e) {
        LOG_INFO<<e.what();
        return kErrCode002;
    }
    return kErrCode000;
}


/**
 @param user 如果查询到了则通过user返回
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode004 无此用户
 */
int DataService::UserSearch(const std::string &username, Session *s, IMUser &user) {
    /*
     select u.*,
     (select
     case COUNT(1)
     when 0 then '0'
     else '1'
     end
     from friend f
     where f.friend_from=1 and f.friend_to=4
     limit 1
     )  'is_friend'
     from user u
     where u.username = 'admin'
     */
    //TODO sql待改进
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
            ss<<"select a.user_id, a.username, a.reg_time, a.signature, a.gender, a.status_id, b.status_name from `user` as a, `status` as b " <<
            "where a.status_id = b.status_id and a.username='"<<
            username<<"';";
            MysqlRecordset rs;
            rs = db.QuerySQL(ss.str().c_str());
            if (rs.GetRows() < 1)
                return kErrCode004;
            string userId = rs.GetItem(0, "a.user_id");
            user.userId = atoi(userId.c_str());
            string reg = rs.GetItem(0, "a.reg_time");
            user.regDate = reg.substr(0, reg.find(" "));
            
            user.signature = rs.GetItem(0, "a.signature");
            user.gender = Convert::StringToInt(rs.GetItem(0, "a.gender"));
            user.status =  static_cast<BuddyStatus>(atoi(rs.GetItem(0, "a.status_id").c_str()));
            user.statusName =  rs.GetItem(0, "b.status_name");
            
            ss.clear();
            ss.str("");
            //查询是否已为好友
            ss<<"select a.username, b.friend_id from `user` as a, `friend` as b  where a.username='" <<
            username<<"' and a.user_id = b.friend_from and b.req_status=" <<kBuddyRequestAccepted<<";";
            
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

/**
 添加好友请求
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode004 无此用户
 kErrCode005 已是好友
 */
int DataService::RequestAddBuddy(const std::string &from, const std::string to) {
        MysqlDB db;
        try {
            db.Open();
            stringstream ss;
            ss<<"select user_id, username from `user` where username ='" <<
            from<<"' or username ='"<<
            to<<"';";
            MysqlRecordset rs;
            rs = db.QuerySQL(ss.str().c_str());
            if (rs.GetRows() != 2)
                return kErrCode004;
            
            std::string fromId = rs.GetItem(0, "user_id");
            std::string toId = rs.GetItem(1, "user_id");
            
            ss.clear();
            ss.str("");
            ss<<"select friend_id from friend where friend_from ='" <<
            fromId<<"' and friend_to = '"<<
            toId<<"' and req_status = " << kBuddyRequestAccepted <<";";
            
            rs = db.QuerySQL(ss.str().c_str());
            if (rs.GetRows())
                return kErrCode005;
            
            ss.clear();
            ss.str("");
            ss<<"insert into friend (friend_id, friend_from, friend_to, request_time, action_time, req_status) values (null, '"<<
            fromId<<"', '"<<
            toId<<"', "<<
            " now(), "<<
            " now(), "<<
            kBuddyRequestNoSent<<");";
            
            unsigned long long ret = db.ExecSQL(ss.str().c_str());
            (void)ret;
        } catch (Exception &e) {
            LOG_INFO<<e.what();
            return kErrCode002;
        }
    return kErrCode000;
}

/**
 获取好友列表
 @param result 如果查询到了则通过result返回
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode006 无好友数据
 */
int DataService::RetrieveBuddyList(const std::string &userId, std::list<IMUser> &result) {
    /*
     select DISTINCT u_t.*, st.status_name
     from user u, friend f, user u_t
	 left join status st
     on st.status_id = u_t.status_id
     where u_t.user_id = f.friend_to
     and u.user_id = f.friend_from
     and u.username = 'admin'
     ;

     */
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        ss<<"select DISTINCT u_t.*, st.*"<<
        " from user u, friend f, user u_t"<<
        " left join status st "<<
        "on st.status_id = u_t.status_id"<<
        " where u_t.user_id = f.friend_to"<<
        " and u.user_id = f.friend_from"<<
        " and req_status = "<<kBuddyRequestAccepted<<
        " and u.user_id = "<<userId<<
        ";";
        MysqlRecordset rs;
        rs = db.QuerySQL(ss.str().c_str());
        if (rs.GetRows() < 1) {
            return kErrCode006;
        }
        for (int i = 0; i < rs.GetRows(); ++i) {
            IMUser user;
            user.userId = atoi(rs.GetItem(0, "u_t.user_id").c_str());
            user.username = rs.GetItem(i, "u_t.username");
            string reg = rs.GetItem(i, "u_t.reg_time");
            user.regDate = reg.substr(i, reg.find(" "));
            
            user.signature = rs.GetItem(i, "u_t.signature");
            user.gender = Convert::StringToInt(rs.GetItem(i, "u_t.gender"));
            user.status = static_cast<BuddyStatus>(atoi(rs.GetItem(i, "st.status_id").c_str()));
            user.statusName =  rs.GetItem(i, "st.status_name");
            result.push_back(user);
        }
    } catch (Exception &e) {
        LOG_INFO<<e.what();
        return kErrCode002;
    }

    return kErrCode000;
}

/**
 获取未读消息
 @param result 如果查询到了则通过result返回
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode006 无未读数据
 */

int DataService::RetrieveUnreadMsg(const std::string &userId, std::list<IMMsg> &result) {
    /*
     select m.*, u_f.*, s.status_name, f.req_status from message m
     left join user u_t
     on u_t.user_id = m.msg_to
     left join user u_f
     on u_f.user_id = m.msg_from
     left join status s
     on u_f.status_id = s.status_id
     left join friend f
     on f.friend_from = 1 and f.friend_to = u_f.user_id
     where u_t.user_id = 1 and m.sent = 0;

     */
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        ss<<"select m.*, u_f.*, s.status_name, f.req_status from message m"<<
        " left join user u_t"<<
        " on u_t.user_id = m.msg_to"<<
        " left join user u_f "<<
        " on u_f.user_id = m.msg_from"<<
        " left join status s"<<
        " on u_f.status_id = s.status_id"<<
        " left join friend f"<<
        " on f.friend_from = " <<userId<< " and f.friend_to = u_f.user_id"<<
        " where u_t.user_id = "<<userId<<
        " and m.sent = "<<kMsgUnsent<<";";
        MysqlRecordset rs;
        rs = db.QuerySQL(ss.str().c_str());
        if (rs.GetRows() < 1) {
            return kErrCode006;
        }
        for (int i = 0; i < rs.GetRows(); ++i) {
            IMUser fromUser;
            fromUser.userId = Convert::StringToInt(rs.GetItem(i, "u_f.user_id"));
            fromUser.username = rs.GetItem(i, "u_f.username");
            string reg = rs.GetItem(i, "u_f.reg_time");
            fromUser.regDate = reg.substr(i, reg.find(" "));
            
            fromUser.signature = rs.GetItem(i, "u_f.signature");
            fromUser.gender = Convert::StringToInt(rs.GetItem(i, "u_f.gender"));
            fromUser.relation = static_cast<BuddyRelation>(Convert::StringToInt(rs.GetItem(i, "f.req_status")));
            fromUser.status =  static_cast<BuddyStatus>(Convert::StringToInt(rs.GetItem(i, "u_f.status_id")));
            fromUser.statusName = rs.GetItem(i, "s.status_name");

            IMMsg msg;
            msg.msgId = Convert::StringToInt(rs.GetItem(i, "m.msg_id"));
            msg.from = fromUser;
            msg.text = rs.GetItem(i, "m.message");
            msg.sent = static_cast<int8>(Convert::StringToInt(rs.GetItem(i, "m.sent")));
            msg.requestTime = rs.GetItem(i, "m.request_time");
            msg.sendTime = rs.GetItem(i, "m.send_time");
            
            result.push_back(msg);
        }
    } catch (Exception &e) {
        LOG_INFO<<e.what();
        return kErrCode002;
    }
    
    return kErrCode000;
}

/**
 获取未处理好友请求(如果有多个请求,但有一个已经处理过:请求或拒绝,则认为无请求)
 @param result 如果查询到了则通过result返回
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode006 无未读数据
 */
int DataService::RetrieveBuddyRequest(const std::string &userId, std::list<IMUser> &result) {
    return kErrCode000;
}

#pragma mark -
#pragma mark private

int UpdateStatus(const std::string &username, BuddyStatus status) {
    return 0;
}
int SearchUserStatus(const std::string &username) {
    return 0;
}
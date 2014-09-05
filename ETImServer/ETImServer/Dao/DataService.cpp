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
        ss<<"select username from user"<<
        "where username = '"<<username<<"';";
        MysqlRecordset rs;
		rs = db.QuerySQL(ss.str().c_str());
		if (rs.GetRows() >= 1)
			return kErrCode003;
        
        ss.clear();
		ss.str("");
        
        //不存在则插入进行注册  insert into user(user_id, username, password, reg_time, last_time, gender, status)
        //values(null, 'admin', 'admin', now(), now(), 0, 3);
        ss<<"insert into user (user_id, username, password, reg_time, last_time, gender, status_id) values (null, '"<<
        username<<"', '"<<
        pass<<"', "<<
        " now(), "<<
        " now(), "<<
        0<<","<<
        kBuddyOffline<<");";
        
        unsigned long long ret = db.ExecSQL(ss.str().c_str());
        (void)ret;
    } catch (Exception &e) {
        LOG_ERROR<<e.what();
        return kErrCode002;
    }
    
    return kErrCode000;
}

/**
 @return kErrCode000 成功 kErrCode001 用户或密码出错 kErrCode002数据库错误
 */
int DataService::UserLogin(const std::string& username, const std::string& pass, IMUser &user) {
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        
        ///查询用户密码是否正确
        ss<<"select a.*, b.status_name from `user` as a, `status` as b" <<
        " where a.status_id = b.status_id"<<
        " and a.username = '"<<
        username<<"' and a.password = '"<<
        pass<<"';";
        MysqlRecordset rs;
		rs = db.QuerySQL(ss.str().c_str());
		if (rs.GetRows() < 1)
			return kErrCode001;
        
        ss.clear();
        ss.str("");
        //更新在线
        ss<<"update user set status_id = "<<kBuddyOnline<<" where username = '"<<username<<"';";
        unsigned long long ret = db.ExecSQL(ss.str().c_str());
        (void)ret;
        
        string reg = rs.GetItem(0, "a.reg_time");
        user.userId = Convert::StringToInt(rs.GetItem(0, "a.user_id"));
		user.regDate = reg.substr(0, reg.find(" "));
        user.signature = rs.GetItem(0, "a.signature");
        user.gender = Convert::StringToInt(rs.GetItem(0, "a.gender"));
        user.status = static_cast<BuddyStatus>(Convert::StringToInt(rs.GetItem(0, "a.status_id").c_str()));
        user.statusName = rs.GetItem(0, "b.status_name");
        user.relation = kBuddyRelationSelf;
        
    } catch (Exception &e) {
        LOG_ERROR<<e.what();
        return kErrCode002;
    }
    
    return kErrCode000;
}

/**
 客户端主动退出, 后面客户端会断开SOCKET, 服务器会删除对应的SESSION
 @return kErrCode000 成功 kErrCode002 数据库错误
 */
int DataService::UserLogout(const std::string& userId, Session *s) {
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        //更新状态为离线
        ss<<"update user set status_id ="<<kBuddyOffline<<" where user_id = '"<<userId<<"';";
        MysqlRecordset rs;
        unsigned long long ret = db.ExecSQL(ss.str().c_str());
        (void)ret;
    } catch (Exception &e) {
        LOG_ERROR<<e.what();
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
     admin (1) 到 admin2(2) 不是好友
     admin (1)到 admin3(3) 是好友
     select  u.*, s.status_name,
     (select
     case COUNT(1)
     when 0 then '0'
     else '1'
     end
     from friend f
     left join request r
     on f.req_id = r.req_id
     where f.friend_from=1 and f.friend_to=u.user_id and r.req_status = 4
     limit 1
     )  'is_friend'
     from user u
     left join status s
     on u.status_id = s.status_id
     where u.username = 'admin3'
     */
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
            //查询当前用户的资料并且将是否好友返回
            ss<<"select u.*, s.status_name,"<<
            " (select"<<
            "  case COUNT(1)"<<
            " when 0 then '0'"<<
            " else '1'"<<
            " end"<<
            " from friend f"<<
            " left join request r"<<
            " on f.req_id = r.req_id"<<
            " where f.friend_from = "<<sessionUser.userId<<
            " and f.friend_to = u.user_id"<<
            " and r.req_status in ("<<(kBuddyRequestAccepted|kBuddyRequestNoSent)<<", "<<(kBuddyRequestAccepted|kBuddyRequestSent)<<")"<<
            " limit 1"<<
            " ) 'is_friend'"<<
            " from user u"<<
            " left join status s"<<
            " on u.status_id = s.status_id"<<
            " where u.username = '"<<username<<"';";
            MysqlRecordset rs;
            rs = db.QuerySQL(ss.str().c_str());
            if (rs.GetRows() < 1)
                return kErrCode004;
            
            string reg = rs.GetItem(0, "u.reg_time");
            string userId = rs.GetItem(0, "u.user_id");
            user.userId = Convert::StringToInt(userId.c_str());
            user.regDate = reg.substr(0, reg.find(" "));
            user.signature = rs.GetItem(0, "u.signature");
            user.gender = Convert::StringToInt(rs.GetItem(0, "u.gender"));
            user.status =  static_cast<BuddyStatus>(Convert::StringToInt(rs.GetItem(0, "u.status_id").c_str()));
            user.statusName =  rs.GetItem(0, "s.status_name");
            
            int isFriend = Convert::StringToInt(rs.GetItem(0, "is_friend").c_str());
            user.relation = isFriend ? kBuddyRelationFriend : kBuddyRelationStranger;
            
        } catch (Exception &e) {
            LOG_ERROR<<e.what();
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
int DataService::RequestAddBuddy(const std::string &from, const std::string &to) {
        MysqlDB db;
        try {
            db.Open();
            stringstream ss;
            //是否两帐户都存在
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
            //查询是否为好友
            ss<<"select friend_id from friend where friend_from ='" <<
            fromId<<"' and friend_to = '"<<
            toId<<"' and req_status = " << kBuddyRequestAccepted <<";";
            
            rs = db.QuerySQL(ss.str().c_str());
            if (rs.GetRows())
                return kErrCode005;
            
            ss.clear();
            ss.str("");
            //插入好友请求数据
            ss<<"insert into friend (friend_id, friend_from, friend_to, req_time, action_time, req_status) values (null, '"<<
            fromId<<"', '"<<
            toId<<"', "<<
            " now(), "<<
            " now(), "<<
            kBuddyRequestNoSent<<");";
            
            unsigned long long ret = db.ExecSQL(ss.str().c_str());
            (void)ret;
        } catch (Exception &e) {
            LOG_ERROR<<e.what();
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
     select u_t.*, st.status_name
     from (user u_f, friend f, user u_t)
     left join status st
     on st.status_id = u_t.status_id
     left join request r
     on r.req_id = f.req_id
     where u_f.user_id = f.friend_from
     and u_t.user_id = f.friend_to
     and u_f.user_id = 1
     and r.req_status in (4,5) order by u_t.user_id;

     */
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        ss<<"select u_t.*, st.status_name"<<
        " from (user u_f, friend f, user u_t)"<<
        " left join status st "<<
        " on st.status_id = u_t.status_id"<<
        " left join request r"<<
        " on r.req_id = f.req_id"<<
        " where u_f.user_id = f.friend_from"<<
        " and u_t.user_id = f.friend_to"<<
        " and u_f.user_id = "<<userId<<
        " and r.req_status in ("<<(kBuddyRequestAccepted|kBuddyRequestNoSent)<<", "<<(kBuddyRequestAccepted|kBuddyRequestSent)<<")"<<
        " order by u_t.user_id"
        ";";
        MysqlRecordset rs;
        rs = db.QuerySQL(ss.str().c_str());
        if (rs.GetRows() < 1) {
            return kErrCode006;
        }
        for (int i = 0; i < rs.GetRows(); ++i) {
            IMUser user;
            string reg = rs.GetItem(i, "u_t.reg_time");
            user.userId = Convert::StringToInt(rs.GetItem(0, "u_t.user_id").c_str());
            user.username = rs.GetItem(i, "u_t.username");
            user.regDate = reg.substr(i, reg.find(" "));
            user.signature = rs.GetItem(i, "u_t.signature");
            user.gender = Convert::StringToInt(rs.GetItem(i, "u_t.gender"));
            user.status = static_cast<BuddyStatus>(Convert::StringToInt(rs.GetItem(i, "u_t.status_id").c_str()));
            user.statusName =  rs.GetItem(i, "st.status_name");
            result.push_back(user);
        }
    } catch (Exception &e) {
        LOG_ERROR<<e.what();
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
            string reg = rs.GetItem(i, "u_f.reg_time");
            fromUser.userId = Convert::StringToInt(rs.GetItem(i, "u_f.user_id"));
            fromUser.username = rs.GetItem(i, "u_f.username");
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
            msg.requestTime = rs.GetItem(i, "m.req_time");
            msg.sendTime = rs.GetItem(i, "m.send_time");
            
            result.push_back(msg);
        }
    } catch (Exception &e) {
        LOG_ERROR<<e.what();
        return kErrCode002;
    }
    
    return kErrCode000;
}

/**
 获取未处理好友请求(如果有多个请求,但有一个已经处理过:请求或拒绝,则认为无请求)
 @param result 如果查询到了则通过result返回
 @return kErrCode000 成功 kErrCode002数据库错误 kErrCode006 无未读数据
 */
int DataService::RetrievePendingBuddyRequest(const std::string &userId, std::list<IMUser> &result) {
    /*
     select u_f.*, s.status_name
     from (user u_t, user u_f)
     left join friend f
     on f.friend_to = u_t.user_id
     left join request r
     on r.req_id = f.req_id
     left join status s
     on s.status_id = u_f.status_id
     where u_t.user_id = 2(发给谁的)
     and r.req_status = 0(未发送的)
     and u_f.user_id = f.friend_from
     */
    
    
    
    MysqlDB db;
    try {
        db.Open();
        stringstream ss;
        ss<<"select u_f.*, s.status_name"<<
        " from (user u_t, user u_f)"<<
        " left join friend f"<<
        " on f.friend_to = u_t.user_id"<<
        " left join request r"<<
        " on r.req_id = f.req_id"<<
        " left join status s"<<
        " on s.status_id = u_f.status_id"<<
        " where u_t.user_id = "<<userId<<
        " and r.req_status = "<<kBuddyRequestNoSent<<
        " and u_f.user_id = f.friend_from;";
        MysqlRecordset rs;
        rs = db.QuerySQL(ss.str().c_str());
        if (rs.GetRows() < 1) {
            return kErrCode006;
        }
        for (int i = 0; i < rs.GetRows(); ++i) {
            IMUser user;
            string reg = rs.GetItem(i, "u_f.reg_time");
            user.userId = Convert::StringToInt(rs.GetItem(0, "u_f.user_id").c_str());
            user.username = rs.GetItem(i, "u_f.username");
            user.regDate = reg.substr(i, reg.find(" "));
            user.signature = rs.GetItem(i, "u_f.signature");
            user.gender = Convert::StringToInt(rs.GetItem(i, "u_f.gender"));
            user.status = static_cast<BuddyStatus>(Convert::StringToInt(rs.GetItem(i, "u_f.status_id").c_str()));
            user.statusName =  rs.GetItem(i, "s.status_name");
            result.push_back(user);
        }
    } catch (Exception &e) {
        LOG_ERROR<<e.what();
        return kErrCode002;
    }
    
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
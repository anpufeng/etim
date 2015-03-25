//
//  Session.h
//  ETImServer
//
//  Created by Ethan on 14/7/29.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Session__
#define __ETImServer__Session__

#include <iostream>
#include <memory>
#include "Socket.h"
#include "DataStruct.h"

namespace etim {

#define CMD_REGISTER                            0x0001      //注册
#define CMD_LOGIN                               0x0002      //登录
#define CMD_LOGOUT                              0x0003      //登出
#define CMD_HEART_BEAT                          0x0004      //心跳
#define CMD_SEND_MSG                            0x0005      //发消息
#define CMD_REQUEST_ADD_BUDDY                   0x0006      //请求添加好友
#define CMD_SWITCH_STATUS                       0x0007      //切换登录状态
#define CMD_RETRIEVE_BUDDY_LIST                 0x0008      //获取好友列表
#define CMD_SEARCH_BUDDY                        0x0009      //查询某个用户信息
#define CMD_RETRIEVE_UNREAD_MSG                 0x000A      //获取未读消息
#define CMD_RETRIEVE_PENDING_BUDDY_REQUEST      0x000B      //获取未处理好友请求
#define CMD_UNREAD                              0X000C      //获取未读事件, 暂只包括三子命令
                                                            //CMD_RETRIEVE_BUDDY_LIST,
                                                            //CMD_RETRIEVE_UNREAD_MSG
                                                            //CMD_RETRIEVE_PENDING_BUDDY_REQUEST)
#define CMD_RETRIEVE_ALL_BUDDY_REQUEST          0X000D      ///获取好友请求历史(包括同意和拒绝)
#define CMD_ACCEPT_ADD_BUDDY                    0X000E      ///同意添加好友
#define CMD_REJECT_ADD_BUDDY                    0X000F      ///拒绝添加好友
    
    
#define PUSH_BUDDY_UPDATE                       0X0100      //往客户推端送好友上线下线等状态变化
#define PUSH_BUDDY_MSG                          0X0101      //往客户推端送好友消息
#define PUSH_BUDDY_REQUEST_RESULT               0X0102      //往客户端推送好友请求结果
#define PUSH_REQUEST_ADD_BUDDY                  0X0103      //往客户端推送好友请求
#define PUSH_SEND_MSG                           0X0104      //往客户端推送消息
    
#define ERR_MSG_LENGTH      30              // 错误消息定长
#define HEART_BEAT_SECONDS  30              //心中包发送间隔时间(S)
    
    ///请求头
    struct RequestHead
    {
        unsigned short cmd;
        unsigned short len;
    };
    
    ///响应头
    struct ResponseHead
    {
        unsigned short cmd;
        unsigned short len;
        unsigned short cnt;
        unsigned short seq;
        unsigned short error_code;
        char error_msg[30];
    };
    
    ///请求包体
    struct RequestPack
    {
        RequestHead head;
        char buf[1];
    };
    
    ///响应包体
    struct ResponsePack
    {
        ResponseHead head;
        char buf[1];
    };
    
    ///包中带的错误码
    enum ErrCode {
        kErrCode00, //00 success, 其它均为异常
        kErrCode01,
        kErrCode02,
        kErrCode03,
        kErrCode04,
        kErrCode05,
        kErrCode06,
        kErrCode07,
        kErrCode08,
        kErrCode09,
        kErrCode10,
        kErrCode11,
        kErrCodeMax
    };
    
    ///错误信息  不可超过30字符 15汉字 不然会signal abort
    static const std::string gErrMsg[kErrCodeMax+1] = {"正常", "用户或密码错误", "数据库错误", /*kErrCode03*/"用户已经存在",
        "无此用户", "已是好友", "没有数据", /*kErrCode07*/"已是对方好友",
        "kErrCode08", "kErrCode09", "kErrCode10", /*kErrCode11*/"kErrCode11",
        /*kErrCodeMax*/"kErrCodeMax"};
    
   

///每个会话
    class Session {
    public:
        Session(std::auto_ptr<Socket> &socket);
        ~Session();
        //lhs rhs
    
    public:
        int GetFd() const { return socket_->GetFd(); }
        uint16_t GetCmd() const { return requestPack_->head.cmd; }
        RequestPack *GetRequestPack() const { return requestPack_; }
        void Send(const char* buf, size_t len);
        void Recv(int *result);
        void DoAction();
        
        
        ///获取用户信息
        const IMUser GetIMUser() const { return user_; }
        ///设置用户信息
        void SetIMUser(IMUser &user) {user_ = user; }
        
        ///获取上次操作时间
        const timeval GetLastTime() const { return lastTime_; }
        void SetLastTime(timeval &last) { lastTime_ = last; }
        bool operator==(const Session &rhs) const { return user_.userId == rhs.GetIMUser().userId; };
        
    private:
        std::auto_ptr<Socket> socket_;
        uint16_t cmd_;
        char buffer_[2048];
        RequestPack* requestPack_;
        IMUser      user_;
        timeval     lastTime_;
    };
    
    ///用于遍历session
    class SessionFinder {
    public:
        SessionFinder(int userId) : userId_(userId) { }
    public:
        bool operator() (Session *s) {
            return userId_ == s->GetIMUser().userId;
        }
        
    private:
        int userId_;
    };
}   //end etim

#endif /* defined(__ETImServer__Session__) */

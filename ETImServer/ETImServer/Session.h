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
#define CMD_RETRIEVE_BUDDY                       0x0008      //获取好友列表
#define CMD_SEARCH_BUDDY                        0x0009      //查询某个用户信息
#define CMD_RETRIEVE_UNREAD_MSG                  0x000A      //获取未读消息
#define CMD_RETRIEVE_BUDDY_EVENT                0x000B      //获取未处理好友请求
    
#define ERR_MSG_LENGTH      30              // 错误消息定长
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
    
    ///请求包休
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
        kErrCode000, //000 success, 其它均为异常
        kErrCode001,
        kErrCode002,
        kErrCode003,
        kErrCode004,
        kErrCode005,
        kErrCode006,
        kErrCode007,
        kErrCode008,
        kErrCode009,
        kErrCode010,
        kErrCode011,
        kErrCodeMax
    };
    
    ///错误信息
    static const std::string gErrMsg[kErrCodeMax+1] = {"正常", "用户或密码错误", "数据库错误", /*kErrCode003*/"用户已经存在",
        "无此用户", "已是好友", "kErrCode006", /*kErrCode007*/"kErrCode007",
        "kErrCode008", "kErrCode009", "kErrCode010", /*kErrCode011*/"kErrCode011",
        /*kErrCodeMax*/"kErrCodeMax"};
    
    ///在线状态
    enum BuddyStatus {
        kBuddyOnline = 1,
        kBuddyInvisible,
        kBuddyAway,
        kBuddyOffline
    };

///每个会话
    class Session {
    public:
        Session(std::auto_ptr<Socket> &socket);
        ~Session();

    
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
        
    private:
        std::auto_ptr<Socket> socket_;
        uint16_t cmd_;
        char buffer_[2048];
        RequestPack* requestPack_;
        IMUser      user_;
    };
}   //end etim

#endif /* defined(__ETImServer__Session__) */

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

namespace etim {

#define CMD_REGISTER                            0x0001      //注册
#define CMD_LOGIN                               0x0002      //登录
#define CMD_LOGOUT                              0x0003      //登出
#define CMD_HEART_BEAT                          0x0004      //心跳
#define CMD_SEND_MSG                            0x0005      //发消息
#define CMD_ADD_BUDDY                           0x0006      //添加好友
#define CMD_SWITCH_STATUS                       0x0007      //切换登录状态
#define CMD_RETRIVE_BUDDY                       0x0008      //获取好友列表
    
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
    static const std::string gErrMsg[kErrCodeMax] = {"正常", "服务器错误", "数据库错误"};
    
    ///在线状态
    enum BuddyStatus {
        kBuddyOnline,
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
        void Recv();
        void DoAction();
        
    private:
        std::auto_ptr<Socket> socket_;
        uint16_t cmd_;
        char buffer_[2048];
        RequestPack* requestPack_;
        
    };
}   //end etim

#endif /* defined(__ETImServer__Session__) */

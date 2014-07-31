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
    
    

///每个会话
    class Session {
    public:
        Session(std::auto_ptr<Socket> &socket);
        ~Session() {}

    
    public:
        int GetFd() const { return socket_->GetFd(); }
    public:
        std::auto_ptr<Socket> socket_;
        uint16_t cmd_;
        
    };
}   //end etim

#endif /* defined(__ETImServer__Session__) */

//
//  Session.h
//  ETImClient
//
//  Created by Ethan on 14/8/4.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImClient__Session__
#define __ETImClient__Session__

#include <iostream>
#include <string>
#include <list>
#include <map>
#include "Socket.h"
#include "Endian.h"
#include "DataStruct.h"

namespace etim {
    
#define CMD_RETRIEVE_EVENT                      0X0000      //获取通知
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
#define CMD_RETRIEVE_BUDDY_REQUEST              0x000B      //获取未处理好友请求
#define CMD_UNREAD                              0X000C      //获取未读事件, 暂只包括三子命令
                                                            //CMD_RETRIEVE_BUDDY_LIST,
                                                            //CMD_RETRIEVE_UNREAD_MSG
                                                            //CMD_RETRIEVE_BUDDY_REQUEST)
    
    static const std::string gCmdNoti[CMD_RETRIEVE_BUDDY_REQUEST+1] =
    {"CMD_RETRIEVE_EVENT", "CMD_REGISTER", "CMD_LOGIN",
        "CMD_LOGOUT", "CMD_HEART_BEAT", "CMD_SEND_MSG",
        "CMD_REQUEST_ADD_BUDDY", "CMD_SWITCH_STATUS", "CMD_RETRIEVE_BUDDY_LIST"};
    
#define ERR_MSG_LENGTH      30              // 错误消息定长
    ///请求头
    struct RequestHead
    {
        unsigned short cmd;
        ///包体长度
        unsigned short len;
    };
    
    ///响应头
    struct ResponseHead
    {
        unsigned short cmd;
        ///包体长度
        unsigned short len;
        ///分片
        unsigned short cnt;
        ///序列
        unsigned short seq;
        ///错误码，0正确
        unsigned short error_code;
        ///错误消息 定长30
        char error_msg[ERR_MSG_LENGTH];
    };
    
    ///请求包休
    struct RequestPack
    {
        RequestHead head;
        ///标记位置
        char buf[1];
    };
    
    ///响应包体
    struct ResponsePack
    {
        ResponseHead head;
        ///标记位置
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
        "无此用户", "已是好友", "没有数据", /*kErrCode007*/"kErrCode007",
        "kErrCode008", "kErrCode009", "kErrCode010", /*kErrCode011*/"kErrCode011",
        /*kErrCodeMax*/"kErrCodeMax"};
    
    ///在线状态
    enum BuddyStatus {
        kBuddyOnline = 1,
        kBuddyInvisible,
        kBuddyAway,
        kBuddyOffline
    };
    
    ///会话数据
    class Session {
    public:
        Session(std::auto_ptr<Socket> &socket);
        ~Session();
        
        ///设置发送操作命令
        void SetSendCmd(uint16_t cmd) { cmd_ = cmd; }
        ///获取发送操作命令
        uint16_t GetSendCmd() const { return cmd_; }
        ///获取接收操作命令
        uint16_t GetRecvCmd() const { return responsePack_->head.cmd; }
        
        ///将返回值加入
        void SetResponse(const std::string& k, const std::string& v);
        ///获取返回值
        const std::string& GetResponse(const std::string& k);
        
        ///将要请求的参加加入
        void SetAttribute(const std::string& k, const std::string& v);
        ///获取某个请求参数值
        const std::string& GetAttribute(const std::string& k);
        ///获取响应包
        ResponsePack* GetResponsePack() const { return responsePack_; }
        
        ///还原状态
        void Clear();
        ///发送打包数据
        void Send(const char* buf, size_t len);
        ///获取打包数据
        void Recv();
        void DoAction();
        
        ///获取用户信息
        const IMUser GetIMUser() const { return user_; }
        ///设置用户信息
        void SetIMUser(IMUser &user);
        
        ///获取搜索用户信息
        const IMUser GetSearchIMUser() const { return searchUser_; }
        ///设置搜索用户信息
        void SetSearchIMUser(IMUser &user) {searchUser_ = user; }
        
        uint16_t GetFd() const { return socket_->GetFd(); }
        bool IsConnected() const { return isConnected_; }
        
        void SetErrorCode(int16 errorCode) { errCode_ = errorCode; }
        void SetErrorMsg(const std::string& errorMsg) { errMsg_ = errorMsg; }
        
        int16 const GetErrorCode() const { return errCode_; }
        const std::string GetErrorMsg() const { return errMsg_;}
        bool const IsError() const { return errCode_ != kErrCode000; }
        
        ///好友
        const std::list<IMUser> GetBuddys() const { return buddys_; }
        void AddBuddy(IMUser &user) { buddys_.push_back(user); }
        void ClearBuddys() { buddys_.clear(); }
        
        
    private:
        std::auto_ptr<Socket> socket_;
        bool isConnected_;
        ///存储缓存数据
        char buffer_[2048];
        ResponsePack *responsePack_;
        
        
        uint16_t cmd_;
        std::map<std::string, std::string> request_;
        std::map<std::string, std::string> response_;
        int16_t errCode_;
        std::string errMsg_;
        
        BuddyStatus status_;
        IMUser      user_;
        IMUser      searchUser_;
        ///好友列表
        std::list<IMUser> buddys_;
        
    };
}   //end etim

#endif /* defined(__ETImClient__Session__) */

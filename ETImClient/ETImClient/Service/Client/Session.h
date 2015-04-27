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
#define CMD_RETRIEVE_PENDING_BUDDY_REQUEST      0x000B      //获取未处理好友请求
#define CMD_UNREAD                              0X000C      //获取未读事件, 暂只包括三子命令
                                                            //CMD_RETRIEVE_BUDDY_LIST,
                                                            //CMD_RETRIEVE_UNREAD_MSG
                                                            //CMD_RETRIEVE_PENDING_BUDDY_REQUEST)
#define CMD_RETRIEVE_ALL_BUDDY_REQUEST          0X000D      ///获取好友请求历史(包括同意和拒绝)
#define CMD_ACCEPT_ADD_BUDDY                    0X000E      ///同意添加好友
#define CMD_REJECT_ADD_BUDDY                    0X000F      ///拒绝添加好友
    
    
#define PUSH_BUDDY_UPDATE                       0X0100      //服务器往客户推端送好友上线下线个人信息等变化
#define PUSH_BUDDY_MSG                          0X0101      //服务器往客户推端送好友消息
#define PUSH_BUDDY_REQUEST_RESULT               0X0102      //服务器往客户端推送好友请求结果
#define PUSH_REQUEST_ADD_BUDDY                  0X0103      //服务器往客户端推送好友请求
#define PUSH_SEND_MSG                           0X0104      //服务器往客户端推送消息
    
    static const std::string gCmdNoti[CMD_REJECT_ADD_BUDDY+1] = {
        "CMD_RETRIEVE_EVENT", "CMD_REGISTER", "CMD_LOGIN", /*0x0002*/
        "CMD_LOGOUT", "CMD_HEART_BEAT", "CMD_SEND_MSG",     /*0x0005*/
        "CMD_REQUEST_ADD_BUDDY", "CMD_SWITCH_STATUS", "CMD_RETRIEVE_BUDDY_LIST", /*0x0008*/
        "CMD_SEARCH_BUDDY", "CMD_RETRIEVE_UNREAD_MSG", "CMD_RETRIEVE_PENDING_BUDDY_REQUEST",  /*0x000B*/
        "CMD_UNREAD", "CMD_RETRIEVE_ALL_BUDDY_REQUEST", "CMD_ACCEPT_ADD_BUDDY", "CMD_REJECT_ADD_BUDDY" /*0X000F*/
    };
    
    static const std::string gPushNoti[PUSH_SEND_MSG-PUSH_BUDDY_UPDATE+1] = {
        "PUSH_BUDDY_UPDATE", "PUSH_BUDDY_MSG", "PUSH_BUDDY_REQUEST_RESULT", /*0X0102*/
        "PUSH_REQUEST_ADD_BUDDY", "PUSH_SEND_MSG"
    };
    
#define ERR_MSG_LENGTH      30              // 错误消息定长
#define HEART_BEAT_SECONDS  30              //心中包发送间隔时间(S)
    
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
        kErrCode00, //000 success, 其它均为异常
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
    
    ///错误信息
    static const std::string gErrMsg[kErrCodeMax+1] = {"正常", "用户或密码错误", "数据库错误", /*kErrCode03*/"用户已经存在",
        "无此用户", "已是好友", "没有数据", /*kErrCode07*/"kErrCode07",
        "kErrCode08", "kErrCode09", "kErrCode10", /*kErrCode11*/"kErrCode11",
        /*kErrCodeMax*/"kErrCodeMax"};
    
    
    typedef void (*connectCallBack)(bool);
    
    ///会话数据
    class Session {
    public:
        Session(std::auto_ptr<Socket> &socket, connectCallBack callBack, char *ip, unsigned short port);
        ~Session();
        
        ///设置发送操作命令
        void SetSendCmd(uint16_t cmd) { cmd_ = cmd; }
        ///获取发送操作命令
        uint16_t GetSendCmd() const { return cmd_; }
        ///获取接收操作命令
        uint16_t GetRecvCmd() const {
            return responsePack_->head.cmd;
        }
        
        ///将返回值加入
        void SetResponse(const std::string& k, const std::string& v);
        ///获取返回值
        const std::string& GetResponse(const std::string& k);
        
        ///获取响应包
        ResponsePack* GetResponsePack() const { return responsePack_; }
        void Close();
        bool Connect(char *ip, unsigned short port);
        bool Reconnect(char *ip, unsigned short port);
        ///还原状态
        void Clear();
        ///发送打包数据
        void Send(const char* buf, size_t len);
        ///获取打包数据
        void Recv();
        void DoAction();
        
        /*
        ///获取搜索用户信息
        const IMUser GetSearchIMUser() const { return searchUser_; }
        ///设置搜索用户信息
        void SetSearchIMUser(IMUser &user) {searchUser_ = user; }
        
        ///获取用户状态改变的好友信息
        const IMUser GetStatusChangedBuddy() const { return stausChangedBuddy_; }
        ///设置用户状态改变的好友信息
        void SetStatusChangedBuddy(IMUser &user) { stausChangedBuddy_ = user; }
        
        const IMMsg GetPushSendMsg() const { return pushSendMsg_; }
        void SetPushSendMsg(IMMsg &msg) { pushSendMsg_ = msg; }
         */
        
        uint16_t GetFd() const { return socket_->GetFd(); }
        bool IsConnected() const { return isConnected_; }
        
        void SetErrorCode(int16 errorCode) { errCode_ = errorCode; }
        void SetErrorMsg(const std::string& errorMsg) {
            errMsg_ = errorMsg;
        }
        
        int16 const GetErrorCode() const { return errCode_; }
        const std::string GetErrorMsg() const { return errMsg_;}
        bool const IsError() const { return errCode_ != kErrCode00 && errCode_ != kErrCode06; }
        
        ///好友
        /*
        const std::list<IMUser> GetBuddys() const { return buddys_; }
        void AddBuddy(IMUser &user) { buddys_.push_back(user); }
        void ClearBuddys() { buddys_.clear(); }
         
        ///请求好友
        const std::list<IMUser> GetReqBuddys() const { return reqBuddys_; }
        void AddReqBuddy(IMUser &user) { reqBuddys_.push_back(user); }
        void ClearReqBuddys() { reqBuddys_.clear(); }
        ///所有请求好友记录
        const std::list<IMReq> GetAllReqs() const { return allReqs_; }
        void AddReq(IMReq &req) { allReqs_.push_back(req); }
        void ClearAllReqs() { allReqs_.clear(); }

        
        ///消息
        const std::list<IMMsg> GetUnreadMsgs() const {return unreadMsgs_; }
        void AddUnreadMsg(IMMsg &msg) {unreadMsgs_.push_back(msg); }
        void ClearUnreadMsg() { unreadMsgs_.clear(); }
        */
    private:
        std::auto_ptr<Socket> socket_;
        connectCallBack callBack_;
        bool isConnected_;
        ///存储缓存数据
        char buffer_[2048];
        ResponsePack *responsePack_;
        
        
        uint16_t cmd_;

        std::map<std::string, std::string> response_;
        int16_t errCode_;
        std::string errMsg_;
        
        /*
        BuddyStatus status_;
        IMUser      searchUser_;
        IMUser      stausChangedBuddy_;
        ///接收来的消息
        IMMsg       pushSendMsg_;
        ///好友列表
        //std::list<IMUser> buddys_;
        ///请求用户列表
        std::list<IMUser> reqBuddys_;
        ///所有请求列表
        std::list<IMReq> allReqs_;
        ///未读消息
        std::list<IMMsg> unreadMsgs_;
        */
        
    
    };
}   //end etim

#endif /* defined(__ETImClient__Session__) */

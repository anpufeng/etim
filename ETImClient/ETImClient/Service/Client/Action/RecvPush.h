//
//  RecvPush.h
//  ETImClient
//
//  Created by Ethan on 14/9/10.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImClient__RecvPush__
#define __ETImClient__RecvPush__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        

        ///接收服务器推送的用户状态更新
        class PushBuddyUpdate : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        ///接收服务器推送的好友请求结果
        class PushBuddyRequestResult : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        ///接收服务器推送的好友请求
        class PushRequestAddBuddy : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        ///客户端收到一条消息
        class PushSendMsg : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
    } //end action
} //end etim

#endif /* defined(__ETImClient__RecvPush__) */

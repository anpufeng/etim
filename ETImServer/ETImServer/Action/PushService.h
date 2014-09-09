//
//  PushService.h
//  ETImServer
//
//  Created by Ethan on 14/9/9.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__PushService__
#define __ETImServer__PushService__

#include <iostream>
#include "Action.h"
#include "DataService.h"

namespace etim {
    namespace action {
        
        ///用于服务端往客户端推送(仅针对在线用户)
        class PushService : public Action {
        public:
            virtual void Execute(Session *s);
            
            /**往客户端推送用户状态变化
             @param user 产生变化后的用户信息
             **/
            void PushBuddyUpdate(const etim::IMUser &user, etim::DataService &dao);
            
            /**
             *往客户端推送好友请求结果
             *@param user 本session的用户
             *@param from 源请求方userId
             *@param accept 是否接受
             *@param peer 是否添加对方为好友
             **/
            void PushBuddyRequestResult(const etim::IMUser &user, const int from, bool accept, bool peer, etim::DataService &dao);
        };
        
    } //end action
} //end etim

#endif /* defined(__ETImServer__PushService__) */
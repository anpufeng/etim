//
//  RetrieveBuddy.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__RetrieveBuddy__
#define __ETImServer__RetrieveBuddy__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        ///获取好友列表
        class RetrieveBuddyList : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        ///未处理的请求好友
        class RetrievePendingBuddyRequest : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        ///获取好友请求记录
        class RetrieveAllBuddyRequest : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
 
    } //end action
} //end etim
#endif /* defined(__ETImServer__RetrieveBuddy__) */

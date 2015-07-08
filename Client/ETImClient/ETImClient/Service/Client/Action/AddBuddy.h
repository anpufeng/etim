//
//  AddBuddy.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__AddBuddy__
#define __ETImServer__AddBuddy__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        ///添加好友
        class RequestAddBuddy : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        ///查找
        class SearchBuddy : public Action {
        public:
            virtual void DoSend(Session &s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        ///同意添加好友
        class AcceptAddBuddy : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        ///拒绝添加好友
        class RejectAddBuddy : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };

    } //end action
} //end etim

#endif /* defined(__ETImServer__AddBuddy__) */

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
        
        class RetrieveBuddyList : public Action {
        public:
            virtual void Execute(Session *s);
        };
        
        
        ///请求好友
        class RetrievePendingBuddyRequest : public Action {
        public:
            virtual void Execute(Session *s);
        };
        
        ///获取好友请求记录
        class RetrieveAllBuddyRequest : public Action {
        public:
            virtual void Execute(Session *s);
        };
        
    } //end action
} //end etim
#endif /* defined(__ETImServer__RetrieveBuddy__) */

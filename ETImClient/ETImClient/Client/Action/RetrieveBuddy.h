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
            virtual void DoSend(Session& s);
            virtual void DoRecv(Session &s);
        };
        
        ///请求好友
        class RetrieveBuddyRequest : public Action {
        public:
            virtual void DoSend(Session& s);
            virtual void DoRecv(Session &s);
        };
        
        
 
    } //end action
} //end etim
#endif /* defined(__ETImServer__RetrieveBuddy__) */

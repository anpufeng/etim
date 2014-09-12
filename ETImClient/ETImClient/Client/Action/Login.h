//
//  Login.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Login__
#define __ETImServer__Login__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        class Login : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        class Logout : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
        
 
    } //end action
} //end etim

#endif /* defined(__ETImServer__Login__) */

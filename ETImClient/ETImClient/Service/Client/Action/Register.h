//
//  Register.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Register__
#define __ETImServer__Register__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        class Register : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
    } //end action
} //end etim

#endif /* defined(__ETImServer__Register__) */

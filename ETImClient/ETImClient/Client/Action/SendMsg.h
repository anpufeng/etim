//
//  SendMsg.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__SendMsg__
#define __ETImServer__SendMsg__

#include <iostream>

#include "Action.h"

namespace etim {
    namespace action {
        
        class SendMsg : public Action {
        public:
            virtual void Execute(Session& s);
            virtual void Recv(Session &s);
        };
    } //end action
} //end etim

#endif /* defined(__ETImServer__SendMsg__) */

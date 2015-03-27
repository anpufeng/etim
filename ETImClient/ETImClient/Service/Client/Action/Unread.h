//
//  Unread.h
//  ETImClient
//
//  Created by Ethan on 14/9/1.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImClient__Unread__
#define __ETImClient__Unread__

#include <iostream>

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        class Unread : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
    } //end action
} //end etim


#endif /* defined(__ETImClient__Unread__) */

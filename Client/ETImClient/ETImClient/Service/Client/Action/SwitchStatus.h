//
//  SwitchStatus.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__SwitchStatus__
#define __ETImServer__SwitchStatus__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        class SwitchStatus : public Action {
        public:
            virtual void DoSend(Session& s, sendarg arg);
            virtual void DoRecv(Session &s);
        };
        
    } //end action
} //end etim


#endif /* defined(__ETImServer__SwitchStatus__) */

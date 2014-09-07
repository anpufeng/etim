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
#include "DataService.h"

namespace etim {
    namespace action {
        
        class SwitchStatus : public Action {
        public:
            virtual void Execute(Session *s);
            ///往客户端推送用户状态变化
            void PushBuddyUpdate(etim::IMUser &user, etim::DataService &dao);
        };
    } //end action
} //end etim


#endif /* defined(__ETImServer__SwitchStatus__) */

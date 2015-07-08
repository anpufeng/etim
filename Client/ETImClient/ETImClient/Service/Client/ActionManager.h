//
//  ActionManager.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__ActionManager__
#define __ETImServer__ActionManager__

#include <iostream>
#include <map>
#include <string>
#include "Action.h"
#include "Session.h"
#include "Singleton.h"


namespace etim {
    
    ///管理所有操作
    class ActionManager {
        friend class pub::Singleton<ActionManager>;
    public:
        bool SendPacket(Session &s, etim::uint16 cmd, etim::action::sendarg arg);
        bool RecvPacket(Session &s);
        
    std::map<uint16_t, action::Action *> GetActions() const { return actions_; }

    private:
        std::map<uint16_t, action::Action *> actions_;
        ActionManager();
        ActionManager(const ActionManager &rhs);
        ~ActionManager();
        
    };
    
}   //end etim

#endif /* defined(__ETImServer__ActionManager__) */



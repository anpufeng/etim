//
//  Action.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Action__
#define __ETImServer__Action__

#include <iostream>
#include "Session.h"


namespace etim {
    namespace action {
    
    ///所有操作的基类
    class Action {
        
    public:
        virtual void Execute(Session& s) = 0;
        virtual ~Action() {};
        
    };
        
    }   //end action
}   //end etim

#endif /* defined(__ETImServer__Action__) */

//
//  RetriveBuddy.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__RetriveBuddy__
#define __ETImServer__RetriveBuddy__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        class RetriveBuddy : public Action {
        public:
            virtual void Execute(Session& s);
        };
    } //end action
} //end etim
#endif /* defined(__ETImServer__RetriveBuddy__) */

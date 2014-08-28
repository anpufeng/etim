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
        
        class RetrieveBuddy : public Action {
        public:
            virtual void Execute(Session *s);
        };
    } //end action
} //end etim
#endif /* defined(__ETImServer__RetrieveBuddy__) */

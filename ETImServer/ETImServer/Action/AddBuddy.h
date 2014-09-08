//
//  AddBuddy.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__AddBuddy__
#define __ETImServer__AddBuddy__

#include <iostream>
#include "Action.h"

namespace etim {
    namespace action {
        
        class RequestAddBuddy : public Action {
        public:
            virtual void Execute(Session *s);
        };
        
        
        class SearchBuddy : public Action {
        public:
            virtual void Execute(Session *s);
        };
        
        class AcceptAddBuddy : public Action {
        public:
            virtual void Execute(Session *s);
        };
        
        class RejectAddBuddy : public Action {
        public:
            virtual void Execute(Session *s);
        };
    } //end action
} //end etim

#endif /* defined(__ETImServer__AddBuddy__) */

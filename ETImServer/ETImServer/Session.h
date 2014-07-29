//
//  Session.h
//  ETImServer
//
//  Created by Ethan on 14/7/29.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Session__
#define __ETImServer__Session__

#include <iostream>

namespace etim {
    class Session {
        Session();
        ~Session();
        
    public:
        int fd_;
        
    };
}   //end etim

#endif /* defined(__ETImServer__Session__) */

//
//  DataService.h
//  ETImServer
//
//  Created by Ethan on 14/8/8.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__DataService__
#define __ETImServer__DataService__

#include <iostream>

namespace etim  {
    class DataService {
        /*
         @return int 0为正常
         */
        int UserLogin(std::string &username, std::string &password);
    };
}   //end etim

#endif /* defined(__ETImServer__DataService__) */

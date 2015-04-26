//
//  StringUtil.h
//  ETImServer
//
//  Created by ethan on 15/4/26.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#ifndef __ETImServer__StringUtil__
#define __ETImServer__StringUtil__

#include <vector>
#include <string>

namespace etim {
    
    namespace pub {
    class StringUtil
    {
    public:
        static std::string Trim(std::string& str);
        static std::string Ltrim(std::string& str);
        static std::string Rtrim(std::string& str);
        static std::vector<std::string> Split(const std::string& str, const char delim);
    };
    
    } //end pub
    
}   //end etim
#endif /* defined(__ETImServer__StringUtil__) */

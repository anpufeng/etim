//
//  Config.h
//  ETImServer
//
//  Created by ethan on 15/4/26.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Config__
#define __ETImServer__Config__

#include <string>
#include <map>
#include <fstream>

namespace etim {
    
    namespace pub {
        ///MD5加密
        class Config
        {
            public:
            Config(const std::string& filepath);
            void Load();
            const std::string& GetProperty(const std::string& name);
            
        private:
            std::map<std::string, std::string> properties_;
            std::string filepath_;
        };
    } //end pub
    
}   //end etim


#endif /* defined(__ETImServer__Config__) */

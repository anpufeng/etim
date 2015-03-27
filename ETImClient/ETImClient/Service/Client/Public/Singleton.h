//
//  Singleton.h
//  ETImServer
//
//  Created by Ethan on 14/7/29.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef ETImServer_Singleton_h
#define ETImServer_Singleton_h

namespace etim {

namespace pub {
        
template <typename T>
class Singleton {
public:
    static T& Instance() {
        static T instance;
        return instance;
    }
private:
    Singleton();
    ~Singleton();
};
    
}   //end namespace pub
}   //end namespace etim

#endif

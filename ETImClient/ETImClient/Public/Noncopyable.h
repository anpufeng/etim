//
//  Noncopyable.h
//  ETImServer
//
//  Created by Ethan on 14/7/29.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef ETImServer_Noncopyable_h
#define ETImServer_Noncopyable_h

///摘自boost noncopyable
namespace etim {
namespace pub {
        
class Noncopyable
{
protected:
    Noncopyable() {};
    ~Noncopyable() {}
private:  // emphasize the following members are private
    Noncopyable( const Noncopyable& );
    const Noncopyable& operator=( const Noncopyable& );
};
    
    typedef pub::Noncopyable Noncopyable;
}   //end public
}   //end etim


#endif

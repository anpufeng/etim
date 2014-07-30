//
//  main.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include <iostream>
#include "Server.h"
#include "Singleton.h"

using namespace etim;
using namespace etim::pub;

int main(int argc, const char * argv[])
{

    // insert code here...
    
    typedef char int8;
    typedef int16_t int16;
    typedef int32_t int32;
    typedef int64_t int64;
    
    typedef unsigned char uint8;
    typedef unsigned short uint16;
    typedef unsigned int uint32;
    typedef unsigned long uint64;
    
    printf("char %d\n", (int)sizeof(char));
    printf("int16_t %d\n", (int)sizeof(int16_t));
    printf("int32_t %d\n", (int)sizeof(int32_t));
    printf("int64_t %d\n", (int)sizeof(int64_t));
    printf("unsigned char %d\n", (int)sizeof(unsigned char));
    printf("unsigned short %d\n", (int)sizeof(unsigned short));
    printf("unsigned int %d\n", (int)sizeof(unsigned int));
    printf("unsigned long %d\n", (int)sizeof(unsigned long));
    return Singleton<Server>::Instance().Start();

}


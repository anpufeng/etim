//
//  main.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include <iostream>
#include <mysql.h>
#include "Server.h"
#include "Singleton.h"
#include "Logging.h"

using namespace etim;
using namespace etim::pub;

int main(int argc, const char * argv[])
{

    // insert code here...
    
    /*
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
    
    LOG_INFO<<"Log info";
    LOG_DEBUG<<"Log debug";
    LOG_WARN<<"Log warn";
    LOG_ERROR<<"Log error";
    */
    
    MYSQL *connection, mysql;
    mysql_init(&mysql);
    connection = mysql_real_connect(&mysql,"127.0.0.1","root","","Pingan",0,0,0);
    if (connection == NULL)
    {
        //unable to connect
        printf("Oh Noes!\n");
    }
    else
    {
        printf("Connected.\n");
    }
    
    return Singleton<Server>::Instance().Start();

}


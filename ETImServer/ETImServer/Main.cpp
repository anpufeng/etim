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
    return Singleton<Server>::Instance().Start();

}


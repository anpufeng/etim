//
//  Exception.cpp
//  ETImClient
//
//  Created by Ethan on 14/8/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Exception.h"


using namespace etim;
using namespace etim::pub;


const char* Exception::what() const throw()
{
	return message_.c_str();
}

const char* Exception::StackTrace() const throw()
{
	return stackTrace_.c_str();
}

void Exception::FillStackTrace()
{
}

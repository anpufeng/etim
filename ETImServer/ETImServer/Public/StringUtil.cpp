//
//  StringUtil.cpp
//  ETImServer
//
//  Created by ethan on 15/4/26.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#include "StringUtil.h"


#include "StringUtil.h"

using namespace etim::pub;

std::string StringUtil::Trim(std::string& str)
{
    const std::string drop = " \t";
    str.erase(str.find_last_not_of(drop)+1);
    return str.erase(0,str.find_first_not_of(drop));
}

std::string StringUtil::Ltrim(std::string& str)
{
    const std::string drop = " \t";
    return str.erase(0,str.find_first_not_of(drop));
}

std::string StringUtil::Rtrim(std::string& str)
{
    const std::string drop = " \t";
    return str.erase(str.find_last_not_of(drop)+1);
}

std::vector<std::string> StringUtil::Split(const std::string& str, const char delim)
{
    std::vector<std::string> result;
    size_t start = 0;
    size_t pos = str.find(delim);
    while (pos != std::string::npos)
    {
        if (pos > start)
        {
            result.push_back(str.substr(start, pos-start));
        }
        start = pos+1;
        pos = str.find(delim, start);
    }
    
    if (start < str.length())
    {
        result.push_back(str.substr(start));
    }
    
    return result;
}

//
//  Config.cpp
//  ETImServer
//
//  Created by ethan on 15/4/26.
//  Copyright (c) 2015年 Pingan. All rights reserved.
//

#include "Config.h"


#include "StringUtil.h"
#include <assert.h>

using namespace etim::pub;
using namespace std;

Config::Config(const string& filepath) : filepath_(filepath)
{
    Load();
}

void Config::Load()
{
    ifstream fin(filepath_.c_str());
    assert(fin);
    string segmentName;
    string propertyName;
    //char* find = NULL;
    //char buf[512] = {0};
    
    string line;
    string::size_type pos;
    
    while (getline(fin, line))
    {
        StringUtil::Trim(line);
        if (line[0] == '#')
            continue;
        
        
        if (line[0] == '[' && (pos = line.find(']')) != string::npos)
            segmentName = line.substr(1, pos-1);
        else if ((pos = line.find('=')) != string::npos)
        {
            string left;
            string right;
            left = line.substr(0, pos);
            StringUtil::Rtrim(left);
            right = line.substr(pos+1);
            StringUtil::Trim(right);
            
            if (segmentName.empty())
            {
                propertyName = left;
            }
            else
            {
                propertyName = segmentName + "." + left;
            }
            
            properties_[propertyName] = right;
        }
    }
}

const std::string& Config::GetProperty(const std::string& name)
{
    return properties_[name];
}
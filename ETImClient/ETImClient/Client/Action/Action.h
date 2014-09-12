//
//  Action.h
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImServer__Action__
#define __ETImServer__Action__

#include <iostream>
#include "Session.h"
#include "OutStream.h"
#include "Endian.h"

namespace etim {
    namespace action {
    typedef std::map<std::string, std::string> sendarg;
    ///所有操作的基类
    class Action {
        
    public:
        virtual void DoSend(Session& s, sendarg arg) = 0;
        virtual void DoRecv(Session &s) = 0;
        virtual ~Action() {};
        
    public:
        /**将包头的长度及包尾填充到jos
         @param jos 输出打包类
         @param lengthPos 包头要填写包长度的位偏移量
         @param cmd 命令
         */
        void FillOutPackage(pub::OutStream &jos, size_t lengthPos, uint16 cmd);
        
    };
        
    }   //end action
}   //end etim

#endif /* defined(__ETImServer__Action__) */

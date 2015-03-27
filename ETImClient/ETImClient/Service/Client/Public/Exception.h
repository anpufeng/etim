//
//  Exception.h
//  ETImClient
//
//  Created by Ethan on 14/8/5.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#ifndef __ETImClient__Exception__
#define __ETImClient__Exception__

#include <iostream>
#include <exception>
#include <string>

namespace etim
{
    namespace pub {
        class Exception : public std::exception
        {
        public:
            explicit Exception(const char* message)
            : message_(message)
            {
                FillStackTrace();
            }
            
            explicit Exception(const std::string& message)
            : message_(message)
            {
                FillStackTrace();
            }
            
            virtual ~Exception() throw()
            {
                
            }
            
            virtual const char* what() const throw();
            const char* StackTrace() const throw();
            
        private:
            void FillStackTrace();
            
            std::string message_;
            std::string stackTrace_;
        };
        
        
        ///端接收异常  0服务器关闭  -1接收出错
        class RecvException :public Exception {
            public:
            
            explicit RecvException(const char* message, int received)
            : Exception(message), received_(received)
            {
                
            }
            
            int GetReceived() const { return received_; }

        private:
            int received_;
        };
    }//end pub
}   //end etim

#endif /* defined(__ETImClient__Exception__) */

//
//  HeartBeat.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/30.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "HeartBeat.h"
#include "OutStream.h"
#include "InStream.h"
#include "MD5.h"
#include "Idea.h"
#include "Logging.h"
#include "DataService.h"
#include "DataStruct.h"
#include "PushService.h"

#include <sstream>
#include <iomanip>
#include <sys/time.h>
#include <time.h>

using namespace etim;
using namespace etim::pub;
using namespace etim::action;
using namespace std;



void HeartBeat::Execute(Session *s) {
    InStream jis(s->GetRequestPack()->buf, s->GetRequestPack()->head.len);
	uint16 cmd = s->GetCmd();
    
	// 登录id
    string userId;
    jis>>userId;

    int16 error_code = kErrCode00;
	char error_msg[ERR_MSG_LENGTH+1] = {0};

	int ret = kErrCode00;

	if (ret == kErrCode00) {
		LOG_INFO<<"用户心跳包 userId: "<<userId;
         timeval now;
         gettimeofday(&now, NULL);
         s->SetLastTime(now);
	} else  {
		error_code = ret;
        assert(error_code < kErrCodeMax);
		strcpy(error_msg, gErrMsg[error_code].c_str());
		//LOG_ERROR<<"发送记录插入出错: "<<error_msg<<" userId: "<<from;
	}
    
	OutStream jos;
	// 包头命令
	jos<<cmd;
	size_t lengthPos = jos.Length();
	jos.Skip(2);///留出2个字节空间用来后面存储包体长度+包尾(8)的长度
	// 包头cnt、seq、error_code、error_msg
	uint16 cnt = 0;
	uint16 seq = 0;
	jos<<cnt<<seq<<error_code;
	jos.WriteBytes(error_msg, ERR_MSG_LENGTH);
    
	// 空包体
    
    FillOutPackage(jos, lengthPos, cmd);
	s->Send(jos.Data(), jos.Length());
}

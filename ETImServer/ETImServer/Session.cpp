//
//  Session.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/29.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Session.h"
#include "Logging.h"
#include "Endian.h"
#include "Exception.h"
#include "MD5.h"
#include "Idea.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

Session::Session(std::auto_ptr<Socket> &socket) : socket_(socket) {
    requestPack_= (RequestPack*)buffer_;
}

Session::~Session() {
    LOG_INFO<<"~Session析构函数";
}

void Session::Send(const char *buf, size_t len) {
    socket_->SendN(buf, len);
}

void Session::Recv(int *result) {
    int ret;
	// 接收包头
	ret = socket_->RecvN(buffer_, sizeof(RequestHead));
	if (ret == 0)	{ // 客户端关闭TODO 删除SESSION 还有-1的状况
        *result = 0;
		throw Exception("客户端关闭");
    } else if (ret != sizeof(RequestHead)) {
        *result = 1;
		throw Exception("接收数据包出错");
	}
    
	uint16 cmd = Endian::NetworkToHost16(requestPack_->head.cmd);
	uint16 len = Endian::NetworkToHost16(requestPack_->head.len);
	
    
	// 接收包体+包尾
	ret = socket_->RecvN(/*buffer_+sizeof(RequestHead)*/requestPack_->buf, len);
	if (ret == 0)	 {// 客户端关闭
        *result = 0;
		throw Exception("客户端关闭");
    }
	else if (ret != len)
	{
        *result = 1;
		throw Exception("接收数据包出错");
	}
    
	// 计算hash
	unsigned char hash[16];
	MD5 md5;
	md5.MD5Make(hash, (unsigned char const *)buffer_, sizeof(RequestHead)+len-8);
	for (int i=0; i<8; ++i) {
		hash[i] = hash[i] ^ hash[i+8];
		hash[i] = hash[i] ^ ((cmd >> (i%2)) & 0xff);
	}
    
	if (memcmp(hash, buffer_+sizeof(RequestHead)+len-8, 8)) {
        *result = 1;
		throw Exception("错误的数据包");
    }
    
    //将包头转换为本机字节序
	requestPack_->head.cmd = cmd;
	requestPack_->head.len = len;
}


void Session::DoAction() {
    Singleton<ActionManager>::Instance().DoAction(this);
}
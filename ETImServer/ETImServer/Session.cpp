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

using namespace etim;
using namespace etim::pub;

Session::Session(std::auto_ptr<Socket> &socket) : socket_(socket) {
    
}

Session::~Session() {
    LOG_INFO<<"~Session析构函数";
}

void Session::Send(const char *buf, size_t len) {
    socket_->SendN(buf, len);
}

void Session::Recv() {
    int ret;
	ret = socket_->RecvN(buffer_, sizeof(ResponseHead));
	if (ret == 0)
		throw Exception("服务器断开");
	else if (ret != sizeof(ResponseHead))
		throw Exception("接收数据包出错");
    
	uint16 cmd = Endian::NetworkToHost16(requestPack_->head.cmd);
	uint16 len = Endian::NetworkToHost16(requestPack_->head.len);
    
	
    
	if (len == 0)
		return;
    
	ret = socket_->RecvN(requestPack_->buf, len);
	if (ret == 0)
		throw Exception("服务器断开");
	else if (ret != len)
		throw Exception("接收数据包出错");
    
	// 计算hash
	unsigned char hash[16];
	MD5 md5;
	md5.MD5Make(hash, (unsigned char const *)buffer_, sizeof(ResponseHead)+len-8);
	for (int i=0; i<8; ++i)
	{
		hash[i] = hash[i] ^ hash[i+8];
		hash[i] = hash[i] ^ ((cmd >> (i%2)) & 0xff);
	}
    
	if (memcmp(hash, buffer_+sizeof(ResponseHead)+len-8, 8))
		throw Exception("数据包错误");
    
	requestPack_->head.cmd = cmd;
	requestPack_->head.len = len;
}
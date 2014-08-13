//
//  Session.cpp
//  ETImClient
//
//  Created by Ethan on 14/8/4.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "Session.h"
#include "Endian.h"
#include "Exception.h"
#include "MD5.h"
#include "Logging.h"
#include "Socket.h"

using namespace etim;
using namespace etim::pub;

using namespace std;

Session::Session(std::auto_ptr<Socket> &socket) : socket_(socket), isConnected_(false) {
    if (socket_->Create()) {
        if (socket_->Connect(HOST_SERVER, HOST_PORT))  {
            isConnected_ = true;
        } else {
            
        }
    }
    responsePack_ = (ResponsePack*)buffer_;
}

void Session::Clear() {
    request_.clear();
    response_.clear();
    errCode_ = 0;
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
    
	uint16 cmd = Endian::NetworkToHost16(responsePack_->head.cmd);
	uint16 len = Endian::NetworkToHost16(responsePack_->head.len);
    
	
    
	if (len == 0)
		return;
    
	ret = socket_->RecvN(responsePack_->buf, len);
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
    
	responsePack_->head.cmd = cmd;
	responsePack_->head.len = len;
}
void Session::SetResponse(const string& k, const string& v)
{
	response_[k] = v;
}

const string& Session::GetResponse(const string& k)
{
	return response_[k];
}

void Session::SetAttribute(const string& k, const string& v)
{
	request_[k] = v;
}

const string& Session::GetAttribute(const string& k)
{
	return request_[k];
}


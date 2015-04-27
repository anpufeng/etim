
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

#include <string>

using namespace etim;
using namespace etim::pub;

using namespace std;

Session::Session(std::auto_ptr<Socket> &socket, connectCallBack callBack, char *ip, unsigned short port) : socket_(socket), callBack_(callBack), isConnected_(false) {
    LOG_INFO<<"Session 构造函数";
    Connect(ip, port);
    responsePack_ = (ResponsePack*)buffer_;
}

Session::~Session() {
    LOG_INFO<<"~Session 析构函数";
    Close();
}

void Session::Close() {
        socket_->Close();
        isConnected_ = false;
}

bool Session::Reconnect(char *ip, unsigned short port) {
    responsePack_ = (ResponsePack*)buffer_;
    isConnected_ = false;
    return this->Connect(ip, port);
}
bool Session::Connect(char *ip, unsigned short port) {
    if (isConnected_) return true;
    
    if (socket_->Create()) {
        if (socket_->Connect(ip, port))  {
            isConnected_ = true;
        } else {
            isConnected_ = false;
            socket_->Close();
        }
        
        if (callBack_) {
            callBack_(isConnected_);
        }
    } else {
        LOG_FATAL<<"无法创建socket";
    }
    
    return isConnected_;
}

void Session::Clear() {
    response_.clear();
    //errCode_ = 0;
}
void Session::Send(const char *buf, size_t len) {
    if (socket_->SendN(buf, len) == -1) {
        isConnected_ = false;
    }
}

void Session::Recv() {
    int ret;
	ret = socket_->RecvN(buffer_, sizeof(ResponseHead));
	if (ret == 0) {
        isConnected_ = false;
		throw RecvException(strerror(errno), ret);
    }
    else if (ret == -1) {
        isConnected_ = false;
        throw RecvException(strerror(errno), ret);
    }
	else if (ret != sizeof(ResponseHead))
		throw RecvException(std::string("接收数据包出错").c_str(), ret);
    
	uint16 cmd = Endian::NetworkToHost16(responsePack_->head.cmd);
	uint16 len = Endian::NetworkToHost16(responsePack_->head.len);
    
    
	if (len == 0)
		return;
    
	ret = socket_->RecvN(responsePack_->buf, len);
    if (ret == 0) {
        isConnected_ = false;
		throw RecvException(strerror(errno), ret);
    }
    else if (ret == -1) {
        isConnected_ = false;
        throw RecvException(strerror(errno), ret);
    }
	else if (ret != len)
		throw RecvException(std::string("接收数据包出错").c_str(), ret);
    
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



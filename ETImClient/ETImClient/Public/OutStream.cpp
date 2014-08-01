#include "OutStream.h"
#include <string.h>

using namespace etim;
using namespace etim::pub;

const size_t OutStream::kInitialSize = 1024;

OutStream::OutStream() : buffer_(kInitialSize), currIndex_(0)
{
}

OutStream& OutStream::operator<<(uint8 x)
{
	Append(&x, sizeof x);
	return *this;
}

OutStream& OutStream::operator<<(uint16 x)
{
	uint16 be16 = Endian::HostToNetwork16(x);
	Append(&be16, sizeof be16);
	return *this;
}

OutStream& OutStream::operator<<(uint32 x)
{
	uint32 be32 = Endian::HostToNetwork32(x);
	Append(&be32, sizeof be32);
	return *this;
}

OutStream& OutStream::operator<<(int8 x)
{
	Append(&x, sizeof x);
	return *this;
}

OutStream& OutStream::operator<<(int16 x)
{
	int16 be16 = Endian::HostToNetwork16(x);
	Append(&be16, sizeof be16);
	return *this;
}

OutStream& OutStream::operator<<(int32 x)
{
	int32 be32 = Endian::HostToNetwork32(x);
	Append(&be32, sizeof be32);
	return *this;
}

OutStream& OutStream::operator<<(const std::string& str)
{
	uint16 len = static_cast<uint16>(str.length());
	*this<<len;
	Append(str.c_str(), len);
	return *this;
}


//void OutStream::WriteStr(const std::string& str)
//{
//	uint16 len = static_cast<uint16>(str.length());
//	*this<<len;
//	Append(str.c_str(), len);
//}

void OutStream::WriteBytes(const void* data, size_t len)
{
	Append(data, len);
}

void OutStream::Append(const char* data, size_t len)
{
	EnsureWritableBytes(len);
	std::copy(data, data+len, buffer_.begin()+currIndex_);
	currIndex_ += len;
}

void OutStream::Append(const void*  data, size_t len)
{
	Append(static_cast<const char*>(data), len);
}
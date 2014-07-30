#include "InStream.h"
#include <assert.h>
#include <string.h>

using namespace etim;
using namespace etim::pub;

InStream::InStream()
	: currIndex_(0)
{
}

InStream::InStream(const char* data, size_t len)
	: currIndex_(0)
{
	SetData(data, len);
}

void InStream::SetData(const char* data, size_t len)
{
	currIndex_ = 0;
	buffer_.resize(len);
	std::copy(data, data+len, buffer_.begin());
}

void InStream::ReadBytes(void* data, size_t len)
{
	assert(ReadableBytes() >= len);
    /*
	std::copy(buffer_.begin()+currIndex_,
		buffer_.begin()+currIndex_+len,
		stdext::checked_array_iterator<char*>(static_cast<char*>(data),len));
     */
	std::copy(buffer_.begin()+currIndex_, buffer_.begin()+currIndex_+len, static_cast<char*>(data));
	currIndex_ += len;
}


InStream& InStream::operator>>(uint8& x)
{
	assert(ReadableBytes() >= sizeof(uint8));
	x = *Peek();
	currIndex_ += sizeof x;

	return *this;
}

InStream& InStream::operator>>(uint16& x)
{
	assert(ReadableBytes() >= sizeof(uint16));
	uint16 be16 = 0;
	::memcpy(&be16, Peek(), sizeof be16);
	currIndex_ += sizeof be16;

	x = Endian::NetworkToHost16(be16);

	return *this;
}

InStream& InStream::operator>>(uint32& x)
{
	assert(ReadableBytes() >= sizeof(uint32));
	uint32 be32 = 0;
	::memcpy(&be32, Peek(), sizeof be32);
	currIndex_ += sizeof be32;

	x = Endian::NetworkToHost32(be32);

	return *this;
}

InStream& InStream::operator>>(int8& x)
{
	assert(ReadableBytes() >= sizeof(int8));
	x = *Peek();
	currIndex_ += sizeof x;

	return *this;
}

InStream& InStream::operator>>(int16& x)
{
	assert(ReadableBytes() >= sizeof(int16));
	int16 be16 = 0;
	::memcpy(&be16, Peek(), sizeof be16);
	currIndex_ += sizeof be16;

	x = Endian::NetworkToHost16(be16);

	return *this;
}

InStream& InStream::operator>>(int32& x)
{
	assert(ReadableBytes() >= sizeof(int32));
	int32 be32 = 0;
	::memcpy(&be32, Peek(), sizeof be32);
	currIndex_ += sizeof be32;

	x = Endian::NetworkToHost32(be32);

	return *this;
}

InStream& InStream::operator>>(std::string& str)
{
	uint16 len;
	*this>>len;
	assert(ReadableBytes() >= len);
	str.clear();
	str.append(Peek(), len);
	currIndex_ += len;

	return *this;
}

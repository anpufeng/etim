#ifndef _JIN_STREAM_H_
#define _JIN_STREAM_H_

#include "Endian.h"

#include <string>
#include <vector>

#include <assert.h>

namespace etim
{
    namespace pub {

        ///解包 摘自C++教程网
class InStream
{
public:
	InStream();
	InStream(const char* data, size_t len);

	void SetData(const char* data, size_t len);

	InStream& operator>>(uint8& x);
	InStream& operator>>(uint16& x);
	InStream& operator>>(uint32& x);

	InStream& operator>>(int8& x);
	InStream& operator>>(int16& x);
	InStream& operator>>(int32& x);

	InStream& operator>>(std::string& str);
	
	void Reposition(size_t pos)
	{
		currIndex_ = pos;
	}

	void Skip(size_t len)
	{
		assert(ReadableBytes() > len);
		currIndex_ += len;
	}
	
	void ReadBytes(void* data, size_t len);

private:
	size_t ReadableBytes() const
	{
		return buffer_.size() - currIndex_;
	}

	const char* Peek() const
	{
		return &*buffer_.begin() + currIndex_;
	}

	std::vector<char> buffer_;
	size_t currIndex_;
};

    }//end pub
}   //end etim

#endif /* _JIN_STREAM_H_ */

#ifndef _JOUT_STREAM_H_
#define _JOUT_STREAM_H_

#include "Endian.h"
#include <string>
#include <vector>
#include <algorithm>

namespace etim
{
    namespace pub {

        ///打包 摘自C++教程网 
class OutStream
{
public:
	static const size_t kInitialSize;

	OutStream();

	OutStream& operator<<(uint8 x);
	OutStream& operator<<(uint16 x);
	OutStream& operator<<(uint32 x);

	OutStream& operator<<(int8 x);
	OutStream& operator<<(int16 x);
	OutStream& operator<<(int32 x);

	OutStream& operator<<(const std::string& str);
	
	void WriteBytes(const void* data, size_t len);
	

	void Reposition(size_t pos)
	{
		currIndex_ = pos;
	}

	void Skip(size_t len)
	{
		EnsureWritableBytes(len);
		currIndex_ += len;
	}

	void Clear()
	{
		currIndex_ = 0;
	}
	
	char* Data()
	{
		return &*buffer_.begin();
	}

	const char* Data() const
	{
		return &*buffer_.begin();
	}

	size_t Length()
	{
		return currIndex_;
	}

private:
	size_t WriteableBytes() const
	{
		return buffer_.size() - currIndex_;
	}

	void EnsureWritableBytes(size_t len)
	{
		if (WriteableBytes() < len)
			buffer_.resize(currIndex_ + len);
	}
	
	void Append(const char*  data, size_t len);
	void Append(const void*  data, size_t len);
	std::vector<char> buffer_;
	size_t currIndex_;
};

}//end pub
}   //end etim

#endif /* _JOUT_STREAM_H_ */
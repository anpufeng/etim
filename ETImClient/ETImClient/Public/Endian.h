#ifndef _JUTIL_H_
#define _JUTIL_H_

#include <string>



namespace etim
{
    typedef char int8;
    typedef int16_t int16;
    typedef int32_t int32;
    typedef int64_t int64;
    
    typedef unsigned char uint8;
    typedef unsigned short uint16;
    typedef unsigned int uint32;
#ifdef __LP64__
#warning "64位编译"
    typedef unsigned long uint64;
#else
#warning "32位编译"
typedef unsigned long long uint64;
#endif
    
    
    namespace pub {

///网络与主机字节序的转换
class Endian
{
public:
	static uint16 HostToNetwork16(uint16 host16)
	{
		if (IsBigEndian())
			return host16;

		return Swap16(host16);
	}

	static uint32 HostToNetwork32(uint32 host32)
	{
		if (IsBigEndian())
			return host32;

		return Swap32(host32);
	}

	static uint64 HostToNetwork64(uint64 host64)
	{
		if (IsBigEndian())
			return host64;

		return Swap64(host64);
	}

	static uint16 NetworkToHost16(uint16 net16)
	{
		if (IsBigEndian())
			return net16;

		return Swap16(net16);
	}

	static uint32 NetworkToHost32(uint32 net32)
	{
		if (IsBigEndian())
			return net32;

		return Swap32(net32);
	}

	static uint64 NetworkToHost64(uint64 net64)
	{
		if (IsBigEndian())
			return net64;

		return Swap64(net64);
	}


private:
	static bool IsBigEndian()
	{
		const uint16 n = 0x0001;
		if (*(char*)&n)
			return false;

		return true;
	}

	static uint16 Swap16(uint16 s)
	{
		return (s & 0xff) << 8 | ((s >> 8) & 0xff);
	}

	static uint32 Swap32(uint32 l)
	{
		return l >> 24 |
			   (l & 0x00ff0000) >> 8 |
			   (l & 0x0000ff00) << 8 |
			   l << 24;
	}

	static uint64 Swap64(uint64 ll)
	{
		return ll >> 56|
			(ll & 0x00ff000000000000) >> 40 |
			(ll & 0x0000ff0000000000) >> 24 |
			(ll & 0x000000ff00000000) >> 8  | 
			(ll & 0x00000000ff000000) << 8  | 
			(ll & 0x0000000000ff0000) << 24 |
			(ll & 0x000000000000ff00) << 40 |
			ll << 56;
	}
};

class Convert
{
public:
	static int StringToInt(const std::string& str);
	static std::string IntToString(int x);
	static double StringToDouble(const std::string& str);
	static std::string DoubleToString(double x);
};

        
    }//end pub
}   //end etim

#endif /* _JUTIL_H_ */

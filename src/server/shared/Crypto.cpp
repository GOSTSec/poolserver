#include "Crypto.h"
#include "Gost.h"

namespace Crypto
{
	BinaryData GOSTD(BinaryData data)
	{
		uint8_t hash1[64], hash2[32];
		i2p::crypto::GOSTR3411_2012_512 (&data[0], data.size (), hash1);	
		i2p::crypto::GOSTR3411_2012_256 (hash1, 64, hash2);
		std::vector<byte> hash(32);
		// To Little Endian. TODO implement faster
		for (int i = 0; i < 32; i++)
			hash[i] = hash2[31-i]; 
		
		return 	hash;
	}
}

#include "wifiFrame.h"

wifiFrame createWifiFrame(uint16_t seqNum, char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4){
	wifiFrame f;
	f.seqNum = seqNum;
	f.type = type;
	f.data[0]= data1;
	f.data[1]= data2;
	f.data[2]= data3;
	f.data[3]= data4;
	return f;
}


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

void wifiFrameToChar(wifiFrame wf, char * tab){
	tab[0] = (char)(wf.seqNum>>8);
	tab[1] = (char)(wf.seqNum & 0x00FF);
	tab[2] = wf.type;
	tab[3] = (char)(wf.data[0]>>24);
	tab[4] = (char)((wf.data[0]>>16)&0x00FF);
	tab[5] = (char)((wf.data[0]>>8)&0x0000FF);
	tab[6] = (char)(wf.data[0]&0x000000FF);
	tab[7] = (char)(wf.data[1]>>24);
	tab[8] = (char)((wf.data[1]>>16)&0x00FF);
	tab[9] = (char)((wf.data[1]>>8)&0x0000FF);
	tab[10] = (char)(wf.data[1]&0x000000FF);
	tab[11] = (char)(wf.data[2]>>24);
	tab[12] = (char)((wf.data[2]>>16)&0x00FF);
	tab[13] = (char)((wf.data[2]>>8)&0x0000FF);
	tab[14] = (char)(wf.data[2]&0x000000FF);
	tab[15] = (char)(wf.data[3]>>24);
	tab[16] = (char)((wf.data[3]>>16)&0x00FF);
	tab[17] = (char)((wf.data[3]>>8)&0x0000FF);
	tab[18] = (char)(wf.data[3]&0x000000FF);
}

wifiFrame wifiFrameFromChar(char tab[19]){
	wifiFrame wf;
	wf.seqNum = ((uint16_t)((uint8_t)tab[0])<<8)+(uint16_t)((uint8_t)tab[1]);
	wf.type = tab[2];
	wf.data[0] = ((uint32_t)((uint8_t)tab[3])<<24)+((uint32_t)((uint8_t)tab[4])<<16)+((uint32_t)((uint8_t)tab[5])<<8)+((uint32_t)((uint8_t)tab[6]));
	wf.data[1] = ((uint32_t)((uint8_t)tab[7])<<24)+((uint32_t)((uint8_t)tab[8])<<16)+((uint32_t)((uint8_t)tab[9])<<8)+((uint32_t)((uint8_t)tab[10]));
	wf.data[2] = ((uint32_t)((uint8_t)tab[11])<<24)+((uint32_t)((uint8_t)tab[12])<<16)+((uint32_t)((uint8_t)tab[13])<<8)+((uint32_t)((uint8_t)tab[14]));
	wf.data[3] = ((uint32_t)((uint8_t)tab[15])<<24)+((uint32_t)((uint8_t)tab[16])<<16)+((uint32_t)((uint8_t)tab[17])<<8)+((uint32_t)((uint8_t)tab[18]));
	return wf;
}

#ifndef __WIFI_FRAME__
#define __WIFI_FRAME__

#include <stdint.h>
#include "frameTypes.h"

/*
	sequence number management :
		max seq num : 256
		seq num var : from 0 to 256
*/

#define MAX_WIFI_SEQ_NUM 50
extern uint16_t currentWifiSeqNum;

/*
	structure that will be sent as UDP data (our frame)
*/
typedef struct wifiFrame{
	uint16_t seqNum;
	char type;
	uint32_t data[4];
} wifiFrame;

/*
	Function for frame creation
*/

wifiFrame createWifiFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4);

void wifiFrameToChar(wifiFrame wf, char * tab);

wifiFrame wifiFrameFromChar(char tab[19]);

#endif

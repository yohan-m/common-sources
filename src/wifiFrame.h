#ifndef __WIFI_FRAME__
#define __WIFI_FRAME__

#include <stdint.h>

/*
	Frames types will be defined here
*/
#define TIME_FRAME 't'
#define DISTANCE_FRAME 'd'
#define DISCOVERY_FRAME 'D'

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

wifiFrame createWifiFrame(uint16_t seqNum, char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4);

void wifiFrameToChar(wifiFrame wf, char * tab);

wifiFrame wifiFrameFromChar(char tab[19]);

#endif

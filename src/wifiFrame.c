#include "wifiFrame.h"

uint16_t currentWifiSeqNum = 0;
/**
 * \brief Table used as return value for conversion function
 */
char converted[CONVERTED_WIFI_FRAME_SIZE];


wifiFrame createWifiFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t angle, uint32_t cmd, char stateMission){
	// creation of the frame
	wifiFrame f;
	// initializing frame fields
	f.seqNum = currentWifiSeqNum;
	f.type = type;
	f.positions[0] = data1;
	f.positions[1] = data2;
	f.positions[2] = data3;
	f.angle = angle;
	f.cmd = cmd;
	f.stateMission = stateMission;

	// sequence number management
	if(currentWifiSeqNum<MAX_WIFI_SEQ_NUM)
		currentWifiSeqNum++;
	else
		currentWifiSeqNum = 0;
		
	return f;
}


wifiFrame createMissionFrame(uint32_t data1, uint32_t data2, uint32_t data3, uint32_t angle, char stateMission){
	wifiFrame f = createWifiFrame(MISSION_FRAME,data1,data2,data3,angle,CMD_NONE,stateMission);
	return f;
}


wifiFrame createPositionFrame(uint32_t data1, uint32_t data2, uint32_t data3){
	wifiFrame f = createWifiFrame(POSITION_FRAME,data1,data2,data3,0,CMD_NONE,MISSION_NONE);
	return f;
}


wifiFrame createCmdFrame(uint32_t cmd){
	wifiFrame f = createWifiFrame(COMMAND_FRAME,0,0,0,0,cmd,MISSION_NONE);
	return f;
}


wifiFrame createDiscoveryFrame(){
	wifiFrame f = createWifiFrame(DISCOVERY_FRAME,0,0,0,0,CMD_NONE,MISSION_NONE);
	return f;
}


char * wifiFrameToChar(wifiFrame wf){
	// generation of the char * thanks to masks and divisions
	// the char * used as return is a global variable so that no malloc should be used
	converted[0] = (char)(wf.seqNum>>8);
	converted[1] = (char)(wf.seqNum & 0x00FF);
	converted[2] = wf.type;
	converted[3] = (char)(wf.positions[0]>>24);
	converted[4] = (char)((wf.positions[0]>>16)&0x00FF);
	converted[5] = (char)((wf.positions[0]>>8)&0x0000FF);
	converted[6] = (char)(wf.positions[0]&0x000000FF);
	converted[7] = (char)(wf.positions[1]>>24);
	converted[8] = (char)((wf.positions[1]>>16)&0x00FF);
	converted[9] = (char)((wf.positions[1]>>8)&0x0000FF);
	converted[10] = (char)(wf.positions[1]&0x000000FF);
	converted[11] = (char)(wf.positions[2]>>24);
	converted[12] = (char)((wf.positions[2]>>16)&0x00FF);
	converted[13] = (char)((wf.positions[2]>>8)&0x0000FF);
	converted[14] = (char)(wf.positions[2]&0x000000FF);
	converted[15] = wf.stateMission;
	
	return converted;
}


wifiFrame wifiFrameFromChar(char * tab){
	// calculating frame fields from char * assuming it is a valid converted form of a wifi frame
	// using multiplication and casts to recreate frame fields
	wifiFrame wf;
	wf.seqNum = ((uint16_t)((uint8_t)tab[0])<<8)+(uint16_t)((uint8_t)tab[1]);
	wf.type = tab[2];
	wf.positions[0] = ((uint32_t)((uint8_t)tab[3])<<24)+((uint32_t)((uint8_t)tab[4])<<16)+((uint32_t)((uint8_t)tab[5])<<8)+((uint32_t)((uint8_t)tab[6]));
	wf.positions[1] = ((uint32_t)((uint8_t)tab[7])<<24)+((uint32_t)((uint8_t)tab[8])<<16)+((uint32_t)((uint8_t)tab[9])<<8)+((uint32_t)((uint8_t)tab[10]));
	wf.positions[2] = ((uint32_t)((uint8_t)tab[11])<<24)+((uint32_t)((uint8_t)tab[12])<<16)+((uint32_t)((uint8_t)tab[13])<<8)+((uint32_t)((uint8_t)tab[14]));
	wf.stateMission = tab[15];

	return wf;
}


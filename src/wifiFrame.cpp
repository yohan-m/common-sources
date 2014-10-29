#include "wifiFrame.h"

uint16_t currentWifiSeqNum = 0;
/**
 * \brief Table used as return value for conversion function
 */
char converted[CONVERTED_WIFI_FRAME_SIZE];


wifiFrame createWifiFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4){
    // creation of the frame
    wifiFrame f;
    // initializing frame fields
    f.seqNum = currentWifiSeqNum;
    f.type = type;
    f.data[0]= data1;
    f.data[1]= data2;
    f.data[2]= data3;
    f.data[3]= data4;
    // sequence number management
    if(currentWifiSeqNum<MAX_WIFI_SEQ_NUM)
        currentWifiSeqNum++;
    else
        currentWifiSeqNum = 0;

    return f;
}


char * wifiFrameToChar(wifiFrame wf){
    // generation of the char * thanks to masks and divisions
    // the char * used as return is a global variable so that no malloc should be used
    converted[0] = (char)(wf.seqNum>>8);
    converted[1] = (char)(wf.seqNum & 0x00FF);
    converted[2] = wf.type;
    converted[3] = (char)(wf.data[0]>>24);
    converted[4] = (char)((wf.data[0]>>16)&0x00FF);
    converted[5] = (char)((wf.data[0]>>8)&0x0000FF);
    converted[6] = (char)(wf.data[0]&0x000000FF);
    converted[7] = (char)(wf.data[1]>>24);
    converted[8] = (char)((wf.data[1]>>16)&0x00FF);
    converted[9] = (char)((wf.data[1]>>8)&0x0000FF);
    converted[10] = (char)(wf.data[1]&0x000000FF);
    converted[11] = (char)(wf.data[2]>>24);
    converted[12] = (char)((wf.data[2]>>16)&0x00FF);
    converted[13] = (char)((wf.data[2]>>8)&0x0000FF);
    converted[14] = (char)(wf.data[2]&0x000000FF);
    converted[15] = (char)(wf.data[3]>>24);
    converted[16] = (char)((wf.data[3]>>16)&0x00FF);
    converted[17] = (char)((wf.data[3]>>8)&0x0000FF);
    converted[18] = (char)(wf.data[3]&0x000000FF);

    return converted;
}


wifiFrame wifiFrameFromChar(char * tab){
    // calculating frame fields from char * assuming it is a valid converted form of a wifi frame
    // using multiplication and casts to recreate frame fields
    wifiFrame wf;
    wf.seqNum = ((uint16_t)((uint8_t)tab[0])<<8)+(uint16_t)((uint8_t)tab[1]);
    wf.type = tab[2];
    wf.data[0] = ((uint32_t)((uint8_t)tab[3])<<24)+((uint32_t)((uint8_t)tab[4])<<16)+((uint32_t)((uint8_t)tab[5])<<8)+((uint32_t)((uint8_t)tab[6]));
    wf.data[1] = ((uint32_t)((uint8_t)tab[7])<<24)+((uint32_t)((uint8_t)tab[8])<<16)+((uint32_t)((uint8_t)tab[9])<<8)+((uint32_t)((uint8_t)tab[10]));
    wf.data[2] = ((uint32_t)((uint8_t)tab[11])<<24)+((uint32_t)((uint8_t)tab[12])<<16)+((uint32_t)((uint8_t)tab[13])<<8)+((uint32_t)((uint8_t)tab[14]));
    wf.data[3] = ((uint32_t)((uint8_t)tab[15])<<24)+((uint32_t)((uint8_t)tab[16])<<16)+((uint32_t)((uint8_t)tab[17])<<8)+((uint32_t)((uint8_t)tab[18]));

    return wf;
}

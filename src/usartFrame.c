#include "usartFrame.h"
#include "lib_crc.h"
#include <stdio.h>

uint16_t currentUsartSeqNum = 0;

usartFrame createUsartFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4){
	usartFrame f;
	f.seqNum = currentUsartSeqNum;
	f.type = type;
	f.data[0]= data1;
	f.data[1]= data2;
	f.data[2]= data3;
	f.data[3]= data4;
	char tab[19];
	usartFrameToChar(f,tab);
	f.crc = createCRC(tab, 19);
	if(currentUsartSeqNum<MAX_USART_SEQ_NUM)
		currentUsartSeqNum++;
	else
		currentUsartSeqNum = 0;
		
	return f;
}


uint16_t createCRC(char * tab, int tabLen){
	uint16_t crc = 0;
	int i = 0;
	for(i=0;i<tabLen+1;i++){
		crc = update_crc_16(crc,*tab);
		tab++;
	}
	
	return crc;
}


void usartFrameToChar(usartFrame f, char * tab){
	tab[0] = (char)(f.seqNum>>8);
	tab[1] = (char)(f.seqNum & 0x00FF);
	tab[2] = f.type;
	tab[3] = (char)(f.data[0]>>24);
	tab[4] = (char)((f.data[0]>>16)&0x00FF);
	tab[5] = (char)((f.data[0]>>8)&0x0000FF);
	tab[6] = (char)(f.data[0]&0x000000FF);
	tab[7] = (char)(f.data[1]>>24);
	tab[8] = (char)((f.data[1]>>16)&0x00FF);
	tab[9] = (char)((f.data[1]>>8)&0x0000FF);
	tab[10] = (char)(f.data[1]&0x000000FF);
	tab[11] = (char)(f.data[2]>>24);
	tab[12] = (char)((f.data[2]>>16)&0x00FF);
	tab[13] = (char)((f.data[2]>>8)&0x0000FF);
	tab[14] = (char)(f.data[2]&0x000000FF);
	tab[15] = (char)(f.data[3]>>24);
	tab[16] = (char)((f.data[3]>>16)&0x00FF);
	tab[17] = (char)((f.data[3]>>8)&0x0000FF);
	tab[18] = (char)(f.data[3]&0x000000FF);
}

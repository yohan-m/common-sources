#ifndef __USART_FRAME__
#define __USART_FRAME__

#include <stdint.h>
#include "frameTypes.h"

/*
	sequence number management :
		max seq num : 256
		seq num var : from 0 to 256
*/

#define MAX_USART_SEQ_NUM 50
extern uint16_t currentUsartSeqNum;

/*
	structure that will be sent from embedded STM to drone via USART
*/
typedef struct usartFrame{
	uint16_t seqNum;
	char type;
	uint32_t data[4];
	uint16_t crc;
} usartFrame;

/*
	Function for frame creation
*/

usartFrame createUsartFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4);

/*
	creates a 16 bits crc from a char * representing the frame (seqNum, type and the 4 data)
*/
uint16_t createCRC(char * tab, int tabLen);

/*
	transforms a frame into a char * (used to create the necessary char* for the createCRC function)
	does not include CRC in the generated char*
*/
void usartFrameToChar(usartFrame f, char * tab);

#endif

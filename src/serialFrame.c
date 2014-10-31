#include "serialFrame.h"
#include "lib_crc.h"
#include <stdio.h>

/*
*	-----------------------------------------------------------
*				public functions
*	-----------------------------------------------------------
*/

uint16_t currentUsartSeqNum = 0;
/**
 * \brief Table used as return value for conversion function
 */
uint8_t converted[CONVERTED_SERIAL_FRAME_SIZE];


serialFrame createUsartFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4){
	// creation of the frame
	serialFrame f;
	// initializing the fields
	f.seqNum = currentUsartSeqNum;
	f.type = type;
	f.data[0]= data1;
	f.data[1]= data2;
	f.data[2]= data3;
	f.data[3]= data4;
	// converting the frame into a char * for CRC generation purpose
	char tab[19];
	serialFrameToChar(f,tab);
	// CRC generation
	f.crc = createCRC(tab, 19);
	// sequence number management
	if(currentUsartSeqNum<MAX_SERIAL_SEQ_NUM)
		currentUsartSeqNum++;
	else
		currentUsartSeqNum = 0;
		
	return f;
}


uint8_t * createSendableFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t data4){
	// creating a frame with the given parameters
	serialFrame uf = createUsartFrame(type, data1, data2, data3, data4);
	// returning its converted uint8_t form
	return serialFrameToUint(uf);
}


uint8_t retrieveReadFrame(uint8_t * read, serialFrame * uf){
	// converting back the uint8_t form of the frame in its classic form
	*uf = serialFrameFromUint(read);
	// generating the CRC for this converted form
	char tab[19];
	serialFrameToChar(*uf,tab);
	uint16_t crcRead = createCRC(tab, 19);
	// comparing this generated CRC to the one contained in the frame to check integrity of the whole frame
	if(crcRead==uf->crc)
		return 0;
	else
		return 1;
}


uint8_t * serialFrameToUint(serialFrame uf){
	// generation of the uint8_t * thanks to masks and divisions
	// the uint8_t * used as return is a global variable so that no malloc should be used
	converted[0] = (uint8_t)(uf.seqNum>>8);
	converted[1] = (uint8_t)(uf.seqNum & 0x00FF);
	converted[2] = (uint8_t)uf.type;
	converted[3] = (uint8_t)(uf.data[0]>>24);
	converted[4] = (uint8_t)((uf.data[0]>>16)&0x00FF);
	converted[5] = (uint8_t)((uf.data[0]>>8)&0x0000FF);
	converted[6] = (uint8_t)(uf.data[0]&0x000000FF);
	converted[7] = (uint8_t)(uf.data[1]>>24);
	converted[8] = (uint8_t)((uf.data[1]>>16)&0x00FF);
	converted[9] = (uint8_t)((uf.data[1]>>8)&0x0000FF);
	converted[10] = (uint8_t)(uf.data[1]&0x000000FF);
	converted[11] = (uint8_t)(uf.data[2]>>24);
	converted[12] = (uint8_t)((uf.data[2]>>16)&0x00FF);
	converted[13] = (uint8_t)((uf.data[2]>>8)&0x0000FF);
	converted[14] = (uint8_t)(uf.data[2]&0x000000FF);
	converted[15] = (uint8_t)(uf.data[3]>>24);
	converted[16] = (uint8_t)((uf.data[3]>>16)&0x00FF);
	converted[17] = (uint8_t)((uf.data[3]>>8)&0x0000FF);
	converted[18] = (uint8_t)(uf.data[3]&0x000000FF);
	converted[19] = (uint8_t)(uf.crc>>8);
	converted[20] = (uint8_t)(uf.crc & 0x00FF);
	
	return converted;
}


serialFrame serialFrameFromUint(uint8_t * toConvert){
	// calculating frame fields from uint8_t * assuming it is a valid converted form of an serial frame
	// using multiplication and casts to recreate frame fields
	serialFrame uf;
	uf.seqNum = (((uint16_t)toConvert[0])<<8)+(uint16_t)(toConvert[1]);
	uf.type = (char)toConvert[2];
	uf.data[0] = ((uint32_t)(toConvert[3])<<24)+((uint32_t)(toConvert[4])<<16)+((uint32_t)(toConvert[5])<<8)+((uint32_t)(toConvert[6]));
	uf.data[1] = ((uint32_t)(toConvert[7])<<24)+((uint32_t)(toConvert[8])<<16)+((uint32_t)(toConvert[9])<<8)+((uint32_t)(toConvert[10]));
	uf.data[2] = ((uint32_t)(toConvert[11])<<24)+((uint32_t)(toConvert[12])<<16)+((uint32_t)(toConvert[13])<<8)+((uint32_t)(toConvert[14]));
	uf.data[3] = ((uint32_t)(toConvert[15])<<24)+((uint32_t)(toConvert[16])<<16)+((uint32_t)(toConvert[17])<<8)+((uint32_t)(toConvert[18]));
	uf.crc = ((uint16_t)(toConvert[19]<<8))+((uint16_t)(toConvert[20]));
	
	return uf;
}

/*
*	-----------------------------------------------------------
*				private functions
*	-----------------------------------------------------------
*/

uint16_t createCRC(char * tab, uint8_t tabLen){
	// initial CRC value (0 for a 16 bits one)
	uint16_t crc = 0;
	int i = 0;
	// updating CRC value for each char in the converted form of the frame
	for(i=0;i<tabLen;i++){
		crc = update_crc_16(crc,*tab);
		tab++;
	}
	
	return crc;
}


void serialFrameToChar(serialFrame f, char * tab){
	// generation of the char * thanks to masks and divisions
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

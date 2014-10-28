#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "../wifiFrame.h"
#include "../usartFrame.h"


int main(){

	int i = 0;
	wifiFrame f, f2;
	usartFrame uf, uf2;
	for(i=0;i<60;i++){
		// creating both frames
		f = createWifiFrame(TIME_FRAME,currentWifiSeqNum,currentWifiSeqNum*137,currentWifiSeqNum*761,currentWifiSeqNum*943);
		uf = createUsartFrame(DISTANCE_FRAME,currentUsartSeqNum,currentUsartSeqNum*137,currentUsartSeqNum*761,currentUsartSeqNum*943);
		//	displaying wifi frame and reconstituted wifi frame
		printf("\n\n-----------------------\nframe:\nseqNum=%d\ntype=%c\ndata=%d; %d; %d; %d\n",f.seqNum,f.type,f.data[0],f.data[1],f.data[2],f.data[3]);
		char *tab;
		tab = wifiFrameToChar(f);
		f2 = wifiFrameFromChar(tab);
		printf("\nframe2:\nseqNum=%d\ntype=%c\ndata=%d; %d; %d; %d\n",f2.seqNum,f2.type,f2.data[0],f2.data[1],f2.data[2],f2.data[3]);
		
		// displaying usart frame and reconstituted one
		
		printf("\n-----------------------\nusart frame:\nseqNum=%d\ntype=%c\ndata=%d; %d; %d; %d\ncrc=%d\n",uf.seqNum,uf.type,uf.data[0],uf.data[1],uf.data[2],uf.data[3],uf.crc);
		uint8_t *tab2;
		tab2 = createSendableFrame(DISTANCE_FRAME,currentUsartSeqNum,currentUsartSeqNum*137,currentUsartSeqNum*761,currentUsartSeqNum*943);
		if(retrieveReadFrame(tab2,&uf2)==0)
			printf("\nusart frame2:\nseqNum=%d\ntype=%c\ndata=%d; %d; %d; %d\ncrc=%d\n---------------------\n\n",uf2.seqNum,uf2.type,uf2.data[0],uf2.data[1],uf2.data[2],uf2.data[3],uf2.crc);


	}

	return 0;
}

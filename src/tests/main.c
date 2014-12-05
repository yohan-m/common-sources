#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "../wifiFrame.h"


int main(){

	int i = 0;
	wifiFrame f, f2;
	for(i=0;i<60;i++){
		// creating both frames
		f = createWifiFrame(POSITION_FRAME,currentWifiSeqNum,currentWifiSeqNum*137,currentWifiSeqNum*761,currentWifiSeqNum*943,CMD_FWD,LAUNCH_MISSION);
		//	displaying wifi frame and reconstituted wifi frame
		printf("\n-----------------------\nframe:\nseqNum=%d\ntype=%c\nposition=%d; %d; %d\nangle=%d\ncmd=%d\nstatemission=%c\n\n",f.seqNum,f.type,f.positions[0],f.positions[1],f.positions[2],f.angle,f.cmd,f.stateMission);

	char * tab = malloc(CONVERTED_WIFI_FRAME_SIZE);
	tab = (char*)&f;
	f2 = *(wifiFrame*)tab;
			//	displaying wifi frame and reconstituted wifi frame
		printf("frame 2:\nseqNum=%d\ntype=%c\nposition=%d; %d; %d\nangle=%d\ncmd=%d\nstatemission=%c\n\n",f2.seqNum,f2.type,f2.positions[0],f2.positions[1],f2.positions[2],f2.angle,f2.cmd,f2.stateMission);
	}

	return 0;
}

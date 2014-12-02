/**
 * \file wifiFrame.h
 *
 * \brief Wifi frame definition and utilities
 *
 * \author Yohan Marchiset
 *
 * \date 28 Oct 2014
 */


#ifndef __WIFI_FRAME__
#define __WIFI_FRAME__

#include <stdint.h>
#include "frameTypes.h"

/**
 * \brief Converted size of a wifi frame in bytes
 */
#define CONVERTED_WIFI_FRAME_SIZE 16
/**
 * \brief Maximum sequence number for the wifi frames
 */
#define MAX_WIFI_SEQ_NUM 50

/**
 * \brief Current wifi frame sequence number
 */
extern uint16_t currentWifiSeqNum;

/**
 * \brief Structure used a frame for wifi communication
 */
typedef struct wifiFrame{
	uint16_t seqNum ;		/**< Sequence number of the frame */
	char type ;			/**< Type of the frame, can be either d or t */
    	uint32_t positions[3] ;		/**< Positions x, y, z */
	char stateMission ;
} wifiFrame;

/**
 * \brief Creation of a frame
 * \param[in]	type	type of the frame to create, either TIME_FRAME or DISTANCE_FRAME
 * \param[in]	data1	first data to send in the frame
 * \param[in]	data2	second data to send in the frame
 * \param[in]	data3	third data to send in the frame
 * \return 		a frame initialized with the values given as parameters and a generated sequence number
 */
wifiFrame createWifiFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, char stateMission);

/**
 * \brief Conversion function : from frame to char *
 * \param[in]	wf	wifi frame that will be converted
 * \return		the converted char * version of the frame
 */
char * wifiFrameToChar(wifiFrame wf);

/**
 * \brief Conversion function : from char * to frame
 * param[in]	tab	a char * to convert into a frame (must be a converted version of a frame or might fail)
 * \return		a wifiFrame generated from the char * given as parameter
 */
wifiFrame wifiFrameFromChar(char * tab);

#endif

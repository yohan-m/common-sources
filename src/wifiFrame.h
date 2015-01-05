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
#include "commands_drone.h"

/**
 * \brief Converted size of a wifi frame in bytes
 */
#define CONVERTED_WIFI_FRAME_SIZE sizeof(wifiFrame)
/**
 * \brief Maximum sequence number for the wifi frames
 */
#define MAX_WIFI_SEQ_NUM 50

/**
 * \brief Local (drone) port from where emission and reception will be done
 */
#define DRONE_PORT 30000
/**
 * \brief Remote (PC) port to which data will be sent
 */
#define PC_PORT 31000

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
	uint32_t angle;	/**< angle field for the mission */
	uint32_t cmd;	/**< command field for manual control */
	char stateMission ;	/**< mission command field for mission control */
} wifiFrame;

/**
 * \brief Creation of a standard frame
 * \param[in]	type	type of the frame to create, either TIME_FRAME or DISTANCE_FRAME
 * \param[in]	data1	first data to send in the frame
 * \param[in]	data2	second data to send in the frame
 * \param[in]	data3	third data to send in the frame
 * \return 		a frame initialized with the values given as parameters and a generated sequence number
 */
wifiFrame createWifiFrame(char type, uint32_t data1, uint32_t data2, uint32_t data3, uint32_t angle, uint32_t cmd, char stateMission);

/**
 * \brief Creation of a mission frame (unused fields are filled with default values)
 * \param[in]	data1	x position for the mission
 * \param[in]	data2	y position for the mission
 * \param[in]	data3	z position for the mission
 * \param[in]	angle	angle for the mission
 * \return 		the wanted mission frame
 */
wifiFrame createMissionFrame(uint32_t data1, uint32_t data2, uint32_t data3, uint32_t angle, char stateMission);

/**
 * \brief Creation of a position frame (unused fields are filled with default values)
 * \param[in]	data1	x position of the drone
 * \param[in]	data2	y position of the drone
 * \param[in]	data3	z position of the drone
 * \return 		the wanted position frame
 */
wifiFrame createPositionFrame(uint32_t data1, uint32_t data2, uint32_t data3);

/**
 * \brief Creation of a command frame (unused fields are filled with default values)
 * \param[in]	cmd	a AT*command for the drone to do
 * \return 		the wanted command frame
 */
wifiFrame createCmdFrame(uint32_t cmd);

/**
 * \brief Creation of a discovery frame (unused fields are filled with default values)
 * \return 		the wanted discovery frame
 */
wifiFrame createDiscoveryFrame();

/**
 * \brief Creation of a change master frame (unused fields are filled with default values)
 * \param[in]	type	a char indicating whether PC or drone sends the commands
 * \return 		the wanted command frame
 */
wifiFrame createChangeMasterFrame(char type);

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

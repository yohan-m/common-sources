/**
 * \file commands_drone.h
 *
 * \brief Frame types definition
 *
 * \author Yohan Marchiset
 *
 * \date 05 Dec 2014
 */

#ifndef __COMMANDS_DRONE__
#define __COMMANDS_DRONE__

/**
 * \brief Command none
 */
#define CMD_NONE 0

/**
 * \brief Command forward
 */
#define CMD_FWD 1

/**
 * \brief Command backward
 */
#define CMD_BWD 2

/**
 * \brief Command left
 */
#define CMD_LEFT 4

/**
 * \brief Command right
 */
#define CMD_RIGHT 8

/**
 * \brief Command up
 */
#define CMD_UP 16

/**
 * \brief Command down
 */
#define CMD_DOWN 32

/**
 * \brief Command right rotation
 */
#define CMD_ROTATE_RIGHT 64

/**
 * \brief Command left rotation
 */
#define CMD_ROTATE_LEFT 128

/**
 * \brief Command take off
 */
#define CMD_TAKE_OFF 256

/**
 * \brief Command land
 */
#define CMD_LAND 512

/**
 * \brief Command ftrim
 */
#define CMD_FTRIM 1024

/**
 * \brief Command emergency
 */
#define CMD_EMERGENCY 2048

/**
 * \brief Command init navdata
 */
#define CMD_INIT_NAVDATA 4096

/**
 * \brief Command calibrate magno
 */
#define CMD_CALIB_MAGNO 8092

#endif

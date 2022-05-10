/*
 *  Basic functions of FreeRTOS_on_Tuman32.
 *  Hardware ISA is based on RV-32I, OS Kernel is based on FreeRTOS V10.3.0
 *
 *  Copyright (C) 2019-2020 Junnan Li <lijunnan@nudt.edu.cn>. All Rights Reserved.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2020.02.02
 *  Description: basic processing. 
 *  1 tab == 4 spaces!
 */

#ifndef CAN_H
#define CAN_H

#include <stdio.h>
#include <stdlib.h>

#include "firmware.h"

uint32_t tag_can_send; //* used to distinguish send or recv interrupt;

//* some struct
struct basic_can_conf{
    //* control registers;
    uint32_t control_reg;   //* addr: 0x00, data: 0x3f;
    uint32_t acr_reg;       //* addr: 0x04, data: 0x3f;
    uint32_t amr_reg;       //* addr: 0x05, data: 0x3f;
    uint32_t btr_0_reg;     //* addr: 0x06, data: 0x05;
    uint32_t btr_1_reg;     //* addr: 0x07, data: 0x34;
    uint32_t out_ctrl_reg;  //* addr: 0x08, data: 0x1a;
    uint32_t diy_reg;       //* addr: 0x09, data: 0x11;
    uint32_t clk_div_reg;   //* addr: 0x1f, data: 0x08;
    //* transmit registers;
    uint32_t txUD_10_to_3;  //* addr: 0x28, data: 0x3f;
    uint32_t txID_rtr_dlc;  //* addr: 0x2c, data: 0x3f;
    uint32_t tx_data[8];    //* addr: 0x30 - 0x4c;
    //* receive registers;
    uint32_t rxID_10_to_3;  //* addr: 0x50, data: xx;
    uint32_t rxID_rtr_dlc;  //* addr: 0x54, data: xx;
    uint32_t rx_data[8];    //* addr: 0x58 - 0x74;
};

//* id: 0x01, mask: 0xff, btr: 500kbps;
void initial_can_for_rangefinder(void);

//* read sensor_distance's device information;
void get_rangefinder_info(void);

//* read distance value sampled by rangefinder;
void recv_can_sensor_distance(void);

//* set rangefinder's sampling rate;
void set_rangefinder_sample_rate(void);

//* start rangefinder;
void start_rangefinder(void);

//* stop rangefinder;
void stop_rangefinder(void);

//* set reg_0 to start receving data;
void to_recv_can(void);

//* delay x instructions by inset "NOP"
void sleep(uint32_t sleep_time);

#endif


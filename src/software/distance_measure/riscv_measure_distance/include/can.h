/*
 *  Basic functions for RISC-V32 core.
 *  Hardware ISA is based on RV-32I, OS Kernel is based on FreeRTOS V10.3.0
 *
 *  Copyright (C) 2022-2022 Junnan Li <lijunnan@nudt.edu.cn>. All Rights Reserved.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Lasted updated date: 2022.01.20
 *  Description: can's head file. 
 *  1 tab == 4 spaces!
 */

#ifndef CAN_H
#define CAN_H

#include "firmware.h"

//* Special address in iCore
#define CAN_BASE_ADDR 0x10030000

uint32_t tag_can_send; //* used to distinguish send or recv interrupt;

//* some struct
struct basic_can_conf{
    uint32_t control_reg;   //* addr: 0x00, data: 0x3f;
    uint32_t acr_reg;       //* addr: 0x04, data: 0x3f;
    uint32_t amr_reg;       //* addr: 0x05, data: 0x3f;
    uint32_t btr_0_reg;     //* addr: 0x06, data: 0x05;
    uint32_t btr_1_reg;     //* addr: 0x07, data: 0x34;
    uint32_t out_ctrl_reg;  //* addr: 0x08, data: 0x1a;
    uint32_t diy_reg;       //* addr: 0x09, data: 0x11;
    uint32_t clk_div_reg;   //* addr: 0x1f, data: 0x08;
};

void initial_can(void);

void send_can(void);

void recv_can_sensor_distance(void);

void set_can_sensor_distance_sample_rate(void);

void start_can_sensor_distance(void);

void stop_can_sensor_distance(void);

void to_recv_can(void);

void sleep(uint32_t sleep_time);

#endif


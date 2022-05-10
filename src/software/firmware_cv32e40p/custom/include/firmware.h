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

#ifndef __FIRMWARE_H
#define __FIRMWARE_H

#include <stdio.h>
#include <stdlib.h>


//* UART
#define UART_RD_ADDR    0x10010000         //* UART read;
#define UART_WR_ADDR    0x10010004         //* UART write;

//* CAN
#define CAN_BASE_ADDR   0x10030000

//* LCD
#define LCD
#define GPIO_LCD_STATUS 0x10020000      // gpio lcd address;

//* PKT
#define ADDR_RECV_TAG   0x10040000
#define ADDR_RECV_LEN   0x10040004
#define ADDR_RECV_PORT  0x10040006
#define ADDR_RECV_PKT   0x10040008
#define ADDR_SEND_TAG   0x10048000
#define ADDR_SEND_LEN   0x10048004
#define ADDR_SEND_PORT  0x10048006
#define ADDR_SEND_PKT   0x10048008

//* RS485
#define RS485_0_RD_ADDR 0x10050000      //* RS485_0 read;
#define RS485_0_WR_ADDR 0x10050004      //* RS485_0 write;
#define RS485_1_RD_ADDR 0x10060000      //* RS485_1 read;
#define RS485_1_WR_ADDR 0x10060004      //* RS485_1 write;

//* PWM
#define PWM_BASE_ADDR 0x10070000      //* PWM time_occupy (total is 512 cycles);

#define MSTATUS_MIE_BIT 3

#endif


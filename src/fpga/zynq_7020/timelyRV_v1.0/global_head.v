/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        global_head.
 *  Description:        head file of timelyRV_SoC_hardware.
 *  Last updated date:  2022.04.01.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

//* function define;
`define NUM_PERI  3
`define UART      0   //* Do not comment;
`define CAN       1   //* CAN is open;
`define LCD       2   //* lcd is open;
// `define PKT       3   //* for pkt;
// `define RS485_0   2   //* for RS485_0;
// `define RS485_1   3   //* for RS485_1;
// `define PWM       4


//* address define;
`define BASE_ADDR_UART    16'h1001
`define BASE_ADDR_LCD     16'h1002
`define BASE_ADDR_CAN     16'h1003
`define BASE_ADDR_PKT     16'h1004
`define BASE_ADDR_RS485_0 16'h1005
`define BASE_ADDR_RS485_1 16'h1006
`define BASE_ADDR_PWM     16'h1007

//* instr/data memory size
`define MEM_128KB 1 //* default is 64KB;

//* picorv32 or cv32e40p
`define CV32E40P 1 //* default is picorv32;

//* nic's mac address;
`define NIC_MAC_ADDR      48'h000a_3500_0102
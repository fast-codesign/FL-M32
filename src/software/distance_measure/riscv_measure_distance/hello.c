/*
 *  Main function for RISC-V32 core.
 *  Hardware ISA is based on RISCV-32I, supported OS Kernel is based on FreeRTOS V10.3.0
 *
 *  Copyright (C) 2019-2022 Junnan Li <lijunnan@nudt.edu.cn>. All Rights Reserved.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last updated date: 2022.01.18
 *  Description: main processing. 
 *  1 tab == 4 spaces!
 */

#include "include/firmware.h"
// #include "include/can.h"


int hello(){
	//* open irq, irq is closed in default configuration;
	__irq_enable();	//* should comment Start.S's "#define CTRLIRQ_INSN 1" if do not define instr_ctlirq;

	//* test printf function, output by uart;
	printf("hello world\r\n");

	//* wait irq;
	while(1);

	//* never reach here;
	return 0;
}

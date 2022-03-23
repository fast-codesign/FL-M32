/*
 *  iCore_software -- Software for TimelyRV (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Date: 2022.03.22
 *  Description: irq funciton, just has timer irq. 
 */

#include "firmware.h"
extern unsigned int timer_irq_count;

uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	if ((irqs & (1<<5)) != 0) {
		
	}
	
	if ((irqs & 1) != 0) {
		timer_irq_count++;
		print_str("irq_time,");
		printf("count is %d\r\n",timer_irq_count);
		// *(volatile unsigned int*)0x80000000 = i;
		// i++;
		// enable_timer(125000000);
	}

	return regs;
}


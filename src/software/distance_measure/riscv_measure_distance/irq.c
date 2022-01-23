/*
 *  IRQ functions for RISC-V32 core.
 *  Hardware ISA is based on RISCV-32I, supported OS Kernel is based on FreeRTOS V10.3.0
 *
 *  Copyright (C) 2019-2022 Junnan Li <lijunnan@nudt.edu.cn>. All Rights Reserved.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last updated date: 2022.01.18
 *  Description: irq processing. 
 *  1 tab == 4 spaces!
 */

#include "include/can.h"
#define LED_ADDR 0x10020008
#define UART_RV_ADDR 0x10010000

uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	__irq_disable();

	// printf("irq is %08x\r\n",irqs);
	//* check irqs;
	//* gpio irq, irq[3] is not 0;
	if ((irqs & (1<<3)) != 0) {
		printf("Gpio interrupt\r\n");
		int * key_status = (int *) GPIO_KEY_STATUS;
		printf("Key status is %08x\r\n",*key_status);
	}
	//* uart irq, irq[4] is not 0;
	else if ((irqs & (1<<4)) != 0) {
		printf("\nUart interrupt\r\n");
		// int * uart_data = (int *) 0x11000000;
		char uart_data = *((volatile uint32_t *) UART_RV_ADDR);
		while(uart_data != 0){
			printf("%d\r\n", uart_data);
			// *((volatile uint32_t*)LED_ADDR) = 2;
			if(uart_data == 48){	//* '0'
				// *((volatile uint32_t*)LED_ADDR) = 1;
				initial_can();
			}
			else if(uart_data == 49){	//* '1', send data, read sensor_distance's device information;
				send_can();
			}
			else if(uart_data == 47){	//* '/', prepare to recv data;
				to_recv_can();
			}
			else if(uart_data == 97){	//* 'a', send data, set sensor_distance's sampling rate;
				set_can_sensor_distance_sample_rate();
			}
			else if(uart_data == 98){	//* 'b', send data, start sensor_distance;
				start_can_sensor_distance();
			}
			else if(uart_data == 99){	//* 'c', send data, stop sensor_distance;
				stop_can_sensor_distance();
			}
			else {	//* from '2' to 'Q'
				uint32_t temp_addr = (uart_data - 50)<<2;
				uint32_t * addr_can = (uint32_t *) (CAN_BASE_ADDR + temp_addr);
				printf("addr is %08x", addr_can);
				uint32_t can_data = *((volatile uint32_t *) (addr_can));
				printf("data is %08x", can_data);
				// *((volatile uint32_t*)LED_ADDR) = 2;
			}
			// else if(uart_data == 51)
			// 	*((volatile uint32_t*)LED_ADDR) = 4;
			// else if(uart_data == 52)
			// 	*((volatile uint32_t*)LED_ADDR) = 8;
			uart_data = *((volatile char *) UART_RV_ADDR);
		}
	}
	//* can irq after sending/receiving data, irq[5] is not 0;
	else if ((irqs & (1<<5)) != 0) {
		// printf("tag_can_send is %d", tag_can_send);
		//* judge interrupt & release interrupt;
		unsigned char can_interrupt = *((volatile uint32_t *) (CAN_BASE_ADDR + 12));
		(void) can_interrupt;
		// printf("interrupt is %02x\r\n", can_interrupt);
		if((can_interrupt & 0x01) == 1){
			*((volatile uint32_t*)LED_ADDR) = 1;
			recv_can_sensor_distance();
		}
		else{
			tag_can_send = 0;
		}
	}
	else if ((irqs & 1) != 0) {
		printf("Timer interrupt\r\n");
	}
	else{
		printf("Meet system error at interrupt program\r\n");
		__asm__ volatile ("ebreak");
	}

	__irq_enable();

	return regs;
}


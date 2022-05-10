// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "include/firmware.h"

//* input 'x', output 'x';
void uart_echo(void){
	uint32_t uart_data = *((volatile uint32_t *) UART_RD_ADDR);
	char uart_data_char;
	while(uart_data != 0x80000000){
		uart_data_char = (char) (uart_data & 0xff);
		printf("%c\r\n", uart_data_char);
		uart_data = *((volatile uint32_t *) UART_RD_ADDR);
	}
}

void get_distance_by_can(void){
	uint32_t uart_data = *((volatile uint32_t *) UART_RD_ADDR);
	while(uart_data != 0x80000000){
		if(uart_data == 48){		//* '0'
			initial_can_for_rangefinder();
		}
		else if(uart_data == 49){	//* '1', send data, read sensor_distance's device information;
			get_rangefinder_info();
		}
		else if(uart_data == 47){	//* '/', prepare to recv data;
			to_recv_can();
		}
		else if(uart_data == 97){	//* 'a', send data, set sensor_distance's sampling rate;
			set_rangefinder_sample_rate();
		}
		else if(uart_data == 98){	//* 'b', send data, start sensor_distance;
			start_rangefinder();
		}
		else if(uart_data == 99){	//* 'c', send data, stop sensor_distance;
			stop_rangefinder();
		}
		else {
		}
		uart_data = *((volatile uint32_t *) UART_RD_ADDR);
	}
}

void uart_irq_handler(void) {
    // uart_echo();

    get_distance_by_can();

    asm volatile("mret");
}



void can_irq_handler(void) {
	unsigned char can_interrupt = *((volatile uint32_t *) (CAN_BASE_ADDR + 12));
    if((can_interrupt & 0x01) == 1){
		recv_can_sensor_distance();
	}
    asm volatile("mret");
}


// //* configure can's register by uart (cmd);
// uint32_t tag_wr_rd, uart_input_stage, tag_reg_addr, tag_reg_wdata;
// void conf_canReg_by_uart(void){
// 	uint32_t uart_data = *((volatile uint32_t *) UART_RD_ADDR);
// 	char uart_data_char;
// 	while(uart_data != 0x80000000){
// 		//* read op;
// 		uart_data_char = (char) (uart_data & 0xff);
// 		// printf("%c ", uart_data_char);
// 		if(uart_data_char == 119){ //* meet 'w'
// 			tag_wr_rd = 1;
// 			uart_input_stage = 0;
// 			tag_reg_addr = 0;
// 			tag_reg_wdata = 0;
// 			printf("write mode\r\n");
// 		}
// 		else if(uart_data_char == 114){ //* meet 'r'
// 			tag_wr_rd = 0;
// 			uart_input_stage = 0;
// 			tag_reg_addr = 0;
// 			tag_reg_wdata = 0;
// 			printf("read mode\r\n");
// 		}
// 		else if(uart_data_char == 32){ //* meet ' '
// 			if(uart_input_stage == 1){
// 				//* update addr;
// 				tag_reg_addr = (tag_reg_addr<<2) + CAN_BASE_ADDR;
// 				printf("addr: %08x\r\n", tag_reg_addr);
// 			}
// 			uart_input_stage += 1;
// 		}
// 		else if(uart_data_char == 13){ //* meet 'backspace'
// 			if(tag_wr_rd == 0){ //* read;
// 				//* update addr;
// 				tag_reg_addr = (tag_reg_addr<<2) + CAN_BASE_ADDR;
// 				//* read can;
// 				uint32_t can_data = *((volatile uint32_t *) (tag_reg_addr));
// 				printf("data is %08x\r\n", can_data);	
// 			}
// 			else { //* write;
// 				//* write can;
// 				*((volatile uint32_t *) (tag_reg_addr)) = tag_reg_wdata;
// 				printf("addr: %08x, wdata: %08x\r\n", tag_reg_addr, tag_reg_wdata);
// 			}
// 			uart_input_stage += 1;
// 		}
// 		else{
// 			if(uart_input_stage == 1){
// 				tag_reg_addr = (tag_reg_addr<<4) + (uart_data_char - 48);
// 			}
// 			else if(uart_input_stage == 2){
// 				//* read wdata;
// 				tag_reg_wdata = (tag_reg_wdata<<4) + (uart_data_char - 48);
// 			}
// 			printf("addr: %08x, wdata: %08x\r\n", tag_reg_addr, tag_reg_wdata);
// 		}
// 		uart_data = *((volatile uint32_t *) UART_RD_ADDR);
// 	}
// }

// //* input 'x', output 'x';
// void rs485_echo(int port){
// 	uint32_t rs485_data;
// 	if(port == 0)
// 		rs485_data = *((volatile uint32_t *) RS485_0_RD_ADDR);
// 	else
// 		rs485_data = *((volatile uint32_t *) RS485_1_RD_ADDR);
// 	char rs485_data_char;
// 	while(rs485_data != 0x80000000){
// 		rs485_data_char = (char) (rs485_data & 0xff);
// 		printf("%c\r\n", rs485_data_char);
// 		if(port == 0)
// 			rs485_data = *((volatile uint32_t *) RS485_0_RD_ADDR);
// 		else
// 			rs485_data = *((volatile uint32_t *) RS485_1_RD_ADDR);
// 	}
// }


// uint32_t *irq(uint32_t *regs, uint32_t irqs)
// {
// 	__irq_disable();
// 	#ifdef DEBUG_IRQ
// 		printf("irq is %08x\r\n",irqs);
// 	#endif
// 	//* uart irq, irq[4] is not 0;
// 	if ((irqs & (1<<4)) != 0) {
// 		uart_echo();

// 		// conf_canReg_by_uart();

// 		// get_distance_by_can();
// 	}
// 	else if ((irqs & (1<<5)) != 0) {
// 		//* can irq, judge interrupt & release interrupt;
// 		// unsigned char can_interrupt = *((volatile uint32_t *) (CAN_BASE_ADDR + 12));
// 		// if((can_interrupt & 0x01) == 1){
// 		// 	recv_can_sensor_distance();
// 		// }

// 		//* rs485_0
// 		rs485_echo(0);
// 	}
// 	else if ((irqs & (1<<6)) != 0) {
// 		//* rs485_1
// 		rs485_echo(1);
// 	}
// 	else if ((irqs & 1) != 0) {
// 		printf("Timer interrupt\r\n");
// 	}
// 	else{
// 		printf("Meet system error at interrupt program\r\n");
// 		__asm__ volatile ("ebreak");
// 	}

// 	__irq_enable();

// 	return regs;
// }


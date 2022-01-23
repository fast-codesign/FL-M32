/*
 *  Basic functions for RISC-V32 core.
 *  Hardware ISA is based on RV-32I, OS Kernel is based on FreeRTOS V10.3.0
 *
 *  Copyright (C) 2022-2022 Junnan Li <lijunnan@nudt.edu.cn>. All Rights Reserved.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Lasted updated date: 2022.01.20
 *  Description: basic processing for can. 
 *  1 tab == 4 spaces!
 */

#include "include/can.h"

//* support outputing distance (value) measured by sensor on LCD;
#define LCD

struct basic_can_conf str_can_conf;

void initial_can(void){
	//* id: 0x01, mask: 0xff, btr: 500kbps;
	str_can_conf.control_reg = 0x3f;
	str_can_conf.acr_reg = 0x01;
	str_can_conf.amr_reg = 0xff;
	str_can_conf.btr_0_reg = 0x00;
	str_can_conf.btr_1_reg = 0x1c;
	str_can_conf.out_ctrl_reg = 0x1a;
	str_can_conf.diy_reg = 0x11;
	str_can_conf.clk_div_reg = 0x08;

	*((volatile uint32_t*)(CAN_BASE_ADDR)) = 0x3f;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 16)) = 0x01;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 20)) = 0xff;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 24)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 28)) = 0x1c;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 32)) = 0x1a;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 36)) = 0x11;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 124)) = 0x08;

	printf("finish initialising can's configuration\n");
}

void send_can(void){
	*((volatile uint32_t*)(CAN_BASE_ADDR)) = 0x3e;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 40)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 44)) = 0x28;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 48)) = 0x55;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 52)) = 0x01;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 56)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 60)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 64)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 68)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 72)) = 0xd3;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 76)) = 0xaa;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 4)) = 0x1;
	tag_can_send = 1;
}

void recv_can_sensor_distance(void){
	unsigned char data[8];
	data[0] = *((volatile uint32_t *) (CAN_BASE_ADDR + 88));
	sleep(20);
	data[1] = *((volatile uint32_t *) (CAN_BASE_ADDR + 92));
	sleep(20);
	data[2] = *((volatile uint32_t *) (CAN_BASE_ADDR + 96));
	sleep(20);
	data[3] = *((volatile uint32_t *) (CAN_BASE_ADDR + 100));
	sleep(20);
	data[4] = *((volatile uint32_t *) (CAN_BASE_ADDR + 104));
	sleep(20);
	data[5] = *((volatile uint32_t *) (CAN_BASE_ADDR + 108));
	sleep(20);
	data[6] = *((volatile uint32_t *) (CAN_BASE_ADDR + 112));
	sleep(20);
	data[7] = *((volatile uint32_t *) (CAN_BASE_ADDR + 116));
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 4)) = 0x4;
	
	//* print distance or received data;
	if(data[1] == 0x07 && data[2] == 0x0){
		// unsigned int distance = ((unsigned int) data[3]) << 16 + ((unsigned int)data[4] << 8) + (unsigned int) data[5];
		unsigned int distance = (data[3] << 16) + (data[4] << 8) + data[5];
		printf("distance is : %u mm\r\n", distance);
		#ifdef LCD
			*((volatile uint32_t*)GPIO_LCD_STATUS) = data[4];
			*((volatile uint32_t*)GPIO_LCD_STATUS) = data[5];
		#endif
	}
	else{
		printf("recv data is : ");
		for(int i=0; i<8; i++){
			printf("%02x", data[i]);
		}
		printf("\r\n");
	}
	
}

void set_can_sensor_distance_sample_rate(void){
	*((volatile uint32_t*)(CAN_BASE_ADDR)) = 0x3e;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 40)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 44)) = 0x28;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 48)) = 0x55;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 52)) = 0x03;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 56)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 60)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 64)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 68)) = 0x02;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 72)) = 0x26;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 76)) = 0xaa;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 4)) = 0x1;
	tag_can_send = 1;
}

void start_can_sensor_distance(void){
	*((volatile uint32_t*)(CAN_BASE_ADDR)) = 0x3e;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 40)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 44)) = 0x28;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 48)) = 0x55;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 52)) = 0x05;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 56)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 60)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 64)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 68)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 72)) = 0xcc;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 76)) = 0xaa;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 4)) = 0x1;
	tag_can_send = 1;
}

void stop_can_sensor_distance(void){
	*((volatile uint32_t*)(CAN_BASE_ADDR)) = 0x3e;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 40)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 44)) = 0x28;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 48)) = 0x55;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 52)) = 0x06;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 56)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 60)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 64)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 68)) = 0x00;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 72)) = 0x88;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 76)) = 0xaa;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 4)) = 0x1;
	tag_can_send = 1;
}

void to_recv_can(void){
	*((volatile uint32_t*)(CAN_BASE_ADDR)) = 0x3e;
	sleep(20);
	*((volatile uint32_t*)(CAN_BASE_ADDR + 4)) = 0x4;
	tag_can_send = 0;
}

void sleep(uint32_t sleep_time){
    volatile uint32_t i = 0;
    while(i < sleep_time){
        i++;
    }
    return;
}

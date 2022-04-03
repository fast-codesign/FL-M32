hello.c 是main函数（不需要修改）
	其中__irq_enable()用于打开irq；

irq.c是irq处理函数（需要修改）
	#define LED_ADDR 0x10020008 			对应FPGA中led灯的地址；
	#define UART_RV_ADDR 0x10010000			对应FPGA中uart的地址；
	（can的地址再can.h中定义）


	//* uart irq, irq[4] is not 0;			irq_bitmap[4]是uart中断；

	if(uart_data == 48){	//* '0'			键盘‘0’是初始化can（不需要修改）
		// *((volatile uint32_t*)LED_ADDR) = 1;
		initial_can();
	}
	else if(uart_data == 49){	//* '1', send data, read sensor_distance's device information;（键盘‘1’，针对测距功能）
		send_can();
	}
	else if(uart_data == 47){	//* '/', prepare to recv data; （键盘‘/’，使can进入接收状态，针对测距功能）
		to_recv_can();
	}
	else if(uart_data == 97){	//* 'a', send data, set sensor_distance's sampling rate;
		set_can_sensor_distance_sample_rate(); （键盘‘a’，配置测距频率，针对测距功能）
	}
	else if(uart_data == 98){	//* 'b', send data, start sensor_distance;
		start_can_sensor_distance();（键盘‘b’，开始测距，针对测距功能）
	}
	else if(uart_data == 99){	//* 'c', send data, stop sensor_distance;
		stop_can_sensor_distance();（键盘‘c’，停止测距，针对测距功能）
	}
	else {	//* from '2' to 'Q' （键盘‘2’-‘Q’，每个数字/字母对应Can的一个地址，可用于寄存器读）
		uint32_t temp_addr = (uart_data - 50)<<2;
		uint32_t * addr_can = (uint32_t *) (CAN_BASE_ADDR + temp_addr);
		printf("addr is %08x", addr_can);
		uint32_t can_data = *((volatile uint32_t *) (addr_can));
		printf("data is %08x", can_data);
		// *((volatile uint32_t*)LED_ADDR) = 2;
	}

	//* can irq after sending/receiving data, irq[5] is not 0; （bitmap[5]是can中断）
	else if ((irqs & (1<<5)) != 0) {
		// printf("tag_can_send is %d", tag_can_send);
		//* judge interrupt & release interrupt;
		unsigned char can_interrupt = *((volatile uint32_t *) (CAN_BASE_ADDR + 12));
		(void) can_interrupt;
		// printf("interrupt is %02x\r\n", can_interrupt);
		if((can_interrupt & 0x01) == 1){	（中断寄存器最后1b是接收数据中断，不需要修改）
			*((volatile uint32_t*)LED_ADDR) = 1;
			recv_can_sensor_distance();
		}
		else{
			tag_can_send = 0;
		}
	}


can.h(需要修改)
#define CAN_BASE_ADDR 0x10030000 (can基始地址)


can.c（初始化can，或者构造针对测距协议的can数据，不需要修改）

start.S(主汇编，不需要修改)

custom_op.S（测定指令汇编，不需要修改）

system.c(系统函数，如打印函数，不需要修改)

firmware.h（主库函数，不需要修改）

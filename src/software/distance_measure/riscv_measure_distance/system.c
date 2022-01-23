/*
 *  Basic functions for RISC-V32 core.
 *  Hardware ISA is based on RISCV-32I, supported OS Kernel is based on FreeRTOS V10.3.0
 *
 *  Copyright (C) 2019-2022 Junnan Li <lijunnan@nudt.edu.cn>. All Rights Reserved.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last updated date: 2022.01.18
 *  Description: basic processing. 
 *  1 tab == 4 spaces!
 */

#include "include/firmware.h"
#include <stdarg.h>

//* print funciton;
//*	1) print a char; 2) print a string;
//* 3) print a dec; 4) print a hex;
void print_chr(char ch){
	*((volatile uint32_t*)OUTPORT) = ch;
}

void print_str(const char *p){
	while (*p != 0)
		*((volatile uint32_t*)OUTPORT) = *(p++);
}

void print_dec(unsigned int val){
	char buffer[10];
	char *p = buffer;
	while (val || p == buffer) {
		*(p++) = val % 10;
		val = val / 10;
	}
	while (p != buffer) {
		*((volatile uint32_t*)OUTPORT) = '0' + *(--p);
	}
}

void print_void(void){}

void print_hex(unsigned int val, int digits){
	for (int i = (4*digits)-4; i >= 0; i -= 4)
		*((volatile uint32_t*)OUTPORT) = "0123456789ABCDEF"[(val >> i) % 16];
}


#define PAD_RIGHT 1
#define PAD_ZERO 2

static int print(const char *format, va_list args ){
	register int width, pad;
	register int pc = 0;

	for (; *format != 0; ++format) {
		if (*format == '%') {
			++format;
			width = pad = 0;
			if (*format == '\0') break;
			if (*format == '%') goto out;
			if (*format == '-') {
				++format;
				pad = PAD_RIGHT;
			}
			while (*format == '0') {
				++format;
				pad |= PAD_ZERO;
			}
			for ( ; *format >= '0' && *format <= '9'; ++format) {
				width *= 10;
				width += *format - '0';
			}
			if( *format == 's' ) {
				register char *s = (char *)va_arg( args, int );
				print_str(s);
				continue;
			}
			if( *format == 'd' ) {
				print_dec(va_arg( args, int ));
				pc += 1;
				continue;
			}
			if( *format == 'x' ) {
				print_hex(va_arg( args, int ), width);
				pc += 1;
				continue;
			}
			if( *format == 'X' ) {
				print_hex(va_arg( args, int ), width);
				pc += 1;
				continue;
			}
			if( *format == 'u' ) {
				print_dec(va_arg( args, int ));
				pc += 1;
				continue;
			}
			if( *format == 'c' ) {
				/* char are converted to int then pushed on the stack */
				print_chr((char)va_arg( args, int ));
				pc += 1;
				continue;
			}
		}
		else {
		out:
			print_chr (*format);
			++pc;
		}
	}
	va_end( args );
	return pc;
}

int printf(const char *format, ...){
	va_list args;
	int ret;
	// unsigned int flags;

	// flags = __irq_save();
	va_start( args, format );
	ret = print(format, args );
	// __irq_restore(flags);
	return ret;
}

// int sprintf(char *out, const char *format, ...){
// 	va_list args;

// 	va_start( args, format );
// 	return print( &out, format, args );
// }

// int __vprintf(const char *format, va_list args){
// 	int ret;
// 	unsigned int flags;

// 	flags = __irq_save();
// 	ret = print( 0, format, args );
// 	__irq_restore(flags);
// 	return ret;
// }

//* read system timer or instruction counter
void sys_gettime(struct timespec *timer){
	uint32_t *addr = (uint32_t *) TIMER_H_ADDR;
	timer->tv_sec = *((volatile uint32_t*)addr);
	timer->tv_nsec = *((volatile uint32_t*)addr+1);
}

// int sys_getinstr(void){
// 	uint32_t *addr = (uint32_t *) INSTR_ADDR;
// 	return(*((volatile uint32_t*)addr));
// }

//* end function
void sys_finish(void){
	print_str("Finish!\n");
	uint32_t *addr;
	addr = (uint32_t *) FINISH_ADDR;
	*((volatile uint32_t*)addr) = 1;
}
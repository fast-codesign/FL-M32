/*
 *  Basic functions for TimelyRV (RV32I) core.
 *  Hardware ISA is based on RISCV-32I, supported OS Kernel is based on FreeRTOS V10.3.0
 *
 *  Copyright (C) 2019-2022 Junnan Li <lijunnan@nudt.edu.cn>. All Rights Reserved.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last updated date: 2022.01.18
 *  Description: basic processing. 
 *  1 tab == 4 spaces!
 */

#ifndef FIRMWARE_H
#define FIRMWARE_H
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

//* Special address in iCore
#define OUTPORT 0x10000000              // print address;

#define GPIO_KEY_STATUS 0x10020004      // gpio key address;
#define GPIO_LED_STATUS 0x10020008      // gpio led address;
#define GPIO_LCD_STATUS 0x1002000C      // gpio lcd address;

#define TIMER_L_ADDR 0x20000100         // system timer address;
#define TIMER_H_ADDR 0x20000104         
#define TIMERCMP_L_ADDR 0x20000108      // system timer address;
#define TIMERCMP_H_ADDR 0x2000010c      
// #define INSTR_ADDR 0x20000002        // system instruction counter address;
#define TEMP_M0 0x0000000c

#define FINISH_ADDR 0x20000000          // stop program when writing this address;

//* some struct
struct time_spec{
    uint32_t tv_sec;
    uint32_t tv_nsec;
};

//* for test mode
// #define PRINT_TEST

//* some basic function for iCore;

//* print funciton;
//*     1) print a char; 2) print a string;
//*     3) print a dec; 4) print a hex; also support 5) printf;
void print_chr(char ch);
void print_str(const char *p);
void print_dec(unsigned int val);
void print_hex(unsigned int val, int digits);
void print_void(void);
int printf(const char *format, ...);

//* Main function;
// int mainRISCVshudu (void);   //* functions in mainRISCVshudu
int main (void);

//* end function, i.e., stop program;
void sys_finish(void);

//* irq control;
extern void __irq_disable(void);
extern void __irq_enable(void);

//* irq process in irq.c;
uint32_t *irq(uint32_t *regs, uint32_t irqs);

//* TODO...
void sys_gettime(struct time_spec *timer);
// int sys_getinstr(void);
void do_irq(uint32_t *regs);
extern void timer_enable(unsigned int); //* timer

//* irq timer;
extern void __set_timer_irq(int t);

//* mem process;
void *memcpy(void *aa, const void *bb, long n);
void* memset(void* dst,int val, size_t count);
int memcmp(const void *buffer1,const void *buffer2,int count);
void* memmove(void* dest, const void* src, size_t n);
size_t strnlen(const char *str, size_t maxsize);
size_t strlen (const char * str);
char *strcpy(char* dst, const char* src);
int strcmp(const char *s1, const char *s2);
int strncmp(const char* str1, const char* str2 ,int size);
int atoi(const char *str);

#endif
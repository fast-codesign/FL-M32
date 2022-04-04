# Copyright (c) 2001, Adam Dunkels.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote
#    products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# This file is part of the uIP TCP/IP stack.
#
# $Id: Makefile,v 1.13 2006/06/11 21:55:03 adam Exp $
#

TOOLCHAIN_PREFIX = /opt/riscv32i/bin/riscv32-unknown-elf-

MAKE = make
CCFLAGS = -march=rv32i -mabi=ilp32 -Wall
FIRMWARE_OBJS = start.o main.o 
SYSTEM_OBJS = system.o custom_ops.o irq.o
UIP_OBJ = $(UIP_SRCS:%.c=%.o) 
UIP_OBJ += $(PORT_SRCS:%.c=%.o) 
RAM_SIZE = 131072 #128*1024

UIP_INCLUDEFILES = uip unix
INCLUDES=-Iuip -Iport -I.

#src
UIP_SRCS = uip/psock.c \
			uip/timer.c \
			uip/uip-fw.c \
			uip/uip-neighbor.c \
			uip/uip-split.c \
			uip/uip.c \
			uip/uip_arp.c \
			uip/uiplib.c

PORT_SRCS = port/clock-arch.c \
			port/echo_tcp.c \
			port/tapdev.c			


firmware: firmware.bin
	python3 makehex.py $< $(RAM_SIZE) > hex/$(addsuffix .hex,$@)

firmware.bin: firmware.elf firmware.elf.S
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@;
	wc -c firmware.bin
	size firmware.elf
	chmod -x $@

firmware.elf.S: firmware.elf
	$(TOOLCHAIN_PREFIX)objdump $< -s -d > $@

firmware.elf: $(FIRMWARE_OBJS) $(SYSTEM_OBJS) $(UIP_OBJ) sections.lds
	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -Os -ffreestanding -nostdlib -o $@ \
		-Wl,-Bstatic,-T,sections.lds \
		$(FIRMWARE_OBJS) $(SYSTEM_OBJS) $(UIP_OBJ) -lgcc
	chmod -x $@

%.o: %.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -o $@ $<

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) $(INCLUDES) -Os -ffreestanding -nostdlib -o $@ $<

uip/%.o: uip/%.c $(UIP_INCLUDEFILES)
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) $(INCLUDES) -Os -ffreestanding -nostdlib -o $@ $<

unix/%.o: unix/%.c $(UIP_INCLUDEFILES)
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) $(INCLUDES) -Os -ffreestanding -nostdlib -o $@ $<

clean:
	rm -fr hex/*hex *.bin *.elf.S uip/*.o unix/*.o port/*.o *.o

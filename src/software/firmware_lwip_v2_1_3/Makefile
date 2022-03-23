# SHELL := /bin/bash
# lwip = lwip141
# lwip_version = lwip-1.4.1
lwip = lwip_v213
lwip_version = lwip-2.1.3
include $(lwip)/Makefile


TOOLCHAIN_PREFIX = /opt/riscv32i/bin/riscv32-unknown-elf-

MAKE = make
CCFLAGS = -march=rv32i -mabi=ilp32 -Wall
FIRMWARE_OBJS = start.o main.o $(lwip)/obj/echo.o

SYSTEM_OBJS = system.o irq.o
RAM_SIZE = 131072 #128*1024
# BLOCK_RAM_SIZE = 131072 # 4096

nPORT = $(lwip)/contrib/ports/riscv
nLWIP_DIR = $(lwip)/$(lwip_version)
INCLUDES=-I$(nLWIP_DIR)/src/include \
		-I$(nPORT)/include/arch \
		-I$(nPORT)/include/netif \
		-I$(nPORT)/include \
		-I$(lwip)/contrib/apps/tcpecho_raw

$(LWIP_INCLUDEFILES)+=$(lwip)/contrib/apps/tcpecho_raw/echo.h

VPATH = $(nLWIP_DIR)/src/core/ $(nLWIP_DIR)/src/core/ipv4/ \
	$(nLWIP_DIR)/src/core/ipv6 \
	$(nLWIP_DIR)/src/core/snmp $(nLWIP_DIR)/src/netif \
	$(nPORT) $(nPORT)/netif \
	$(lwip)/contrib/apps/tcpecho_raw

firmware: firmware.bin
	python3 makehex.py $< $(RAM_SIZE) > hex/$(addsuffix .hex,$@)

firmware.bin: firmware.elf firmware.elf.S
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@;
	wc -c firmware.bin
	size firmware.elf
	chmod -x $@

firmware.elf.S: firmware.elf
	$(TOOLCHAIN_PREFIX)objdump $< -s -d > $@

firmware.elf: $(FIRMWARE_OBJS) $(SYSTEM_OBJS) $(LWIP_OBJ) sections.lds
	$(TOOLCHAIN_PREFIX)gcc $(CCFLAGS) -Os -ffreestanding -nostdlib -o $@ \
		-Wl,-Bstatic,-T,sections.lds \
		$(FIRMWARE_OBJS) $(SYSTEM_OBJS) $(LWIP_OBJ) -lgcc
	chmod -x $@

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) -o $@ $<

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) $(INCLUDES) -Os -ffreestanding -nostdlib -o $@ $<

$(lwip)/obj/%.o: %.c $(LWIP_INCLUDEFILES)
	$(TOOLCHAIN_PREFIX)gcc -c $(CCFLAGS) $(INCLUDES) -Os -ffreestanding -nostdlib -o $@ $<


clean:
	rm -f  hex/*.hex *.coe *.bin *.elf.S
	rm -vrf $(FIRMWARE_OBJS) $(TEST_OBJS)
	rm -f *.o
	rm -rf $(lwip)/obj/*.o
	rm -f *.elf

copy:
	cp hex/firmware.hex ../iCore_Controller/firmware.hex

# -I$(nLWIP_DIR)/src/include/ipv4 \
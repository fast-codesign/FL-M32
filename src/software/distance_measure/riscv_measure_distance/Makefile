RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)i/bin/riscv32-unknown-elf-
GCC_WARNS  = -Werror -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings
GCC_WARNS += -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes -pedantic -ffreestanding -nostdlib
all:
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -Os --std=c99 $(GCC_WARNS) -o GenHex/system.o system.c

	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -Os --std=c99 $(GCC_WARNS) -o GenHex/main.o hello.c
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -Os --std=c99 $(GCC_WARNS) -o GenHex/irq.o irq.c
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -Os --std=c99 $(GCC_WARNS) -o GenHex/can.o can.c
	#$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -Os --std=c99 $(GCC_WARNS) -o GenHex/system.o system.c
	#$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -Os --std=c99 $(GCC_WARNS) -o GenHex/main.o hello.c
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -o GenHex/start.o start.S
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i -o GenHex/custom.o custom_ops.S
	$(TOOLCHAIN_PREFIX)gcc -Os -ffreestanding -nostdlib -o GenHex/firmware.elf         -Wl,-Bstatic,-T,GenHex/sections.lds,-Map,GenHex/firmware.map,--strip-debug         GenHex/start.o GenHex/custom.o GenHex/system.o GenHex/irq.o GenHex/can.o GenHex/main.o -lgcc
	chmod -x GenHex/firmware.elf
	$(TOOLCHAIN_PREFIX)objcopy -O binary GenHex/firmware.elf GenHex/firmware.bin
	python3 GenHex/makehex.py GenHex/firmware.bin 16384 > GenHex/firmware.hex

clean:
	rm GenHex/*.o GenHex/firmware.elf GenHex/firmware.bin GenHex/firmware.hex GenHex/firmware.map

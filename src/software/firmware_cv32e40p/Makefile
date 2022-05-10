# Copyright 2019 Clifford Wolf
# Copyright 2019 Robert Balas
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# Author: Robert Balas (balasr@iis.ee.ethz.ch)
#
# Description: Makefile for running the following examples:
#
#              - 'Hello World' (custom), command line 'make custom-vsim-run'
#              - 'Floating Point example' (custom_fp), command line 'make custom-fp-vsim-run'
#              - 'Interrupt example' (interrupt), command line 'make interrupt-vsim-run'

MAKE			= make


# riscv toolchain install path
RISCV                    ?= $PULP_RISCV_GCC_TOOLCHAIN
RISCV_EXE_PREFIX         = $(RISCV)/bin/riscv32-unknown-elf-

# GCC configuration
CUSTOM_GCC_FLAGS           =

all: genHex/firmware.hex

# Running custom programs:
# This is an example for running a Hello World in the testbench
# We link with our custom crt0.s and syscalls.c against newlib so that we can
# use the c standard library
genHex/firmware.elf: custom/hello_world.c
	$(RISCV_EXE_PREFIX)gcc -march=rv32imc -o $@ -w -Os -g -nostdlib \
		$(CUSTOM_GCC_FLAGS) \
		-T custom/link.ld \
		-static \
		custom/crt0.S \
		$^ custom/syscalls.c custom/vectors.S \
		custom/can.c custom/irq.c \
		-I $(RISCV)/riscv32-unknown-elf/include \
		-I mem_stall \
		-L $(RISCV)/riscv32-unknown-elf/lib \
		-lc -lm -lgcc

genHex/firmware.bin: genHex/firmware.elf
	chmod -x genHex/firmware.elf
	$(RISCV_EXE_PREFIX)objcopy -O binary genHex/firmware.elf genHex/firmware.bin

genHex/firmware.hex: genHex/firmware.bin
	python3 makehex.py genHex/firmware.bin 32768 > genHex/firmware.hex

clean:
	rm -rf genHex/firmware.elf genHex/firmware.bin genHex/firmware.hex

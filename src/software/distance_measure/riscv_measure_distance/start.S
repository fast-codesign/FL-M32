// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "custom_ops.S"

#define DEFAULT_IRQ_MASK_VALUE		0xfffffff9
#define TIMER_IRQ_UNMASK_VALUE		0xfffffffe
#define CTRLIRQ_INSN 1

	.section .text
	.global irq
/*	.global sieve
	.global multest
	.global hard_mul
	.global hard_mulh
	.global hard_mulhsu
	.global hard_mulhu
	.global stats*/
	.global hello

	.global reset_vec
	.type	reset_vec, @function
reset_vec:
	//* no more than 16 bytes here !
	picorv32_maskirq_insn(zero, zero)
	j	start
	.size reset_vec, . - reset_vec

/* Interrupt handler
 **********************************/
.balign 16
irq_vec:
	/* save registers */
	picorv32_setq_insn(q2, x1)	//* save x1;
	picorv32_setq_insn(q3, x2)	//* save x2;

	lui x1, %hi(irq_regs)		//* load new x1 (sp);
	addi x1, x1, %lo(irq_regs)

	picorv32_getq_insn(x2, q0)	//* load new x2 (return addr, i.e., ra);
	sw x2,   0*4(x1)			//* save ra;
	picorv32_getq_insn(x2, q2)
	sw x2,   1*4(x1)			//* save previous x1;
	picorv32_getq_insn(x2, q3)
	sw x2,   2*4(x1)			//* save previous x2;

	sw x3,   3*4(x1)			//* save previous x3-x31;
	sw x4,   4*4(x1)
	sw x5,   5*4(x1)
	sw x6,   6*4(x1)
	sw x7,   7*4(x1)
	sw x8,   8*4(x1)
	sw x9,   9*4(x1)
	sw x10, 10*4(x1)
	sw x11, 11*4(x1)
	sw x12, 12*4(x1)
	sw x13, 13*4(x1)
	sw x14, 14*4(x1)
	sw x15, 15*4(x1)
	sw x16, 16*4(x1)
	sw x17, 17*4(x1)
	sw x18, 18*4(x1)
	sw x19, 19*4(x1)
	sw x20, 20*4(x1)
	sw x21, 21*4(x1)
	sw x22, 22*4(x1)
	sw x23, 23*4(x1)
	sw x24, 24*4(x1)
	sw x25, 25*4(x1)
	sw x26, 26*4(x1)
	sw x27, 27*4(x1)
	sw x28, 28*4(x1)
	sw x29, 29*4(x1)
	sw x30, 30*4(x1)
	sw x31, 31*4(x1)

	/* call interrupt handler C function */
	lui sp, %hi(irq_stack)			//* load new sp;
	addi sp, sp, %lo(irq_stack)

	//* load arg0, arg0 = address of regs, system environment sp;
	lui a0, %hi(irq_regs)
	addi a0, a0, %lo(irq_regs)
	//* load arg1, arg1 = interrupt type
	picorv32_getq_insn(a1, q1)

	//* call to C function
	jal ra, irq

	/* restore registers */

	//* new irq_regs address returned from C code in a0, system environment sp;
	addi x1, a0, 0

	lw x2,   0*4(x1)			//* load & save ra;
	picorv32_setq_insn(q0, x2)
	lw x2,   1*4(x1)			//* load & save x1;
	picorv32_setq_insn(q1, x2)
	lw x2,   2*4(x1)			//* load & save x2;
	picorv32_setq_insn(q2, x2)

	lw x3,   3*4(x1)			//* load x3-x31;
	lw x4,   4*4(x1)
	lw x5,   5*4(x1)
	lw x6,   6*4(x1)
	lw x7,   7*4(x1)
	lw x8,   8*4(x1)
	lw x9,   9*4(x1)
	lw x10, 10*4(x1)
	lw x11, 11*4(x1)
	lw x12, 12*4(x1)
	lw x13, 13*4(x1)
	lw x14, 14*4(x1)
	lw x15, 15*4(x1)
	lw x16, 16*4(x1)
	lw x17, 17*4(x1)
	lw x18, 18*4(x1)
	lw x19, 19*4(x1)
	lw x20, 20*4(x1)
	lw x21, 21*4(x1)
	lw x22, 22*4(x1)
	lw x23, 23*4(x1)
	lw x24, 24*4(x1)
	lw x25, 25*4(x1)
	lw x26, 26*4(x1)
	lw x27, 27*4(x1)
	lw x28, 28*4(x1)
	lw x29, 29*4(x1)
	lw x30, 30*4(x1)
	lw x31, 31*4(x1)

	picorv32_getq_insn(x1, q1)	//* load x1;
	picorv32_getq_insn(x2, q2)	//* load x2;

	picorv32_retirq_insn()		//* return ra;

.balign 0x200
irq_regs:
	//* registers are saved to this memory region during interrupt handling
	//* the program counter (return pc) is saved as register 0
	.fill 32,4

	// stack for the interrupt handler
	.fill 128,4
irq_stack:

/* Main program
 **********************************/

start:
	/* zero-initialize all registers */

	addi x1, zero, 0
	addi x2, zero, 0
	addi x3, zero, 0
	addi x4, zero, 0
	addi x5, zero, 0
	addi x6, zero, 0
	addi x7, zero, 0
	addi x8, zero, 0
	addi x9, zero, 0
	addi x10, zero, 0
	addi x11, zero, 0
	addi x12, zero, 0
	addi x13, zero, 0
	addi x14, zero, 0
	addi x15, zero, 0
	addi x16, zero, 0
	addi x17, zero, 0
	addi x18, zero, 0
	addi x19, zero, 0
	addi x20, zero, 0
	addi x21, zero, 0
	addi x22, zero, 0
	addi x23, zero, 0
	addi x24, zero, 0
	addi x25, zero, 0
	addi x26, zero, 0
	addi x27, zero, 0
	addi x28, zero, 0
	addi x29, zero, 0
	addi x30, zero, 0
	addi x31, zero, 0

	/* running tests from riscv-tests */


	/* set stack pointer */
	lui sp,(64*1024)>>12

	/* set gp and tp */
	lui gp, %hi(0xdeadbeef)
	addi gp, gp, %lo(0xdeadbeef)
	addi tp, gp, 0

	// jal ra,mainRISCVshudu
	jal ra,hello


	/* print "DONE\n" */
	lui a0,0x10000000>>12
	addi a1,zero,'D'
	addi a2,zero,'O'
	addi a3,zero,'N'
	addi a4,zero,'E'
	addi a5,zero,'\n'

	sw a1,0(a0)
	sw a2,0(a0)
	sw a3,0(a0)
	sw a4,0(a0)
	sw a5,0(a0)

	li a0, 0x20000000
	li a1, 123456789
	sw a1,0(a0)

#ifdef MODIFIED_BY_LJN	
#endif
	/* trap */
	ebreak

// .global __irq_save
// 	.type	__irq_save, @function
// __irq_save:
// 	li	a0, 0
// 	picorv32_ctlirq_insn(a0, a0)
// 	ret
// 	.size	__irq_save, . - __irq_save

// 	.global __irq_restore
// 	.type	__irq_restore, @function
// __irq_restore:
// 	picorv32_ctlirq_insn(zero, a0)
// 	ret
// 	.size	__irq_restore, . - __irq_restore

#ifdef CTRLIRQ_INSN
	.global __irq_enable
	.type	__irq_enable, @function
__irq_enable:
	li	t0, 1
	picorv32_ctlirq_insn(zero, t0)
	ret
	.size	__irq_enable, . - __irq_enable

	.global __irq_disable
	.type	__irq_disable, @function
__irq_disable:
	li	t0, 0
	picorv32_ctlirq_insn(zero, t0)
	ret
	.size	__irq_disable, . - __irq_disable

// 	.global __irq_mask
// 	.type	__irq_mask, @function
// __irq_mask:
// 	picorv32_maskirq_insn(a0, a0)
// 	ret
// 	.size	__irq_mask, . - __irq_mask

// 	.global __get_irq_mask
// 	.type	__get_irq_mask, @function
// __get_irq_mask:
// 	lui	t0, %hi(DEFAULT_IRQ_MASK_VALUE)
// 	addi	t0, t0, %lo(DEFAULT_IRQ_MASK_VALUE)
// 	picorv32_maskirq_insn(a0, t0)
// 	mv	t0, a0
// 	picorv32_maskirq_insn(zero, t0)
// 	ret
// 	.size	__get_irq_mask, . - __get_irq_mask

	.global timer_enable
	.type	timer_enable, @function
timer_enable:
	//* disable irq
	li	t0, 0
	picorv32_ctlirq_insn(t0, t0)
        //* get the current irq mask value
	lui	t1, %hi(DEFAULT_IRQ_MASK_VALUE)
	addi	t1, t1, %lo(DEFAULT_IRQ_MASK_VALUE)
        picorv32_maskirq_insn(t1, t1)
	// config timer, a0 contains timer tick value
	picorv32_timer_insn(zero, a0)
	// enable timer irq
	lui	t2, %hi(TIMER_IRQ_UNMASK_VALUE)
	addi	t2, t2, %lo(TIMER_IRQ_UNMASK_VALUE)
	and	t1, t1, t2
	picorv32_maskirq_insn(zero, t1)
	picorv32_ctlirq_insn(zero, t0)
	ret
	.size timer_enable, . - timer_enable

#endif


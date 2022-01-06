/*
 *  iCore_hardware -- Hardware for TuMan RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2021 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last programed date: 2020.01.01
 *  Description: Core module of TuMan
 */

`timescale 1 ns / 1 ps

// `define PRINT_TEST

/***************************************************************
 * TuMan32
 ***************************************************************/

module decode #(
	parameter [ 0:0] 	ENABLE_COUNTERS = 1,
	parameter [ 0:0] 	ENABLE_COUNTERS64 = 0,
	parameter [ 0:0] 	ENABLE_IRQ = 1
) (
	input 					clk, resetn,
	input			[31:0]	mem_rdata_instr,

	output 	wire 	[63:0]	instr_bitmap,
	output 	wire	[15:0]	instr_type,
	output	reg 	[5:0]	decoded_rd,
	output	reg 	[5:0]	decoded_rs1,
	output	reg 	[5:0]	decoded_rs2,
	output	reg 	[31:0]	decoded_imm
);
	
	reg instr_lui, instr_auipc, instr_jal, instr_jalr;
	reg instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu;
	reg instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw;
	reg instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_slli, instr_srli, instr_srai;
	reg instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and;
	reg instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh;
	reg instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer, instr_ctlirq;
	wire instr_trap;
	
	//* decode
	wire is_slli_srli_srai;
	wire is_jalr_addi_slti_sltiu_xori_ori_andi;
	wire is_sll_srl_sra;
	wire is_lui_auipc_jal;
	wire is_lui_auipc_jal_jalr_addi_add_sub;
	wire is_slti_blt_slt;
	wire is_sltiu_bltu_sltu;
	wire is_lbu_lhu_lw;
	wire is_compare;
	wire is_rdcycle_rdcycleh_rdinstr_rdinstrh;

	reg instr_beq_bne_blt_bge_bltu_bgeu;
	reg instr_lb_lh_lw_lbu_lhu;
	reg instr_sb_sh_sw;
	reg instr_alu_reg_imm;
	reg instr_alu_reg_reg;

	//* pre decode;
	wire is_beq_bne_blt_bge_bltu_bgeu;
	wire is_lb_lh_lw_lbu_lhu;
	wire is_sb_sh_sw;
	wire is_alu_reg_imm;
	wire is_alu_reg_reg;
	wire is_jal, is_lui, is_auipc, is_jalr;

	assign is_beq_bne_blt_bge_bltu_bgeu = (mem_rdata_instr[6:0] == 7'b1100011);
	assign is_lb_lh_lw_lbu_lhu = mem_rdata_instr[6:0] == 7'b0000011;
	assign is_sb_sh_sw = mem_rdata_instr[6:0] == 7'b0100011;
	assign is_alu_reg_imm = mem_rdata_instr[6:0] == 7'b0010011;
	assign is_alu_reg_reg = mem_rdata_instr[6:0] == 7'b0110011;
	assign is_jal = mem_rdata_instr[6:0] == 7'b1101111;
	assign is_lui = mem_rdata_instr[6:0] == 7'b0110111;
	assign is_auipc = mem_rdata_instr[6:0] == 7'b0010111;
	assign is_jalr = mem_rdata_instr[6:0] == 7'b1100111 && mem_rdata_instr[14:12] == 3'b000;

	//* decode imm
	wire [31:0]	decoded_imm_j_w; 
	assign {decoded_imm_j_w[31:20], decoded_imm_j_w[10:1], decoded_imm_j_w[11], decoded_imm_j_w[19:12], decoded_imm_j_w[0] } = $signed({mem_rdata_instr[31:12], 1'b0});


	always @(posedge clk) begin
		instr_lui   <= mem_rdata_instr[6:0] == 7'b0110111;
		instr_auipc <= mem_rdata_instr[6:0] == 7'b0010111;
		instr_jal   <= mem_rdata_instr[6:0] == 7'b1101111;
		instr_jalr  <= mem_rdata_instr[6:0] == 7'b1100111 && mem_rdata_instr[14:12] == 3'b000;

		instr_beq   <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_instr[14:12] == 3'b000;
		instr_bne   <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_instr[14:12] == 3'b001;
		instr_blt   <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_instr[14:12] == 3'b100;
		instr_bge   <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_instr[14:12] == 3'b101;
		instr_bltu  <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_instr[14:12] == 3'b110;
		instr_bgeu  <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_instr[14:12] == 3'b111;

		instr_lb    <= is_lb_lh_lw_lbu_lhu && mem_rdata_instr[14:12] == 3'b000;
		instr_lh    <= is_lb_lh_lw_lbu_lhu && mem_rdata_instr[14:12] == 3'b001;
		instr_lw    <= is_lb_lh_lw_lbu_lhu && mem_rdata_instr[14:12] == 3'b010;
		instr_lbu   <= is_lb_lh_lw_lbu_lhu && mem_rdata_instr[14:12] == 3'b100;
		instr_lhu   <= is_lb_lh_lw_lbu_lhu && mem_rdata_instr[14:12] == 3'b101;

		instr_sb    <= is_sb_sh_sw && mem_rdata_instr[14:12] == 3'b000;
		instr_sh    <= is_sb_sh_sw && mem_rdata_instr[14:12] == 3'b001;
		instr_sw    <= is_sb_sh_sw && mem_rdata_instr[14:12] == 3'b010;

		instr_addi  <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b000;
		instr_slti  <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b010;
		instr_sltiu <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b011;
		instr_xori  <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b100;
		instr_ori   <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b110;
		instr_andi  <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b111;

		instr_slli  <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b001 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_srli  <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b101 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_srai  <= is_alu_reg_imm && mem_rdata_instr[14:12] == 3'b101 && mem_rdata_instr[31:25] == 7'b0100000;

		instr_add   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b000 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_sub   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b000 && mem_rdata_instr[31:25] == 7'b0100000;
		instr_sll   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b001 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_slt   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b010 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_sltu  <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b011 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_xor   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b100 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_srl   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b101 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_sra   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b101 && mem_rdata_instr[31:25] == 7'b0100000;
		instr_or    <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b110 && mem_rdata_instr[31:25] == 7'b0000000;
		instr_and   <= is_alu_reg_reg && mem_rdata_instr[14:12] == 3'b111 && mem_rdata_instr[31:25] == 7'b0000000;
		
		instr_retirq  <= mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000010 && ENABLE_IRQ;
		instr_waitirq <= mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000100 && ENABLE_IRQ;

		
		decoded_rd 	<= {1'b0,mem_rdata_instr[11:7]};
		decoded_rs1 <= {1'b0,mem_rdata_instr[19:15]};
		decoded_rs2	<= {1'b0,mem_rdata_instr[24:20]};

		if (mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000000 && ENABLE_IRQ)
			decoded_rs1[5] <= 1; // instr_getq

		if (mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000010 && ENABLE_IRQ)
			decoded_rs1 <= 32 ; // instr_retirq
			
		instr_rdcycle  <= ((mem_rdata_instr[6:0] == 7'b1110011 && mem_rdata_instr[31:12] == 'b11000000000000000010) ||
		                   (mem_rdata_instr[6:0] == 7'b1110011 && mem_rdata_instr[31:12] == 'b11000000000100000010)) && ENABLE_COUNTERS;
		instr_rdcycleh <= ((mem_rdata_instr[6:0] == 7'b1110011 && mem_rdata_instr[31:12] == 'b11001000000000000010) ||
		                   (mem_rdata_instr[6:0] == 7'b1110011 && mem_rdata_instr[31:12] == 'b11001000000100000010)) && ENABLE_COUNTERS && ENABLE_COUNTERS64;
		instr_rdinstr  <=  (mem_rdata_instr[6:0] == 7'b1110011 && mem_rdata_instr[31:12] == 'b11000000001000000010) && ENABLE_COUNTERS;
		instr_rdinstrh <=  (mem_rdata_instr[6:0] == 7'b1110011 && mem_rdata_instr[31:12] == 'b11001000001000000010) && ENABLE_COUNTERS && ENABLE_COUNTERS64;

		// instr_ecall_ebreak <= (mem_rdata_instr[6:0] == 7'b1110011 && !mem_rdata_instr[31:21] && !mem_rdata_instr[19:7]);

		instr_getq    <= mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000000 && ENABLE_IRQ;
		instr_setq    <= mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000001 && ENABLE_IRQ;
		instr_maskirq <= mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000011 && ENABLE_IRQ;
		instr_timer   <= mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000101 && ENABLE_IRQ;
		instr_ctlirq  <= mem_rdata_instr[6:0] == 7'b0001011 && mem_rdata_instr[31:25] == 7'b0000110 && ENABLE_IRQ;

		(* parallel_case *)
		case (1'b1)
			is_jal:
				decoded_imm <= decoded_imm_j_w;
			|{is_lui, is_auipc}:
				decoded_imm <= mem_rdata_instr[31:12] << 12;
			|{is_jalr, is_lb_lh_lw_lbu_lhu, is_alu_reg_imm}:
				decoded_imm <= $signed(mem_rdata_instr[31:20]);
			is_beq_bne_blt_bge_bltu_bgeu:
				decoded_imm <= $signed({mem_rdata_instr[31], mem_rdata_instr[7], mem_rdata_instr[30:25], mem_rdata_instr[11:8], 1'b0});
			is_sb_sh_sw:
				decoded_imm <= $signed({mem_rdata_instr[31:25], mem_rdata_instr[11:7]});
			default:
				decoded_imm <= 1'bx;
		endcase

		instr_beq_bne_blt_bge_bltu_bgeu <= is_beq_bne_blt_bge_bltu_bgeu;
		instr_lb_lh_lw_lbu_lhu <= is_lb_lh_lw_lbu_lhu;
		instr_sb_sh_sw <= is_sb_sh_sw;
		instr_alu_reg_imm <= is_alu_reg_imm;
		instr_alu_reg_reg <= is_alu_reg_reg;
	end

	assign is_lui_auipc_jal = |{instr_lui, instr_auipc, instr_jal};
	assign is_lui_auipc_jal_jalr_addi_add_sub = |{instr_lui, instr_auipc, instr_jal, instr_jalr, instr_addi, instr_add, instr_sub};
	assign is_slti_blt_slt = |{instr_slti, instr_blt, instr_slt};
	assign is_sltiu_bltu_sltu = |{instr_sltiu, instr_bltu, instr_sltu};
	assign is_lbu_lhu_lw = |{instr_lbu, instr_lhu, instr_lw};
	assign is_slli_srli_srai = |{instr_slli, instr_srli, instr_srai};
	assign is_jalr_addi_slti_sltiu_xori_ori_andi = |{instr_jalr, instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi};
	assign is_sll_srl_sra = |{instr_sll, instr_srl, instr_sra};
	assign is_compare = |{instr_beq_bne_blt_bge_bltu_bgeu, instr_slti, instr_slt, instr_sltiu, instr_sltu};
	assign is_rdcycle_rdcycleh_rdinstr_rdinstrh = |{instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh};

	assign instr_trap = !{instr_lui, instr_auipc, instr_jal, instr_jalr,
			instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu,
			instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw,
			instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_slli, instr_srli, instr_srai,
			instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and,
			instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh,
			instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer, instr_ctlirq};

	assign instr_bitmap = {instr_lui, instr_auipc, instr_jal, instr_jalr,
			instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu,
			instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw,
			instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_slli, instr_srli, instr_srai,
			instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and,
			instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh,
			instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer, instr_ctlirq,
			instr_trap,15'b0};

	assign instr_type = {is_slli_srli_srai,is_jalr_addi_slti_sltiu_xori_ori_andi,
			is_sll_srl_sra,is_lui_auipc_jal,is_lui_auipc_jal_jalr_addi_add_sub,
			is_slti_blt_slt,is_sltiu_bltu_sltu,is_lbu_lhu_lw,is_compare,
			instr_beq_bne_blt_bge_bltu_bgeu,instr_lb_lh_lw_lbu_lhu,instr_sb_sh_sw,
			instr_alu_reg_imm,instr_alu_reg_reg,is_rdcycle_rdcycleh_rdinstr_rdinstrh,1'b0};

endmodule

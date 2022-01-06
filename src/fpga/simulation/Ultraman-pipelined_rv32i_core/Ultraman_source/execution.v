/*
 *  iCore_hardware -- Hardware for TuMan RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2020 Junnan Li <lijunnan@nudt.edu.cn>.
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

module execution #(
	parameter [ 0:0] 	TWO_CYCLE_ALU = 0,
	parameter [ 0:0] 	BARREL_SHIFTER = 1,
	parameter [ 0:0] 	TWO_CYCLE_COMPARE = 0
) (
	input 				clk, resetn,

	output reg 	  		mem_wren,
	output reg 	  		mem_rden,
	output reg [31:0] 	mem_addr,
	output reg [31:0] 	mem_wdata,
	output reg [ 3:0] 	mem_wstrb,
	// input      [31:0] 	mem_rdata,

	//* instr
	input 		[63:0]	instr_bitmap,
	input		[15:0]	instr_type,
	//* data
	input		[31:0]	reg_op1, reg_op2,
	input		[31:0]	current_pc,
	input		[31:0]	decoded_imm,

	//* control
	input		[1:0]	do_action,

	output reg			branch_hit_o,
	output reg 	[31:0]	branch_pc_o,
	output reg 	[31:0]	reg_data_o,
	output reg 	[1:0]	mem_wordsize_o,

	input		[31:0]	reg_data_rr,
	input  		[5:0]	reg_id_rr,
	input  				reg_data_valid_rr,

	// input		[5:0]	reg_id,
	output reg 	[5:0]	reg_id_o,
	output reg 			reg_data_valid_o
);	

	//* instr
	wire instr_lui, instr_auipc, instr_jal, instr_jalr;
	wire instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu;
	wire instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw;
	wire instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_slli, instr_srli, instr_srai;
	wire instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and;
	wire instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh;
	wire instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer, instr_ctlirq;
	wire instr_trap;

	assign {instr_lui, instr_auipc, instr_jal, instr_jalr,
		instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu,
		instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw,
		instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_slli, instr_srli, instr_srai,
		instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and,
		instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh,
		instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer, instr_ctlirq,
		instr_trap} = instr_bitmap[63:15];


	wire is_slli_srli_srai,is_jalr_addi_slti_sltiu_xori_ori_andi,
		is_sll_srl_sra,is_lui_auipc_jal,is_lui_auipc_jal_jalr_addi_add_sub,
		is_slti_blt_slt,is_sltiu_bltu_sltu,is_lbu_lhu_lw,is_compare,
		is_beq_bne_blt_bge_bltu_bgeu,is_lb_lh_lw_lbu_lhu,is_sb_sh_sw,
		is_alu_reg_imm,is_alu_reg_reg,is_rdcycle_rdcycleh_rdinstr_rdinstrh;

	assign  {is_slli_srli_srai,is_jalr_addi_slti_sltiu_xori_ori_andi,
			is_sll_srl_sra,is_lui_auipc_jal,is_lui_auipc_jal_jalr_addi_add_sub,
			is_slti_blt_slt,is_sltiu_bltu_sltu,is_lbu_lhu_lw,is_compare,
			is_beq_bne_blt_bge_bltu_bgeu,is_lb_lh_lw_lbu_lhu,is_sb_sh_sw,
			is_alu_reg_imm,is_alu_reg_reg,is_rdcycle_rdcycleh_rdinstr_rdinstrh} = instr_type[15:1];

	//* alu results;
	reg [31:0] alu_add_sub;
	reg [31:0] alu_shl, alu_shr;
	reg alu_eq, alu_ltu, alu_lts;
	(* mark_debug = "true" *)reg [31:0] alu_out;
	reg alu_out_0;

	/** operation */
	generate if (TWO_CYCLE_ALU) begin
		always @(posedge clk) begin
			alu_add_sub <= instr_sub ? reg_op1 - reg_op2 : reg_op1 + reg_op2;
			alu_eq <= reg_op1 == reg_op2;
			alu_lts <= $signed(reg_op1) < $signed(reg_op2);
			alu_ltu <= reg_op1 < reg_op2;
			alu_shl <= reg_op1 << reg_op2[4:0];
			alu_shr <= $signed({instr_sra || instr_srai ? reg_op1[31] : 1'b0, reg_op1}) >>> reg_op2[4:0];
		end
	end else begin
		always @* begin
			alu_add_sub = instr_sub ? reg_op1 - reg_op2 : reg_op1 + reg_op2;
			alu_eq = reg_op1 == reg_op2;
			alu_lts = $signed(reg_op1) < $signed(reg_op2);
			alu_ltu = reg_op1 < reg_op2;
			alu_shl = reg_op1 << reg_op2[4:0];
			alu_shr = $signed({instr_sra || instr_srai ? reg_op1[31] : 1'b0, reg_op1}) >>> reg_op2[4:0];
		end
	end endgenerate

	always @* begin
		alu_out_0 = 'bx;
		(* parallel_case, full_case *)
		case (1'b1)
			instr_beq:
				alu_out_0 = alu_eq;
			instr_bne:
				alu_out_0 = !alu_eq;
			instr_bge:
				alu_out_0 = !alu_lts;
			instr_bgeu:
				alu_out_0 = !alu_ltu;
			is_slti_blt_slt && (!TWO_CYCLE_COMPARE || !{instr_beq,instr_bne,instr_bge,instr_bgeu}):
				alu_out_0 = alu_lts;
			is_sltiu_bltu_sltu && (!TWO_CYCLE_COMPARE || !{instr_beq,instr_bne,instr_bge,instr_bgeu}):
				alu_out_0 = alu_ltu;
		endcase

		alu_out = 'bx;
		(* parallel_case, full_case *)
		case (1'b1)
			is_lui_auipc_jal_jalr_addi_add_sub || is_lb_lh_lw_lbu_lhu || is_sb_sh_sw:
				alu_out = alu_add_sub;
			is_compare:
				alu_out = alu_out_0;
			instr_xori || instr_xor:
				alu_out = reg_op1 ^ reg_op2;
			instr_ori || instr_or:
				alu_out = reg_op1 | reg_op2;
			instr_andi || instr_and:
				alu_out = reg_op1 & reg_op2;
			BARREL_SHIFTER && (instr_sll || instr_slli):
				alu_out = alu_shl;
			BARREL_SHIFTER && (instr_srl || instr_srli || instr_sra || instr_srai):
				alu_out = alu_shr;
		endcase
	end

	/** EX: execution */
	reg [1:0] 	mem_wordsize; //* adapting to 8/16/32b write;
	wire 		do_exec, do_rdmem, do_wrmem;
	assign {do_rdmem, do_wrmem} = do_action;

	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			mem_wren 			<= 1'b0;
			mem_rden 			<= 1'b0;
			mem_addr 			<= 32'b0;
			branch_hit_o 		<= 1'b0; //* for jalr & branch;
			branch_pc_o			<= 32'b0;
			reg_data_o			<= 32'b0;
			reg_id_o 			<= 6'b0;
			reg_data_valid_o	<= 1'b0;
			mem_wordsize_o		<= 2'b0;
		end
		else begin
			mem_wren 			<= 1'b0;
			mem_rden 			<= 1'b0;
			branch_hit_o 		<= 1'b0;
			reg_data_valid_o	<= 1'b0;
			reg_id_o 			<= reg_id_rr;
			/** EX: execution */
			if(reg_data_valid_rr == 1'b1) begin
				reg_data_valid_o<= 1'b1;
				reg_data_o 		<= reg_data_rr;
			end
			/** RWM: Read/Write Memory */			
			else if(do_rdmem) begin
				// read mem;
				mem_addr 		<= alu_out;
				(* parallel_case, full_case *)
				case (1'b1)
					instr_lb || instr_lbu: mem_wordsize_o <= 2;
					instr_lh || instr_lhu: mem_wordsize_o <= 1;
					instr_lw: mem_wordsize_o <= 0;
				endcase
				mem_rden 		<= 1'b1;
			end
			else if(do_wrmem) begin
				// write mem;
				mem_addr 		<= reg_op1 + decoded_imm;
				(* parallel_case, full_case *)
				case (1'b1)
					instr_sb: mem_wordsize <= 2;
					instr_sh: mem_wordsize <= 1;
					instr_sw: mem_wordsize <= 0;
				endcase
				mem_wren 		<= 1'b1;
			end 
			else begin
				reg_data_valid_o<= 1'b1; 
				reg_data_o 		<= alu_out; //* write register;
				branch_pc_o 	<= current_pc + decoded_imm; //* for branch;
				if (is_beq_bne_blt_bge_bltu_bgeu) begin
					branch_hit_o 		<= alu_out_0;
					reg_data_valid_o	<= 1'b0;
				end 
				else begin
					//* for jalr
					branch_hit_o 	<= instr_jalr;
					branch_pc_o <= alu_out;
					if(instr_jalr) begin
						reg_data_o <= current_pc + 32'd4;
					end
					else
						reg_data_o <= alu_out;
				end
			end
		end
	end

	reg [31:0]	temp_reg_op2, temp_reg_op1;
	always @(posedge clk) begin
		temp_reg_op1	<= reg_op1;
		temp_reg_op2	<= reg_op2;
	end

	always @* begin
		(* full_case *)
		case (mem_wordsize)
			0: begin
				mem_wdata = temp_reg_op2;
				mem_wstrb = 4'b1111;
			end
			1: begin
				mem_wdata = {2{temp_reg_op2[15:0]}};
				mem_wstrb = mem_addr[1] ? 4'b1100 : 4'b0011;
			end
			2: begin
				mem_wdata = {4{temp_reg_op2[7:0]}};
				mem_wstrb = 4'b0001 << mem_addr[1:0];
			end
		endcase
	end

endmodule

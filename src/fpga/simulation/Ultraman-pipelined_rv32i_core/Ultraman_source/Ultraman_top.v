/*
 *  iCore_hardware -- Hardware for Ultraman RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2021 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last update date: 2022.01.06
 *  Description: Core module of Ultraman
 */

`timescale 1 ns / 1 ps

// `define PRINT_TEST

/***************************************************************
 * Ultraman_core32
 ***************************************************************/

module Ultraman_core (
	//* system clk & reset;
	input 				clk, resetn,
	input				finish,
	//* instr;
	output wire        	mem_rinst,
	output wire [31:0] 	mem_rinst_addr,
	input	   	[31:0] 	mem_rdata_instr,
	//* data;
	output wire 	  	mem_wren,
	output wire 	  	mem_rden,
	output wire [31:0] 	mem_addr,
	output wire [31:0] 	mem_wdata,
	output wire [ 3:0] 	mem_wstrb,
	input      	[31:0] 	mem_rdata
);
	//* five-stage pipeline: fetch -> decode -> read register -> execution -> load register;
	reg [9:0]	stage_enable;

	//* first-stage: instruction fetching;
	wire 		branch_hit_ex, load_realted_rr, branch_hit_rr;
	wire [31:0]	branch_pc_ex, refetch_pc_rr, branch_pc_rr;
	reg  [2:0]	temp_invalid;
	fetch fetch_inst(
		.clk(clk),
		.resetn(resetn),
		.finish(finish),
		//* instr;
		.mem_rinst(mem_rinst),
		.mem_rinst_addr(mem_rinst_addr), //* current_pc;
		//* control hazard;
		.do_refetch({branch_hit_ex&temp_invalid[0], load_realted_rr&temp_invalid[1], branch_hit_rr&temp_invalid[1]}), //* {branch_hit_ex, load_realted_rr, branch_hit_rr}
		.pc_refetch({branch_pc_ex, refetch_pc_rr, branch_pc_rr}) //* {branch_pc_ex, refetch_pc_rr, branch_pc_rr}
	);

	//* sram_wait_1;
	//* sram_wait_2;

	//* second-stage: instruction decoding;
	wire [63:0]	instr_bitmap_id;
	wire [15:0]	instr_type_id;
	wire [5:0]	decoded_rd_id, decoded_rs1_id, decoded_rs2_id;
	wire [31:0]	decoded_imm_id;
	reg  [31:0]	current_pc_id;
	decode decode_inst(
		.clk(clk),
		.resetn(resetn&mem_rinst),
		.mem_rdata_instr(mem_rdata_instr),
		//* decoded results;
		.instr_bitmap(instr_bitmap_id),
		.instr_type(instr_type_id),
		.decoded_rd(decoded_rd_id),
		.decoded_rs1(decoded_rs1_id),
		.decoded_rs2(decoded_rs2_id),
		.decoded_imm(decoded_imm_id)
	);
	always @(posedge clk) begin
		current_pc_id <= mem_rinst_addr;
	end

	//* third-stage: read register;
	wire [31:0]	reg_op1_rr, reg_op2_rr;
	wire 		reg_data_valid_rr;
	wire [31:0]	reg_data_rr;
	wire [5:0]	reg_id_rr;
	wire 		reg_data_valid_ex, reg_data_valid_lr;
	wire [31:0]	reg_data_ex, reg_data_lr;
	wire [5:0]	reg_id_ex, reg_id_lr;
	read_register readReg_inst(
		.clk(clk),
		.resetn(resetn&stage_enable[0]),
		//* decoded results;
		.instr_bitmap(instr_bitmap_id),
		.instr_type(instr_type_id),
		.decoded_rd(decoded_rd_id),
		.decoded_rs1(decoded_rs1_id),
		.decoded_rs2(decoded_rs2_id),
		.decoded_imm(decoded_imm_id),

		.current_pc(current_pc_id),
		//* operation data;
		.reg_op1_o(reg_op1_rr),
		.reg_op2_o(reg_op2_rr),

		.branch_hit_o(branch_hit_rr), 		//* for jal instr;
		.branch_pc_o(branch_pc_rr),
		.load_realted_o(load_realted_rr), 	//* for load related instr;
		.refetch_pc_o(refetch_pc_rr),
		.reg_data_o(reg_data_rr), 			//* for jal, lui, auipc;
		.reg_id_o(reg_id_rr),
		.reg_data_valid_o(reg_data_valid_rr),

		.reg_data({reg_data_lr, reg_data_ex}), 
		.reg_id({reg_id_lr,reg_id_ex}),
		.reg_data_valid({reg_data_valid_lr,reg_data_valid_ex&temp_invalid[0]})
	);
	reg [31:0]	decoded_imm_rr;
	reg [5:0]	decoded_rd_rr;
	reg [63:0]	instr_bitmap_rr;
	reg [15:0]	instr_type_rr;
	reg 		is_beq_bne_blt_bge_bltu_bgeu_rr;
	reg [31:0]	current_pc_rr;
	reg 		is_lb_lh_lw_lbu_lhu_rr, is_lbu_lhu_lw_rr, is_sb_sh_sw_rr, is_lh_rr, is_lb_rr;
	always @(posedge clk) begin
		decoded_imm_rr 	<= decoded_imm_id;
		decoded_rd_rr	<= decoded_rd_id;
		instr_bitmap_rr <= instr_bitmap_id;
		instr_type_rr	<= instr_type_id;
		is_beq_bne_blt_bge_bltu_bgeu_rr <= instr_type_id[6];
		current_pc_rr	<= current_pc_id;

		is_lb_lh_lw_lbu_lhu_rr 	<= instr_type_id[5];
		is_lbu_lhu_lw_rr		<= instr_type_id[8];
		is_sb_sh_sw_rr			<= instr_type_id[4];
		is_lh_rr		<= instr_bitmap_id[52];
		is_lb_rr		<= instr_bitmap_id[53];
	end

	//* forth-stage: ececution;
	wire 		mem_wren_w, mem_rden_w;
	assign mem_wren = mem_wren_w & temp_invalid[0];
	// assign mem_rden = mem_rden_w;
	assign mem_rden = mem_rden_w & temp_invalid[0];
	wire [1:0]	mem_wordsize_ex;
	execution exe_inst(
		.clk(clk),
		.resetn(resetn&stage_enable[1]),
		//* data;
		.mem_wren(mem_wren_w),
		.mem_rden(mem_rden_w),
		.mem_addr(mem_addr),
		.mem_wdata(mem_wdata),
		.mem_wstrb(mem_wstrb),
		// .mem_rdata(mem_rdata),
		//* decoded info;
		.instr_bitmap(instr_bitmap_rr),
		.instr_type(instr_type_rr),
		//* operation data;
		.reg_op1(reg_op1_rr),
		.reg_op2(reg_op2_rr),
		.decoded_imm(decoded_imm_rr),

		.current_pc(current_pc_rr),

		.do_action({is_lb_lh_lw_lbu_lhu_rr,is_sb_sh_sw_rr}),	//* {do_rdmem, do_wrmem}
		.branch_hit_o(branch_hit_ex), 		//* for jalr, branch instr;
		.branch_pc_o(branch_pc_ex),
		.reg_data_o(reg_data_ex),
		.mem_wordsize_o(mem_wordsize_ex),	//* for rd memory;
		
		.reg_data_rr(reg_data_rr), 			//* for jal, lui, auipc;
		.reg_id_rr(reg_id_rr),
		.reg_data_valid_rr(reg_data_valid_rr),
		// .reg_id(decoded_rd_rr),
		.reg_id_o(reg_id_ex),
		.reg_data_valid_o(reg_data_valid_ex)
	);
	// reg [1:0] 	reg_op1_2b_ex;
	reg [5:0]	decoded_rd_ex;
	reg 		is_lb_lh_lw_lbu_lhu_ex, is_lbu_lhu_lw_ex, is_lh_ex, is_lb_ex;
	always @(posedge clk) begin
		// reg_op1_2b_ex 	<= reg_op1_rr[1:0];
		decoded_rd_ex	<= decoded_rd_rr&{6{temp_invalid[1]}};
		is_lb_lh_lw_lbu_lhu_ex	<= is_lb_lh_lw_lbu_lhu_rr;
		is_lbu_lhu_lw_ex		<= is_lbu_lhu_lw_rr;
		is_lh_ex 		<= is_lh_rr;
		is_lb_ex 		<= is_lb_rr;
	end

	//* sram_wait_1;
	//* sram_wait_2;

	//* fifth-stage: load register;
	load_register loadReg_inst(
		.clk(clk),
		.resetn(resetn&stage_enable[2]),
		.mem_wordsize_i(mem_wordsize_ex),
		.reg_op1_2b_i(mem_addr[1:0]),
		.mem_rdata_i(mem_rdata),
		.load_instr({is_lbu_lhu_lw_ex, is_lh_ex, is_lb_ex}), //* {is_lbu_lhu_lw, instr_lh, instr_lb}
		.is_lb_lh_lw_lbu_lhu(is_lb_lh_lw_lbu_lhu_ex),
		.reg_id(decoded_rd_ex),
		.reg_data_valid_o(reg_data_valid_lr),	//* for load instr;
		.reg_data_o(reg_data_lr),
		.reg_id_o(reg_id_lr)
	);

	//* control, TO DO...
	// reg [4:0]	temp_invalid;
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			temp_invalid		<= 3'h7;
			stage_enable		<= 10'b0;
		end
		else begin
			temp_invalid		<= {1'b1,temp_invalid[2:1]};
			if(branch_hit_ex && temp_invalid[0]) // for jalr and branch;
				temp_invalid	<= 3'd0;
			else if(branch_hit_rr && temp_invalid[1]) // for jal;
				temp_invalid	<= 3'd1;
			else if(load_realted_rr && temp_invalid[1]) // for load_related;
				temp_invalid	<= 3'd0;
			stage_enable		<= {stage_enable[8:0],mem_rinst};
		end
	end
	// control ctl_inst(
	// 	.clk(clk),
	// 	.resetn(resetn),
	// 	.(),
	// );

endmodule

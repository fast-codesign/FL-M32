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

module load_register (
	input 				clk, resetn,

	input		[1:0]	mem_wordsize_i,
	input		[1:0]	reg_op1_2b_i,
	input     	[31:0] 	mem_rdata_i,

	input		[2:0]	load_instr,
	input				is_lb_lh_lw_lbu_lhu,
	input		[5:0]	reg_id,
	output 	reg 		reg_data_valid_o,
	output 	reg [31:0]	reg_data_o,
	output	reg [5:0]	reg_id_o
);

	//* read according to mem_wordsize
	reg 		[31:0]	mem_rdata_word;
	always @* begin
		(* full_case *)
		case (mem_wordsize_i)
			0: begin
				mem_rdata_word = mem_rdata_i;
			end
			1: begin
				case (reg_op1_2b_i[1])
					1'b0: mem_rdata_word = {16'b0, mem_rdata_i[15: 0]};
					1'b1: mem_rdata_word = {16'b0, mem_rdata_i[31:16]};
				endcase
			end
			2: begin
				case (reg_op1_2b_i)
					2'b00: mem_rdata_word = {24'b0, mem_rdata_i[ 7: 0]};
					2'b01: mem_rdata_word = {24'b0, mem_rdata_i[15: 8]};
					2'b10: mem_rdata_word = {24'b0, mem_rdata_i[23:16]};
					2'b11: mem_rdata_word = {24'b0, mem_rdata_i[31:24]};
				endcase
			end
		endcase
	end


	/** LR: load Register */
	wire latched_is_lu, latched_is_lh, latched_is_lb;
	assign {latched_is_lu, latched_is_lh, latched_is_lb} = load_instr;

	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			//* reset
			reg_data_valid_o	<= 1'b0;
			reg_data_o 			<= 32'b0;
			reg_id_o 			<= 6'b0;
		end
		else begin
			reg_data_valid_o	<= is_lb_lh_lw_lbu_lhu;
			reg_id_o 			<= reg_id;

			if(latched_is_lu|latched_is_lh|latched_is_lb) begin
				(* parallel_case, full_case *)
				case (1'b1)
					latched_is_lu: reg_data_o <= mem_rdata_word;
					latched_is_lh: reg_data_o <= $signed(mem_rdata_word[15:0]);
					latched_is_lb: reg_data_o <= $signed(mem_rdata_word[7:0]);
				endcase
			end
			else begin
				reg_data_o	<= mem_rdata_word;
			end
		end
	end



endmodule

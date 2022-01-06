/*
 *  iCore_hardware -- Hardware for TuMan RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2021 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last update date: 2021.12.07
 *  Description: instruction fetching
 */

// `define PRINT_TEST 1

`timescale 1 ns/1 ps

module fetch #(
	parameter 	[31:0] 	PROGADDR_RESET = 32'h0000_0000
) (
	input 				clk, resetn,
	input				finish,

	output reg        	mem_rinst,
	output reg [31:0] 	mem_rinst_addr,

	input		[2:0]	    do_refetch,
	input		[32*3-1:0]  pc_refetch
);

	//* IF: instruction fetch
	wire 		branch_hit_ex, load_realted_rr, branch_hit_rr;
	wire [31:0]	branch_pc_ex, refetch_pc_rr, branch_pc_rr;
	assign {branch_hit_ex, load_realted_rr, branch_hit_rr} = do_refetch;
	assign {branch_pc_ex, refetch_pc_rr, branch_pc_rr} = pc_refetch;
	reg 		unstart_tag;
	always @(posedge clk or negedge resetn) begin
		if(!resetn) begin
			unstart_tag 		<= 1'b1;
			mem_rinst 			<= 1'b0;
			mem_rinst_addr 		<= 32'b0;
		end
		else begin 
			if(unstart_tag) begin
				mem_rinst 		<= 1'b1;
				mem_rinst_addr	<= PROGADDR_RESET;
				unstart_tag 	<= 1'b0;
				`ifdef PRINT_TEST
					$display("start program");
				`endif
			end
			/** pipelined */
			else if(!finish) begin
				mem_rinst 		<= 1'b1;
				mem_rinst_addr 	<= branch_hit_ex? branch_pc_ex : 
								load_realted_rr? refetch_pc_rr: 
								branch_hit_rr? branch_pc_rr : mem_rinst_addr + 32'd4;
				
				`ifdef PRINT_TEST
					if(count_test < NUM_PRINT) begin
						$display("=============");
						$display("at IF stage: branch_hit_rr:%d, branch_hit_ex:%d, load_realted_rr:%d, mem_rinst_addr:%08x", branch_hit_rr, branch_hit_ex, load_realted_rr, branch_hit_ex? branch_pc_ex : load_realted_rr? refetch_pc_rr: branch_hit_rr? branch_pc_rr :mem_rinst_addr+32'd4);
					end
				`endif
			end
			else begin
				mem_rinst 		<= 1'b0;
			end
		end
	end
	



endmodule

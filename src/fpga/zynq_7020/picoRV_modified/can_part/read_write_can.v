/*
 *  can_hardware -- Hardware for can.
 *
 *  Please communicate with Junnan Li <lijunnan@nudt.edu.cn> when meeting any question.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.11.28.
 *  Description: read/write by key.
 */

`define DOUT_VALID_AFTER_WRITING	//* dout_32b_valid_o is valid after reading/writing

module read_write_can(
	input                       clk,           //pixel clock
	input                       rst_n,           //reset signal high active

	input         	[31:0]    	addr_32b_i,
    input                   	wren_i,
    input                   	rden_i,
    input         	[31:0]    	din_32b_i,
    (* mark_debug = "true"*)output  reg  	[31:0]    	dout_32b_o,
    (* mark_debug = "true"*)output  reg            		dout_32b_valid_o,

	(* mark_debug = "true"*)input			[7:0]		can_ad_i,
	(* mark_debug = "true"*)output reg 		[7:0]		can_ad_o,
	(* mark_debug = "true"*)output reg 					can_cs_n,
	(* mark_debug = "true"*)output reg 					can_ale,
	(* mark_debug = "true"*)output reg 					can_wr_n,
	(* mark_debug = "true"*)output reg 					can_rd_n,
	(* mark_debug = "true"*)input                       can_int_n,
	(* mark_debug = "true"*)output reg 					can_rst_n,
	(* mark_debug = "true"*)output reg 					can_ad_sel
);

reg 	[7:0]	temp_addr,temp_dataIn;
reg 	[1:0]	temp_rdWr;

reg 	[3:0]	cnt_waitClk;
reg 	[7:0]	cnt_waitClk_8b;
reg 	[3:0]	temp_action;
reg 	[4:0]	cnt_regs;
(* mark_debug = "true"*)reg 	[7:0]	data_rd;
(* mark_debug = "true"*)reg 			data_int_n;
(* mark_debug = "true"*)reg 	[3:0]	state_can;
localparam		IDLE_S			= 4'd0,
				CLK_1_S 		= 4'd1,
				CLK_2_S 		= 4'd2,
				CLK_3_S 		= 4'd3,
				CLK_4_S 		= 4'd4,
				CLK_5_S 		= 4'd5,
				CLK_9_RD_S		= 4'd6,
				CLK_9_WR_S		= 4'd7,
				CLK_10_S		= 4'd8,
				CLK_11_S		= 4'd9,
				CLK_13_S 		= 4'd10,
				CLK_14_S 		= 4'd11,
				RESET_S			= 4'd15;

//* read/write can controller's registers;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		can_ad_o			<= 8'b0;
		can_cs_n			<= 1'b1;
		can_ale				<= 1'b0;
		can_wr_n			<= 1'b1;
		can_rd_n			<= 1'b1;
		can_rst_n			<= 1'b1;
		cnt_waitClk			<= 4'b0;
		cnt_waitClk_8b		<= 8'b0;
		data_rd				<= 8'b0;
		data_int_n			<= 1'b0;
		can_ad_sel			<= 1'b0;
		temp_action			<= 4'b0;
		cnt_regs			<= 5'b0;
		dout_32b_valid_o	<= 1'b0;
		dout_32b_o 			<= 32'b0;
		state_can			<= IDLE_S;
	end
	else begin
		data_rd				<= can_ad_i;
		data_int_n			<= can_int_n;
		dout_32b_o 			<= {24'b0,can_ad_i};
		case(state_can)
			IDLE_S: begin
				dout_32b_valid_o<= 1'b0;
				//* 1) can_ad_sel to output address;
				//* 2) set can_ale to '1';
				if(wren_i|rden_i == 1'b1) begin
					can_ad_sel	<= 1'b0;
					state_can	<= CLK_1_S;
					can_ale		<= 1'b1;
				end
				// temp_addr		<= addr_32b_i[7:0];
				temp_addr		<= addr_32b_i[9:2];	//* modified by lijunnan, c program can only read by 4B;
				temp_dataIn		<= din_32b_i[7:0];
				temp_rdWr		<= {rden_i,wren_i};
			end
			CLK_1_S: begin
				//* 1) set address at 8ns;
				can_ad_o		<= temp_addr;
				state_can		<= CLK_2_S;
			end
			CLK_2_S: begin
				state_can		<= CLK_3_S;
			end
			CLK_3_S: begin
				//* 1) set ale to '0' at 24ns;
				can_ale			<= 1'b0;
				state_can		<= CLK_4_S;
			end
			CLK_4_S: begin
				//* 1) release address at 32ns;
				//* 2) set cs to '0' at 32ns;
				can_ad_o		<= 8'b0;
				can_cs_n		<= 1'b0;
				state_can		<= CLK_5_S;
			end
			CLK_5_S: begin
				//* read:
				//*		1) set rd to '0' at 40ns;
				//*		2) set sel to '1' to recv;
				//* write:
				//*		1) set wr to '0' at 40ns;
				//*		2) set data;
				if(temp_rdWr[1] == 1'b1) begin
					can_rd_n	<= 1'b0;
					can_ad_sel	<= 1'b1;
					state_can	<= CLK_9_RD_S;
				end
				else begin
					can_wr_n	<= 1'b0;
					can_ad_o	<= temp_dataIn;
					state_can	<= CLK_9_WR_S;
				end
				cnt_waitClk		<= 4'b0;
			end
			CLK_9_RD_S: begin
				cnt_waitClk		<= cnt_waitClk + 4'd1;
				if(cnt_waitClk == 4'd5) begin
					dout_32b_valid_o	<= 1'b1;
					state_can	<= CLK_13_S;
				end
			end
			CLK_9_WR_S: begin
				//* 1) release wr at 72ns (write);
				cnt_waitClk		<= cnt_waitClk + 4'd1;
				if(cnt_waitClk == 4'd3) begin
					can_wr_n	<= 1'b1;
					state_can	<= CLK_10_S;
				end
			end
			CLK_10_S: begin
				//* 1) release cs at 80ns (write);
				can_cs_n		<= 1'b1;
				state_can		<= CLK_11_S;
			end
			CLK_11_S: begin
				`ifdef DOUT_VALID_AFTER_WRITING
					//* dout_32b_valid_o is valid after writing for RISC-V
					dout_32b_valid_o<= 1'b1;
				`endif
				state_can		<= IDLE_S;
			end
			CLK_13_S: begin
				dout_32b_valid_o	<= 1'b0;
				//* 1) release rd at 104ns (read);
				//* 2) read data;
				cnt_waitClk		<= cnt_waitClk + 4'd1;
				if(cnt_waitClk == 4'd7) begin
					can_rd_n	<= 1'b1;
					state_can	<= CLK_14_S;
				end
			end
			CLK_14_S: begin
				//* 1) release cs at 112ns (read);
				//* 2) set sel to '0' to send;
				can_cs_n		<= 1'b1;
				can_ad_sel		<= 1'b0;
				state_can		<= IDLE_S;
			end
			// RESET_S: begin
			// 	cnt_waitClk_8b	<= cnt_waitClk_8b + 4'd1;
			// 	if(cnt_waitClk_8b == 8'hff) begin
			// 		can_rst_n	<= 1'b1;
			// 		state_can	<= IDLE_S;
			// 	end
			// end
			default: begin
				state_can		<= IDLE_S;
			end
		endcase
	end
end

endmodule 
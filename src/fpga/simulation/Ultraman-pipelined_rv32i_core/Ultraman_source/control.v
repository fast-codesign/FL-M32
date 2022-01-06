/*
 *  iCore_hardware -- Hardware for TuMan RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2020 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2020.01.01
 *  Description: Core module of TuMan
 */

`timescale 1 ns / 1 ps

// `define PRINT_TEST

/***************************************************************
 * TuMan32
 ***************************************************************/

module control #(
	parameter 	[ 0:0] 	ENABLE_COUNTERS = 0,
	parameter 	[ 0:0] 	ENABLE_COUNTERS64 = 1,
	parameter 	[ 0:0] 	ENABLE_REGS_DUALPORT = 1,
	parameter 	[ 0:0] 	BARREL_SHIFTER = 1,
	parameter 	[ 0:0] 	TWO_CYCLE_COMPARE = 0,
	parameter 	[ 0:0] 	TWO_CYCLE_ALU = 0,
	parameter 	[ 0:0] 	REGS_INIT_ZERO = 1,
	parameter 	[31:0] 	PROGADDR_RESET = 32'h 0000_0000
) (
	input 				clk, resetn,

	output wire        	mem_rinst,
	output wire [31:0] 	mem_rinst_addr,
	input	   	[31:0] 	mem_rdata_instr,

	output wire 	  	mem_wren,
	output wire 	  	mem_rden,
	output wire [31:0] 	mem_addr,
	output wire [31:0] 	mem_wdata,
	output wire [ 3:0] 	mem_wstrb,
	input      	[31:0] 	mem_rdata
);


	localparam 	IF 		= 0,
				ID 		= 1,
				RR 		= 2,
				EX 		= 3,
				RWM 	= 4,
				LR 		= 5,
				BUB_1	= 6,
				BUB_2	= 7,
				BUB_3	= 8,
				BUB_4	= 9,
				BUB_5	= 10,
				BUB_6	= 11,
				IF_B	= 1,
				ID_B 	= 2,
				RR_B 	= 4,
				EX_B 	= 8,
				RWM_B 	= 48,
				RM_B 	= 16,
				WM_B	= 32,
				LR_B 	= 64;


	//* fetch
	fetch fetch_inst(
		.clk(clk),
		.resetn(resetn),
		.mem_rinst(mem_rinst),
		.mem_rinst_addr(mem_rinst_addr),
		.mem_rdata_instr(mem_rdata_instr),

		.do_refetch(), //* {branch_hit_ex, load_realted_rr, branch_hit_rr}
		.pc_refetch() //* {branch_pc_ex, refetch_pc_rr, branch_pc_rr}
	);

	//* sram_wait_1;
	//* sram_wait_2;

	//* decode
	decode decode_inst(
		.clk(clk),
		.resetn(resetn),
		.instr_bitmap(instr_bitmap),
		.instr_type(instr_type),
		.decoded_rd(decoded_rd),
		.decoded_rs1(decoded_rs1),
		.decoded_rs2(decoded_rs2),
		.decoded_imm(decoded_imm)
	);

	//* read register
	read_register readReg_inst(
		.clk(clk),
		.resetn(resetn),
		
		.instr_bitmap(instr_bitmap),
		.instr_type(instr_type),
		.decoded_rd(decoded_rd),
		.decoded_rs1(decoded_rs1),
		.decoded_rs2(decoded_rs2),
		.decoded_imm(decoded_imm)
	);


	execution exe_inst(
		.clk(clk),
		.resetn(resetn),
		.mem_wren(mem_wren),
		.mem_rden(mem_rden),
		.mem_addr(mem_addr),
		.mem_wdata(mem_wdata),
		.mem_wstrb(mem_wstrb),
		.mem_rdata(mem_rdata),
		.instr_bitmap(),
		.is_beq_bne_blt_bge_bltu_bgeu(),
		.reg_op1(),
		.reg_op2(),
		.current_pc(),
		.decoded_imm(),
		.do_action(),
		.branch_hit_o(),
		.branch_pc_o(),
		.reg_data_o(),
		.mem_wordsize_o(),
		.reg_id(),
		.reg_id_o(),
		.reg_data_valid_o(),
		.(),

	);

	//* sram_wait_1;
	//* sram_wait_2;

	load_register loadReg_inst(
		.clk(clk),
		.resetn(resetn),
		.mem_wordsize_i(),
		.reg_op1_2b_i(),
		.mem_rdata_i(),
		.load_instr(), //* {is_lbu_lhu_lw, instr_lh, instr_lb}
		.is_lb_lh_lw_lbu_lhu(),
		.reg_id(),
		.reg_data_valid_o(),
		.reg_data_o(),
		.reg_id_o()
	);

	control ctl_inst(
	);

	

	reg set_mem_do_rinst;
	reg set_mem_do_rdata;
	reg set_mem_do_wdata;

	//reg latched_store;
	reg latched_stalu;
	reg latched_branch;
	reg latched_compr;
	reg latched_trace;
	reg latched_is_lu[12:0];
	reg latched_is_lh[12:0];
	reg latched_is_lb[12:0];
	(* dont_touch = "true" *)reg [regindex_bits-1:0] latched_rd[11:0];
	(* dont_touch = "true" *)reg load_reg_lr;
	reg branch_instr[11:0];

	
	(* mark_debug = "true" *)reg [31:0] alu_out, alu_out_q;
	reg alu_out_0, alu_out_0_q;
	reg alu_wait, alu_wait_2;

	reg [31:0] alu_add_sub;
	reg [31:0] alu_shl, alu_shr;
	reg alu_eq, alu_ltu, alu_lts;

	/** operation */
	generate if (TWO_CYCLE_ALU) begin
		always @(posedge clk) begin
			alu_add_sub <= instr_sub[RR] ? reg_op1 - reg_op2 : reg_op1 + reg_op2;
			alu_eq <= reg_op1 == reg_op2;
			alu_lts <= $signed(reg_op1) < $signed(reg_op2);
			alu_ltu <= reg_op1 < reg_op2;
			alu_shl <= reg_op1 << reg_op2[4:0];
			alu_shr <= $signed({instr_sra[RR] || instr_srai[RR] ? reg_op1[31] : 1'b0, reg_op1}) >>> reg_op2[4:0];
		end
	end else begin
		always @* begin
			alu_add_sub = instr_sub[RR] ? reg_op1 - reg_op2 : reg_op1 + reg_op2;
			alu_eq = reg_op1 == reg_op2;
			alu_lts = $signed(reg_op1) < $signed(reg_op2);
			alu_ltu = reg_op1 < reg_op2;
			alu_shl = reg_op1 << reg_op2[4:0];
			alu_shr = $signed({instr_sra[RR] || instr_srai[RR] ? reg_op1[31] : 1'b0, reg_op1}) >>> reg_op2[4:0];
		end
	end endgenerate

	always @* begin
		alu_out_0 = 'bx;
		(* parallel_case, full_case *)
		case (1'b1)
			instr_beq[RR]:
				alu_out_0 = alu_eq;
			instr_bne[RR]:
				alu_out_0 = !alu_eq;
			instr_bge[RR]:
				alu_out_0 = !alu_lts;
			instr_bgeu[RR]:
				alu_out_0 = !alu_ltu;
			is_slti_blt_slt[RR] && (!TWO_CYCLE_COMPARE || !{instr_beq[RR],instr_bne[RR],instr_bge[RR],instr_bgeu[RR]}):
				alu_out_0 = alu_lts;
			is_sltiu_bltu_sltu[RR] && (!TWO_CYCLE_COMPARE || !{instr_beq[RR],instr_bne[RR],instr_bge[RR],instr_bgeu[RR]}):
				alu_out_0 = alu_ltu;
		endcase

		alu_out = 'bx;
		(* parallel_case, full_case *)
		case (1'b1)
			is_lui_auipc_jal_jalr_addi_add_sub[RR] || is_lb_lh_lw_lbu_lhu[RR] || is_sb_sh_sw[RR]:
				alu_out = alu_add_sub;
			is_compare[RR]:
				alu_out = alu_out_0;
			instr_xori[RR] || instr_xor[RR]:
				alu_out = reg_op1 ^ reg_op2;
			instr_ori[RR] || instr_or[RR]:
				alu_out = reg_op1 | reg_op2;
			instr_andi[RR] || instr_and[RR]:
				alu_out = reg_op1 & reg_op2;
			BARREL_SHIFTER && (instr_sll[RR] || instr_slli[RR]):
				alu_out = alu_shl;
			BARREL_SHIFTER && (instr_srl[RR] || instr_srli[RR] || instr_sra[RR] || instr_srai[RR]):
				alu_out = alu_shr;
		endcase


	end

	



	always @(posedge clk or negedge resetn) begin
		if(!resetn) begin
			/** initial registers */
			if (REGS_INIT_ZERO) begin
				for (i = 0; i < regfile_size; i = i+1)
					cpuregs[i] = 0;
			end
			// cpuregs[0] <= 0;
			for (i = 0; i < regfile_size; i = i+1) begin
				cpuregs_lock[i] <= 4'd0;
			end
		end
		else begin 	
			for (i = 1; i < regfile_size; i = i+1) begin

				if (cpuregs_write_ex && latched_rd[EX] == i) begin
					cpuregs[i] = reg_out[EX];
					cpuregs_lock[i] <= 4'd2; //???
				end
				else if (cpuregs_write_rr && latched_rd[RR] == i && !cpuregs_write_ex) begin
					cpuregs[i] = reg_out[RR];
					cpuregs_lock[i] <= 4'd3; //???
				end
				else if (load_reg_lr && latched_rd[LR] == i) begin
					cpuregs[i] = reg_out[LR];
					if(cpuregs_lock[i] == 0)
						cpuregs_lock[i] <= cpuregs_lock[i];
					else
						cpuregs_lock[i] <= cpuregs_lock[i] - 4'd1;
				end
				else begin
					if(cpuregs_lock[i] == 0)
						cpuregs_lock[i] <= cpuregs_lock[i];
					else
						cpuregs_lock[i] <= cpuregs_lock[i] - 4'd1;
				end
			end
			// for (i = 0; i < regfile_size; i = i+1) begin
			// 	if(cpuregs_lock[i] == 0)
			// 		cpuregs_lock[i] <= cpuregs_lock[i];
			// 	else
			// 		cpuregs_lock[i] <= cpuregs_lock[i] - 4'd1;
			// end
// 			if (resetn && load_reg_lr && latched_rd[LR]) begin				
// 				if(cpuregs_lock[latched_rd[LR]] == 0) begin
// 					cpuregs[latched_rd[LR]] = reg_out[LR];
// 				end
// `ifdef PRINT_TEST_1
// 				if(count_test < NUM_PRINT)
// 					$display("latched_rd: %d, value: %08x", latched_rd[LR], reg_out[LR]);
// `endif
// 			end
// 			if (resetn && cpuregs_write_rr && latched_rd[RR] && !cpuregs_write_ex) begin
// 				if(cpuregs_lock[latched_rd[RR]] == 0) begin
// 					cpuregs[latched_rd[RR]] = reg_out[RR];
// 					cpuregs_lock[latched_rd[RR]] <= 4'd3; //???
// `ifdef PRINT_TEST_1
// 					if(count_test < NUM_PRINT)
// 						$display("ID, latched_rd: %d, value: %08x", latched_rd[ID], reg_out[ID]);
// `endif
// 				end
// 			end
// 			if (resetn && cpuregs_write_ex && latched_rd[EX]) begin
// 				if(cpuregs_lock[latched_rd[EX]] == 0) begin
// 					cpuregs[latched_rd[EX]] = reg_out[EX];
// 					cpuregs_lock[latched_rd[EX]] <= 4'd2; //???
// `ifdef PRINT_TEST_1
// 					if(count_test < NUM_PRINT)
// 						$display("EX, latched_rd: %d, value: %08x", latched_rd[EX], reg_out[EX]);
// `endif
// 				end
// 			end
		end
	end

	// compare decoded_rs[IF] with latched_rd[BUB_5, BUB_4, EX, RR, ID], and get bitmap;
	//	the ID is highest priority, i.e.,bitmap[4];
	reg [4:0]	bitmap_rs1, bitmap_rs2;	
	always @(posedge clk) begin
		if(decoded_rs1[IF] == latched_rd[ID])			bitmap_rs1 <= 5'h10;
		else if(decoded_rs1[IF] == latched_rd[RR])		bitmap_rs1 <= 5'h8;
		else if(decoded_rs1[IF] == latched_rd[EX])		bitmap_rs1 <= 5'h4;
		else if(decoded_rs1[IF] == latched_rd[BUB_4])	bitmap_rs1 <= 5'h2;
		else if(decoded_rs1[IF] == latched_rd[BUB_5])	bitmap_rs1 <= 5'h1;
		else											bitmap_rs1 <= 5'h0;

		if(decoded_rs2[IF] == latched_rd[ID])			bitmap_rs2 <= 5'h10;
		else if(decoded_rs2[IF] == latched_rd[RR])		bitmap_rs2 <= 5'h8;
		else if(decoded_rs2[IF] == latched_rd[EX])		bitmap_rs2 <= 5'h4;
		else if(decoded_rs2[IF] == latched_rd[BUB_4])	bitmap_rs2 <= 5'h2;
		else if(decoded_rs2[IF] == latched_rd[BUB_5])	bitmap_rs2 <= 5'h1;
		else											bitmap_rs2 <= 5'h0;
	end

	(* mark_debug = "true" *)reg 	usingLastValue_rs1_tag, usingLastValue_rs2_tag;
	// data-harzard;
	always @* begin
		usingLastValue_rs1_tag = 1'b0;
		if(decoded_rs1[ID]) begin
			(* parallel_case *)
			case(1)
				// bitmap_rs1[4]&cpuregs_write[RR]: 	cpuregs_rs1 = reg_out_r[RR];
				bitmap_rs1[4]&cpuregs_write[RR]: begin
					usingLastValue_rs1_tag = 1'b1;
					cpuregs_rs1 = 32'b0;
				end
				bitmap_rs1[3]&cpuregs_write[EX]: 	cpuregs_rs1 = reg_out_r[EX];
				bitmap_rs1[2]&cpuregs_write[BUB_4]: cpuregs_rs1 = reg_out_r[BUB_4];
				bitmap_rs1[1]&cpuregs_write[BUB_5]: cpuregs_rs1 = reg_out_r[BUB_5];
				bitmap_rs1[0]&load_reg_lr: 			cpuregs_rs1 = reg_out[LR];
				default: 							cpuregs_rs1 = cpuregs[decoded_rs1[ID]];
			endcase
		end
		else begin
			cpuregs_rs1 = 0;
		end
	end

	always @* begin	
		usingLastValue_rs2_tag = 1'b0;
		if(decoded_rs2[ID]) begin
			(* parallel_case *)
			case(1)
				// bitmap_rs2[4]&cpuregs_write[RR]: 	cpuregs_rs2 = reg_out_r[RR];
				bitmap_rs2[4]&cpuregs_write[RR]: begin
					usingLastValue_rs2_tag = 1'b1;
					cpuregs_rs2 = 32'b0;
				end 
				bitmap_rs2[3]&cpuregs_write[EX]: 	cpuregs_rs2 = reg_out_r[EX];
				bitmap_rs2[2]&cpuregs_write[BUB_4]: cpuregs_rs2 = reg_out_r[BUB_4];
				bitmap_rs2[1]&cpuregs_write[BUB_5]: cpuregs_rs2 = reg_out_r[BUB_5];
				bitmap_rs2[0]&load_reg_lr: 			cpuregs_rs2 = reg_out[LR];
				default: 							cpuregs_rs2 = cpuregs[decoded_rs2[ID]];
			endcase
		end
		else begin
			cpuregs_rs2 = 0;
		end
	end

	// always @* begin
	// 	decoded_rs = 'bx;
	// 	if (ENABLE_REGS_DUALPORT) begin
	// 		if(decoded_rs1[ID]) begin
	// 			cpuregs_rs1 = cpuregs[decoded_rs1[ID]];
	// 			if(decoded_rs1[ID] == latched_rd[LR] 	&& load_reg_lr) 		 cpuregs_rs1 = reg_out[LR];
	// 			if(decoded_rs1[ID] == latched_rd[BUB_5] && cpuregs_write[BUB_5]) cpuregs_rs1 = reg_out_r[BUB_5];
	// 			if(decoded_rs1[ID] == latched_rd[BUB_4] && cpuregs_write[BUB_4]) cpuregs_rs1 = reg_out_r[BUB_4];
	// 			if(decoded_rs1[ID] == latched_rd[EX] 	&& cpuregs_write[EX])	 cpuregs_rs1 = reg_out_r[EX];
	// 			if(decoded_rs1[ID] == latched_rd[RR] 	&& cpuregs_write[RR])	 cpuregs_rs1 = reg_out_r[RR];
	// 		end
	// 		else begin
	// 			cpuregs_rs1 = 0;
	// 		end
	// 		if(decoded_rs2[ID]) begin
	// 			cpuregs_rs2 = cpuregs[decoded_rs2[ID]];
	// 			if(decoded_rs2[ID] == latched_rd[LR] 	&& load_reg_lr) 		 cpuregs_rs2 = reg_out[LR];
	// 			if(decoded_rs2[ID] == latched_rd[BUB_5] && cpuregs_write[BUB_5]) cpuregs_rs2 = reg_out_r[BUB_5];
	// 			if(decoded_rs2[ID] == latched_rd[BUB_4] && cpuregs_write[BUB_4]) cpuregs_rs2 = reg_out_r[BUB_4];
	// 			if(decoded_rs2[ID] == latched_rd[EX] 	&& cpuregs_write[EX])	 cpuregs_rs2 = reg_out_r[EX];
	// 			if(decoded_rs2[ID] == latched_rd[RR] 	&& cpuregs_write[RR])	 cpuregs_rs2 = reg_out_r[RR];
	// 		end
	// 		else begin
	// 			cpuregs_rs2 = 0;
	// 		end
	// 	end 
	// end

	reg load_realted_rs1_tag, load_realted_rs2_tag;

	always @* begin
		//load_realted_tag = 1'b0;
		if( (decoded_rs1[ID] == latched_rd[RR]  	&& is_lb_lh_lw_lbu_lhu[RR]) || 
			(decoded_rs1[ID] == latched_rd[EX]  	&& is_lb_lh_lw_lbu_lhu[EX]) || 
			(decoded_rs1[ID] == latched_rd[BUB_4]  	&& is_lb_lh_lw_lbu_lhu[BUB_4]) ||
			(decoded_rs1[ID] == latched_rd[BUB_5]  	&& is_lb_lh_lw_lbu_lhu[BUB_5])) begin
				load_realted_rs1_tag = 1'b1;
		end
		else begin
			load_realted_rs1_tag = 1'b0;
		end
		if	((decoded_rs2[ID] == latched_rd[RR]  	&& is_lb_lh_lw_lbu_lhu[RR]) || 
			(decoded_rs2[ID] == latched_rd[EX]  	&& is_lb_lh_lw_lbu_lhu[EX]) || 
			(decoded_rs2[ID] == latched_rd[BUB_4]  	&& is_lb_lh_lw_lbu_lhu[BUB_4]) ||
			(decoded_rs2[ID] == latched_rd[BUB_5]  	&& is_lb_lh_lw_lbu_lhu[BUB_5])) begin
				load_realted_rs2_tag = 1'b1;
		end
		else begin
			load_realted_rs2_tag = 1'b0;
		end
	end
	
	
	/** calculate clk
	*	IF:			mem_rinst<= 1;
	*	mem_rinst:  wait read instr_sram (1st clk), current_pc[IF];
	*	clk[0]:		wait read instr_sram (2nd clk), current_pc[BUB_1];
	*	clk[1]:		read instr_sram, current_pc[BUB_2];
	*	clk[2]:		ID, current_pc[BUB_3];
	*	clk[3]:		RR, current_pc[ID];
	*	clk[4]:		EX, RWM, mem_rctx<= 1;
	*	clk[5]:		wait read data_sram (1st clk), [EX];
	*	clk[6]:		wait read data_sram (2nd clk), [BUB_4];
	*	clk[7]:		read instr_sram, i.e, LR, [BUB_5];
	*	clk[8]:		
	*	clk[9]:	
	*	clk[10]:
	*/

`ifdef PRINT_TEST
	reg [9:0] count_test;
	always @(posedge clk) begin
		/**read instr*/
		if(!resetn) begin
			count_test <= 10'd0;
		end
		else if((cpuregs_write_ex || cpuregs_write_rr || load_reg_lr)&&(count_test < NUM_PRINT)) begin
			count_test <= count_test + 10'd1;
			$display("count_test is %d", count_test);
			$display("****************registers*******************");
			for(i = 0; i<32; i=i+1)
				$display("reg[%d]: %08x",i, cpuregs[i]);
			$display("****************registers*******************");
		end
		// if(clk_temp[0] == 1'b1 && count_test < NUM_PRINT) begin
		// 	$display("stage clk_temp[0]: current_pc[BUB_1] is %08x", current_pc[BUB_1]);
		// end
		// /**get instr from ram*/
		if(count_test < NUM_PRINT)
			$display("mem_rinst is %d", mem_rinst);
		if(clk_temp[1] && count_test < NUM_PRINT) begin
			$display("stage clk_temp[1]: current_pc[BUB_2] is %08x, instr is %08x", current_pc[BUB_2], mem_rdata_instr);
		end
		// if(next_stage[RR]&RM_B && clk_temp[4] && !branch_hit_ex && !instr_trap && count_test < NUM_PRINT)
		// 	$display("reg_op1_2b[EX] is %d", alu_out[1:0]);
		// if(next_stage[BUB_5] == LR_B && clk_temp[7] && count_test < NUM_PRINT)
		// 	$display("mem_wordsize[BUB_5] is %d, reg_op1_2b[BUB_5] is %d, mem_rdata is %08x, mem_rdata_word is %08x", mem_wordsize[BUB_5], reg_op1_2b[BUB_5], mem_rdata, mem_rdata_word);
		// if(count_test < NUM_PRINT) begin
		// 	$display("is_lb_lh_lw_lbu_lhu[RR] is %d, latched_rd[RR] is %d", is_lb_lh_lw_lbu_lhu[RR], latched_rd[RR]);
		// 	$display("is_lb_lh_lw_lbu_lhu[EX] is %d, latched_rd[EX] is %d", is_lb_lh_lw_lbu_lhu[EX], latched_rd[EX]);
		// 	$display("is_lb_lh_lw_lbu_lhu[BUB_4] is %d, latched_rd[BUB_4] is %d", is_lb_lh_lw_lbu_lhu[BUB_4], latched_rd[BUB_4]);
		// 	$display("is_lb_lh_lw_lbu_lhu[BUB_5] is %d, latched_rd[BUB_5] is %d", is_lb_lh_lw_lbu_lhu[BUB_5], latched_rd[BUB_5]);
		// end
		// if(count_test < NUM_PRINT) begin
		// 	$display("latched_rd[RR] is %d, reg_out_r[RR] is %08x, cpuregs_write[RR] is %d, is_sb_sh_sw[RR] is %d", latched_rd[RR], reg_out_r[RR], cpuregs_write[RR], is_sb_sh_sw[RR]);
		// 	$display("latched_rd[EX] is %d, reg_out_r[EX] is %08x, cpuregs_write[EX] is %d", latched_rd[EX], reg_out_r[EX], cpuregs_write[EX]);
		// 	$display("latched_rd[BUB_4] is %d, reg_out_r[BUB_4] is %08x, cpuregs_write[BUB_4] is %d", latched_rd[BUB_4], reg_out_r[BUB_4], cpuregs_write[BUB_4]);
		// 	$display("latched_rd[BUB_5] is %d, reg_out_r[BUB_5] is %08x, cpuregs_write[RR] is %d", latched_rd[BUB_5], reg_out_r[BUB_5], cpuregs_write[BUB_5]);
		// 	$display("latched_rd[LR] is %d, reg_out[LR] is %08x, load_reg_lr is %d", latched_rd[LR], reg_out[LR], load_reg_lr);
		// end
		// if(count_test < NUM_PRINT) begin
		// 	$display("next_stage[ID] is %d, next_stage[RR] is %d, next_stage[EX] is %d", next_stage[ID], next_stage[RR], next_stage[EX]);
		// end
		// if(cpuregs_write[BUB_4] && count_test < NUM_PRINT) begin
		// 	$display("latched_rd[BUB_4] is %d, reg_out_r[BUB_5] is %08x, cpuregs_rs1 is %08x", latched_rd[BUB_4], reg_out[BUB_4], cpuregs_rs1);
		// end
		// if(mem_wren && count_test < NUM_PRINT) begin
		// 	$display("mem_wren, mem_addr is %08x, mem_wstrb is %x, mem_wdata is %08x",mem_addr, mem_wstrb, mem_wdata);
		// end
		// if(mem_rden && count_test < NUM_PRINT) begin
		// 	$display("mem_addr is %08x",mem_addr);
		// end
		// if(clk_temp[3] && count_test < NUM_PRINT) begin
		// 	$display("instr_lbu[ID] is %d, instr_lhu[ID] is %d, instr_lw[ID] is %d", instr_lbu[ID], instr_lhu[ID], instr_lw[ID]);
		// end
		/** at RR stage */
		if(clk_temp[3] &&(count_test < NUM_PRINT)) begin
			if (instr_lui[ID])      $display("instr_lui");
			if (instr_auipc[ID])    $display("instr_auipc");
			if (instr_jal[ID])      $display("instr_jal");
			if (instr_jalr[ID])     $display("instr_jalr");

			if (instr_beq[ID])      $display("instr_beq");
			if (instr_bne[ID])      $display("instr_bne");
			if (instr_blt[ID])      $display("instr_blt");
			if (instr_bge[ID])      $display("instr_bge");
			if (instr_bltu[ID])     $display("instr_bltu");
			if (instr_bgeu[ID])     $display("instr_bgeu");

			if (instr_lb[ID])       $display("instr_lb");
			if (instr_lh[ID])       $display("instr_lh");
			if (instr_lw[ID])       $display("instr_lw");
			if (instr_lbu[ID])      $display("instr_lbu");
			if (instr_lhu[ID])      $display("instr_lhu");
			if (instr_sb[ID])       $display("instr_sb");
			if (instr_sh[ID])       $display("instr_sh");
			if (instr_sw[ID])       $display("instr_sw");

			if (instr_addi[ID])     $display("instr_addi");
			if (instr_slti[ID])     $display("instr_slti");
			if (instr_sltiu[ID])    $display("instr_sltiu");
			if (instr_xori[ID])     $display("instr_xori");
			if (instr_ori[ID])      $display("instr_ori");
			if (instr_andi[ID])     $display("instr_andi");
			if (instr_slli[ID])     $display("instr_slli");
			if (instr_srli[ID])     $display("instr_srli");
			if (instr_srai[ID])     $display("instr_srai");

			if (instr_add[ID])      $display("instr_add");
			if (instr_sub[ID])      $display("instr_sub");
			if (instr_sll[ID])      $display("instr_sll");
			if (instr_slt[ID])      $display("instr_slt");
			if (instr_sltu[ID])     $display("instr_sltu");
			if (instr_xor[ID])      $display("instr_xor");
			if (instr_srl[ID])      $display("instr_srl");
			if (instr_sra[ID])      $display("instr_sra");
			if (instr_or[ID])       $display("instr_or");
			if (instr_and[ID])      $display("instr_and");

			if (instr_ecall_ebreak[ID])  $display("instr_ecall_ebreak");

			$display("current_pc is %08x", current_pc[ID]);
			$display("decoded_imm is %08x", decoded_imm[ID]);
			$display("stage RR: decoded_rs1[ID] is %d, cpuregs[decoded_rs1[ID]] is %x", decoded_rs1[ID], cpuregs_rs1);
			$display("stage RR: decoded_rs2[ID] is %d, cpuregs[decoded_rs2[ID]] is %x", decoded_rs2[ID], cpuregs_rs2);
			$display("stage RR: decoded_rd[ID] is %d", latched_rd[ID]);
		end
		/** EX stage */
			// if(clk_temp[4]&& (count_test < NUM_PRINT)) begin
			// 	// $display("is_lbu_lhu_lw[RR] is %d",is_lbu_lhu_lw[RR]);
			// 	$display("stage EX: reg_op1 is %08x, reg_op2 is %08x", reg_op1, reg_op2);
			// 	$display("alu_add_sub is %08x, alu_out_0 is %d", alu_add_sub, alu_out_0);
			// end
			// if(clk_temp[7]&& (count_test < NUM_PRINT)) begin
			// 	$display("mem_rdata is %08x",mem_rdata);
			// end
			// if(clk_temp[7]&& count_test < NUM_PRINT)
			// 	$display("reg_out[BUB_5] is %08x, latched_is_lu[BUB_5] is %d, latched_is_lb[BUB_5] is %d, latched_is_lh[BUB_5] is %d",reg_out[BUB_5], latched_is_lu[BUB_5], latched_is_lb[BUB_5], latched_is_lh[BUB_5]);
		// if(count_test < 10'd10) begin
		// 	for(i=0; i<5; i=i+1)
		// 		$display("clk_temp[%d]: %d",i, clk_temp[i]);
		// end
		// if(clk_temp[8]) begin
		// 	$display("stage LR: load_reg_lr is %d, reg_out[LR] is %08x", load_reg_lr, reg_out[LR]);
		// 	$display("mem_rdata: %08x, mem_rdata_word: %08x", mem_rdata, mem_rdata_word);
		// 	//$display("latched_is_lb[BUB_5] is %d", latched_is_lb[BUB_5]);
		// 	$display("mem_wordsize[BUB_5] is %d, reg_op1_2b[BUB_5] is %d",mem_wordsize[BUB_5], reg_op1_2b[BUB_5]);
		// end
		// if(branch_hit_id) begin
		// 	$display("Jal, addr is %08x", branch_pc_id);
		// end
		// if(pre_instr_finished_lr) begin
		// 	$display("finish one instr");
		// end
		// if(branch_hit_ex) begin
		// 	$display("hit branch, branch_pc_ex is %08x", branch_pc_ex);
		// end
		// if(branch_hit_id) begin
		// 	$display("hit branch, branch_pc_id is %08x", branch_pc_id);
		// end
		if((mem_rden||mem_wren)&& count_test < NUM_PRINT) begin
			$display("mem_rden: %d, mem_addr: %08x", mem_rden, mem_addr);
			$display("mem_wren: %d, mem_addr: %08x, mem_wdata: %08x, mem_wstrb: %x",mem_wren, mem_addr, mem_wdata, mem_wstrb);
		end
		// if(instr_ecall_ebreak[ID]) begin
		// 	$display("instr_ecall_ebreak[ID] is %d", instr_ecall_ebreak[ID]);
		// 	$finish;
		// end
		if(instr_trap && count_test < NUM_PRINT) begin
			$display("trap instr");
			// $finish;
		end
	end
`endif

				
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			for(i=0; i<11; i=i+1)
				clk_temp[i] <= 1'b0;
		end
		else begin
			clk_temp[0] <= mem_rinst;
			for(i=1; i<11; i=i+1)
				clk_temp[i] <= clk_temp[i-1];
			if(branch_hit_rr) begin
				clk_temp[0] <= 1'b0;
				clk_temp[1] <= 1'b0;
				clk_temp[2] <= 1'b0;
				clk_temp[3] <= 1'b0;
			end
			if(load_realted_rr) begin
				clk_temp[0] <= 1'b0;
				clk_temp[1] <= 1'b0;
				clk_temp[2] <= 1'b0;
				clk_temp[3] <= 1'b0;
			end
			if(branch_hit_ex) begin
				clk_temp[0] <= 1'b0;
				clk_temp[1] <= 1'b0;
				clk_temp[2] <= 1'b0;
				clk_temp[3] <= 1'b0;
				clk_temp[4] <= 1'b0;
			end
			current_pc[BUB_1] 	<= mem_rinst_addr;
			current_pc[BUB_2] 	<= current_pc[BUB_1];
			current_pc[BUB_3] 	<= current_pc[BUB_2];
			current_pc[ID] 		<= current_pc[BUB_3];
			current_pc[RR] 		<= current_pc[ID];
			decoded_imm[RR] 	<= decoded_imm[ID];
			decoded_imm[EX] 	<= decoded_imm[RR];
			decoded_imm[RWM] 	<= decoded_imm[EX];
			latched_rd[ID] 		<= decoded_rd[IF];
			latched_rd[RR] 		<= latched_rd[ID];
			latched_rd[EX] 		<= latched_rd[RR];
			latched_rd[BUB_4]	<= latched_rd[EX];
			latched_rd[BUB_5]	<= latched_rd[BUB_4];
			//latched_rd[BUB_6]	<= decoded_rd[BUB_5];
			latched_rd[LR] 		<= latched_rd[BUB_5];
			// reg_out[BUB_4] 		<= reg_out[EX];
			// reg_out[BUB_5] 		<= reg_out[BUB_4];
			reg_out_r[EX] 		<= reg_out_r[RR];
			reg_out_r[BUB_4] 	<= reg_out_r[EX];
			reg_out_r[BUB_5] 	<= reg_out_r[BUB_4];
			cpuregs_write[EX]	<= cpuregs_write[RR];
			cpuregs_write[BUB_4]<= cpuregs_write[EX];
			cpuregs_write[BUB_5]<= cpuregs_write[BUB_4];
			cpuregs_write[LR]	<= cpuregs_write[BUB_5];
			//reg_out[BUB_6] 		<= reg_out[BUB_5];

			reg_op1_2b[EX] 		<= alu_out[1:0];
			reg_op1_2b[BUB_4] 	<= reg_op1_2b[EX];
			reg_op1_2b[BUB_5] 	<= reg_op1_2b[BUB_4];
			//reg_op1_2b[BUB_6] <= reg_op1_2b[BUB_5];
			mem_wordsize[BUB_4] <= mem_wordsize[RWM];
			mem_wordsize[BUB_5] <= mem_wordsize[BUB_4];
			//mem_wordsize[BUB_6] 	<= mem_wordsize[BUB_5];
			// latched_is_lu[BUB_4] 	<= latched_is_lu[EX];
			// latched_is_lu[BUB_5] 	<= latched_is_lu[BUB_4];
			//latched_is_lu[BUB_6] 	<= latched_is_lu[BUB_5];
			instr_finished[BUB_4] 	<= instr_finished[EX];
			instr_finished[BUB_5] 	<= instr_finished[BUB_4];
			//instr_finished[BUB_6] 	<= instr_finished[BUB_5];

			branch_instr[BUB_4] <= branch_instr[EX];
			branch_instr[BUB_5] <= branch_instr[BUB_4];

			{latched_is_lu[BUB_4],latched_is_lh[BUB_4],latched_is_lb[BUB_4]} <= {latched_is_lu[EX],
				latched_is_lh[EX],latched_is_lb[EX]};
			{latched_is_lu[BUB_5],latched_is_lh[BUB_5],latched_is_lb[BUB_5]} <= {latched_is_lu[BUB_4],latched_is_lh[BUB_4],latched_is_lb[BUB_4]};
			{instr_sb[RR],instr_sh[RR],instr_sw[RR]} <= {instr_sb[ID],instr_sh[ID],instr_sw[ID]};
		end
	end 

	/**instr_ecall_ebreak*/
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			finish <= 1'b0;
		end
		else begin
			//if(instr_ecall_ebreak[ID]||instr_trap)
			if(instr_ecall_ebreak[ID]) begin
				finish <= 1'b1;
				// $display("finish");
				// $finish;
			end
			else 
				finish <= finish;
		end
	end

	/**IF: instruction fetch*/
	reg unstart_tag;
	always @(posedge clk or negedge resetn) begin
		if(!resetn) begin
			unstart_tag <= 1'b1;
			mem_rinst <= 1'b0;
			mem_rinst_addr <= 32'b0;
		end
		else begin 
			if(unstart_tag) begin
				mem_rinst <= 1'b1;
				mem_rinst_addr <= PROGADDR_RESET;
				unstart_tag <= 1'b0;
`ifdef PRINT_TEST
				$display("start program");
`endif
			end
			/** pipelined */
			else if(!finish) begin
				mem_rinst <= 1;
				mem_rinst_addr <= branch_hit_ex? branch_pc_ex : load_realted_rr? refetch_pc_rr: branch_hit_rr? branch_pc_rr :mem_rinst_addr+32'd4;
`ifdef PRINT_TEST
				if(count_test < NUM_PRINT) begin
					$display("=============");
					$display("at IF stage: branch_hit_rr:%d, branch_hit_ex:%d, load_realted_rr:%d, mem_rinst_addr:%08x", branch_hit_rr, branch_hit_ex, load_realted_rr, branch_hit_ex? branch_pc_ex : load_realted_rr? refetch_pc_rr: branch_hit_rr? branch_pc_rr :mem_rinst_addr+32'd4);
				end
`endif
			end
			else begin
				mem_rinst <= 1'b0;
			end
		end
	end
	always @* begin
		current_pc[IF] = mem_rinst_addr;
	end
	
	/**ID: instruction decode*/
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			next_stage[ID] <= 0;
		end
		else begin
			//next_stage[ID] <= 0;
			if(clk_temp[2]) begin 
				next_stage[ID] <= RR_B;
			end
			else begin
				next_stage[ID] <= 0;
			end
		end
	end

	/** RR: read register */
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			next_stage[RR] <= 0;
			load_realted_rr <= 1'b0;
		end
		else begin
			trace_data[3:0]	<= 4'd0;
			//next_stage[RR] <= 0;
			//cpuregs_write[RR] = 0;
			load_realted_rr <= 1'b0;
			branch_hit_rr <= 1'b0;
			cpuregs_write_rr <= 1'b0;
			branch_instr[RR] <= 1'b0;
			if(next_stage[ID] == RR_B && clk_temp[3] && !load_realted_rr && !branch_hit_rr && !branch_hit_ex) begin 
				reg_op1 <= 'bx;
				reg_op2 <= 'bx;

				(* parallel_case *)
				case (1'b1)					
					ENABLE_COUNTERS && is_rdcycle_rdcycleh_rdinstr_rdinstrh: begin
						(* parallel_case, full_case *)
						case (1'b1)
							instr_rdcycle[ID]:
								reg_out[RR] <= count_cycle[31:0];
							instr_rdcycleh[ID] && ENABLE_COUNTERS64:
								reg_out[RR] <= count_cycle[63:32];
							instr_rdinstr[ID]:
								reg_out[RR] <= count_instr[31:0];
							instr_rdinstrh[ID] && ENABLE_COUNTERS64:
								reg_out[RR] <= count_instr[63:32];
						endcase
						next_stage[RR] <= LR_B;
trace_data[3:0]	<= 4'd1;
					end
					is_lui_auipc_jal[ID]: begin
						reg_op1 <= instr_lui[ID] ? 0 : current_pc[ID];
						reg_op2 <= instr_jal[ID] ? 32'd4 : decoded_imm[ID];
						if(instr_jal[ID]) begin
							branch_pc_rr <= current_pc[ID] + decoded_imm[ID];
							branch_hit_rr <= 1'b1;
							cpuregs_write_rr <= 1'b1;
							branch_instr[RR] <= 1'b1;
							reg_out[RR] <= current_pc[ID] + 32'd4;
							next_stage[RR] <= 0;
trace_data[3:0]	<= 4'd2;
						end
						else begin
							branch_hit_rr <= 1'b0;
							cpuregs_write_rr <= 1'b0;
							branch_instr[RR] <= 1'b0;
							next_stage[RR] <= EX_B;
trace_data[3:0]	<= 4'd3;
						end
					end
					is_lb_lh_lw_lbu_lhu[ID]: begin
						// reg_op1 <= cpuregs_rs1;
						reg_op1 <= (usingLastValue_rs1_tag)? reg_out_r[RR]: cpuregs_rs1;
						reg_op2 <= decoded_imm[ID];
						next_stage[RR] <= RM_B;
trace_data[3:0]	<= 4'd4;
						if(load_realted_rs1_tag) begin
							refetch_pc_rr <= current_pc[ID];
							load_realted_rr <= 1'b1;
							next_stage[RR] <= 0;
trace_data[3:0]	<= 4'd5;
						end
					end
					// is_slli_srli_srai && !BARREL_SHIFTER: begin
					// 	reg_op1 <= cpuregs_rs1;
					// 	reg_sh <= decoded_rs2;
					// 	cpu_state <= cpu_state_shift;
					// end
					is_jalr_addi_slti_sltiu_xori_ori_andi[ID], is_slli_srli_srai[ID] && BARREL_SHIFTER: begin
						// reg_op1 <= cpuregs_rs1;
						reg_op1 <= (usingLastValue_rs1_tag)? reg_out_r[RR]: cpuregs_rs1;
						reg_op2 <= is_slli_srli_srai[ID]? decoded_rs2[ID] :decoded_imm[ID];
						next_stage[RR] <= EX_B;
trace_data[3:0]	<= 4'd6;
						if(load_realted_rs1_tag) begin
							refetch_pc_rr <= current_pc[ID];
							load_realted_rr <= 1'b1;
							next_stage[RR] <= 0;
trace_data[3:0]	<= 4'd7;
						end
					end
					default: begin
						// reg_op1 <= cpuregs_rs1;
						reg_op1 <= (usingLastValue_rs1_tag)? reg_out_r[RR]: cpuregs_rs1;
						// reg_sh <= cpuregs_rs2;
						reg_sh <= (usingLastValue_rs2_tag)? reg_out_r[RR]: cpuregs_rs2;
						// reg_op2 <= cpuregs_rs2;
						reg_op2 <= (usingLastValue_rs2_tag)? reg_out_r[RR]: cpuregs_rs2;
						(* parallel_case *)
						case (1'b1)
							is_sb_sh_sw[ID]: begin
								// reg_op1 <= cpuregs_rs1 + decoded_imm[ID];
								reg_op1 <= ((usingLastValue_rs1_tag)? reg_out_r[RR]: cpuregs_rs1) + decoded_imm[ID];
								next_stage[RR] <= WM_B;
trace_data[3:0]	<= 4'd8;
								if(load_realted_rs1_tag || load_realted_rs2_tag) begin
									refetch_pc_rr <= current_pc[ID];
									load_realted_rr <= 1'b1;
									next_stage[RR] <= 0;
trace_data[3:0]	<= 4'd9;
								end
							end
							default: begin
								next_stage[RR] <= EX_B;
trace_data[3:0]	<= 4'd10;
								if(load_realted_rs1_tag || load_realted_rs2_tag) begin
									refetch_pc_rr <= current_pc[ID];
									load_realted_rr <= 1'b1;
									next_stage[RR] <= 0;
trace_data[3:0]	<= 4'd11;
								end
							end
						endcase
					end
				endcase
			end
			else begin
				next_stage[RR] <= 0;
			end
		end
	end

	/**assign reg_out_r and cpuregs_write[RR] just after RR stage (posedge clk)*/
	always @* begin
		cpuregs_write[RR] = 1'b0;
		reg_out_r[RR] = 0;
		if(next_stage[RR]&EX_B && clk_temp[4] && !branch_hit_ex && !instr_trap) begin 
			reg_out_r[RR] = 0;
			cpuregs_write[RR] = 1'b0;
			if(!is_beq_bne_blt_bge_bltu_bgeu[RR] && !is_sb_sh_sw[RR]) begin
				cpuregs_write[RR] = 1'b1;
				reg_out_r[RR] = (instr_jalr[RR]|instr_jal[RR])? current_pc[RR] + 32'd4: alu_out;
			end 
		end
	end

	/** EX: execution */
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			next_stage[EX] <= 0;
			mem_wren <= 1'b0;
			mem_rden <= 1'b0;
			mem_addr <= 32'b0;
			branch_hit_ex <= 1'b0;
			cpuregs_write_ex <= 1'b0;
			instr_finished[EX] <= 1'b0;
			{latched_is_lu[EX], latched_is_lh[EX],latched_is_lb[EX]} <= 3'd0;
		end
		else begin
			next_stage[EX] <= 0;
			mem_wren <= 1'b0;
			mem_rden <= 1'b0;
			reg_out[EX] <= reg_out[RR];
			branch_instr[EX] <= branch_instr[RR];
			branch_hit_ex <= 1'b0;
			cpuregs_write_ex <= 1'b0;
			instr_finished[EX] <= 1'b0;
			{latched_is_lu[EX], latched_is_lh[EX],latched_is_lb[EX]} <= 3'd0;
			/** EX: execution */
			if(next_stage[RR]&EX_B && clk_temp[4] && !branch_hit_ex && !instr_trap) begin 
				reg_out[EX] <= alu_out;
				branch_pc_ex <= current_pc[RR] + decoded_imm[RR];
				if (is_beq_bne_blt_bge_bltu_bgeu[RR]) begin
					branch_hit_ex <= alu_out_0;
					next_stage[EX] <= 0;
					instr_finished[EX] <= !alu_out_0;
					branch_instr[EX] <= alu_out_0;
				end 
				else begin
					branch_hit_ex <= instr_jalr[RR];
					cpuregs_write_ex <= instr_jalr[RR];
					branch_pc_ex <= alu_out;
					if(instr_jalr[RR]) begin
						reg_out[EX] <= current_pc[RR] + 32'd4;
						next_stage[EX] <= 0;
					end
					else begin
						next_stage[EX] <= LR_B;
					end
				end
			end
			/** RWM: Read/Write Memory */			
			else if(next_stage[RR]&RM_B && clk_temp[4] && !branch_hit_ex && !instr_trap) begin
				// read mem;
				mem_addr <= alu_out;
				(* parallel_case, full_case *)
				case (1'b1)
					instr_lb[RR] || instr_lbu[RR]: mem_wordsize[RWM] <= 2;
					instr_lh[RR] || instr_lhu[RR]: mem_wordsize[RWM] <= 1;
					instr_lw[RR]: mem_wordsize[RWM] <= 0;
				endcase
				latched_is_lu[EX] <= is_lbu_lhu_lw[RR];
				latched_is_lh[EX] <= instr_lh[RR];
				latched_is_lb[EX] <= instr_lb[RR];
				// if (ENABLE_TRACE) begin
				// 	trace_valid <= 1;
				// 	trace_data <= 0 | TRACE_ADDR | ((reg_op1 + decoded_imm) & 32'hffffffff);
				// end
				next_stage[EX] <= LR_B;
				mem_rden <= 1'b1;
			end
			else if(next_stage[RR]&WM_B && clk_temp[4] && !branch_hit_ex && !instr_trap) begin
				// write mem;
				mem_addr <= reg_op1;
				(* parallel_case, full_case *)
				case (1'b1)
					instr_sb[RR]: mem_wordsize[RWM] <= 2;
					instr_sh[RR]: mem_wordsize[RWM] <= 1;
					instr_sw[RR]: mem_wordsize[RWM] <= 0;
				endcase
				mem_wren <= 1'b1;
				next_stage[EX] <= 0;
				instr_finished[EX] <= 1'b1;
			end 
			else begin
				next_stage[EX] <= next_stage[RR];
			end
			if(instr_trap)
				next_stage[EX] <= 0;
		end
	end

	/** LR: load Register */
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			// reset
			pre_instr_finished_lr <= 1'b0;
			load_reg_lr <= 1'b0;
			cpuregs_write[LR] <= 1'b0;
		end
		else begin
			next_stage[BUB_4] <= next_stage[EX];
			next_stage[BUB_5] <= next_stage[BUB_4];
			reg_out[BUB_4] <= reg_out[EX];
			reg_out[BUB_5] <= reg_out[BUB_4];
			load_reg_lr <= 1'b0;
			//cpuregs_write[LR] = 1'b0;
			if(next_stage[BUB_5] == LR_B && clk_temp[7]) begin
				
				if(latched_is_lu[BUB_5]|latched_is_lh[BUB_5]|latched_is_lb[BUB_5]) begin
					(* parallel_case, full_case *)
					case (1'b1)
						latched_is_lu[BUB_5]: reg_out[LR] <= mem_rdata_word;
						latched_is_lh[BUB_5]: reg_out[LR] <= $signed(mem_rdata_word[15:0]);
						latched_is_lb[BUB_5]: reg_out[LR] <= $signed(mem_rdata_word[7:0]);
					endcase
				end
				else begin
					reg_out[LR] <= reg_out[BUB_5];
				end
				pre_instr_finished_lr <= !branch_instr[BUB_5];
				load_reg_lr <= 1'b1;
				//cpuregs_write[LR] = 1'b1;
			end
			else if(instr_finished[BUB_5] && clk_temp[7]) begin
				pre_instr_finished_lr <= 1'b1;
				load_reg_lr <= 1'b0;
			end
			else begin
				pre_instr_finished_lr <= 1'b0;
				load_reg_lr <= 1'b0;
			end
		end
	end



endmodule

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

module read_register #(
	parameter [ 0:0] 	ENABLE_IRQ = 1,
	parameter [ 0:0]	REGS_INIT_ZERO = 1,
	parameter [ 0:0]	BARREL_SHIFTER = 1,
	parameter [ 0:0]	ENABLE_COUNTERS = 1,
	parameter [ 0:0]	ENABLE_COUNTERS64 = 1
) (
	input 				clk, resetn,

	input		[63:0]	instr_bitmap,
	input		[15:0]	instr_type,

	input		[5:0]	decoded_rd,
	input		[5:0]	decoded_rs1,
	input		[5:0]	decoded_rs2,
	input		[31:0]	decoded_imm,

	input		[31:0]	current_pc,

	output reg 	[31:0]	reg_op1_o,
	output reg 	[31:0]	reg_op2_o,

	output reg 			branch_hit_o,
	output reg 	[31:0]	branch_pc_o,
	output reg 			load_realted_o,
	output reg 	[31:0]	refetch_pc_o,
	output reg 	[31:0]	reg_data_o,
	output reg 	[5:0]	reg_id_o,
	output reg 			reg_data_valid_o,

	input		[32*2-1:0]	reg_data,
	input		[6*2-1:0]	reg_id,
	input		[1:0]		reg_data_valid
);

	//* instr
	wire instr_lui, instr_auipc, instr_jal, instr_jalr,
		instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu,
		instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw,
		instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_slli, instr_srli, instr_srai,
		instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and,
		instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh,
		instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer, instr_ctlirq,
		instr_trap;

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



	integer i;
	reg [63:0]	count_instr, count_cycle;

	localparam integer regfile_size = (ENABLE_IRQ == 0)? 32: 36;
	/** cpu related registers */
	(* dont_touch = "true" *)reg [31:0]	cpuregs [0:regfile_size-1];
	
	//* write registers;
	wire 		reg_data_valid_ex, reg_data_valid_lr;
	wire [5:0]	reg_id_ex, reg_id_lr;
	wire [31:0]	reg_data_ex, reg_data_lr;
	assign {reg_data_valid_lr, reg_data_valid_ex} 	= reg_data_valid;
	assign {reg_id_lr, reg_id_ex} 					= reg_id;
	assign {reg_data_lr, reg_data_ex} 				= reg_data;

	// always @(*) begin
	// 	if(!resetn) begin
	// 		/** initial registers */
	// 		if (REGS_INIT_ZERO) begin
	// 			for (i = 0; i < regfile_size; i = i+1)
	// 				cpuregs[i] <= 0;
	// 		end
	// 	end
	// 	else begin 	
	// 		for (i = 1; i < regfile_size; i = i+1) begin
	// 			if (reg_data_valid_ex && reg_id_ex == i) begin
	// 				cpuregs[i] <= reg_data_ex;
	// 			end
	// 			else if (reg_data_valid_lr && reg_id_lr == i) begin
	// 				cpuregs[i] <= reg_data_lr;
	// 			end
	// 		end
	// 	end
	// end
	always @(posedge clk or negedge resetn) begin
		if(!resetn) begin
			/** initial registers */
			if (REGS_INIT_ZERO) begin
				for (i = 0; i < regfile_size; i = i+1)
					cpuregs[i] <= 0;
			end
		end
		else begin 	
			for (i = 1; i < regfile_size; i = i+1) begin
				if (reg_data_valid_ex && reg_id_ex == i) begin
					cpuregs[i] <= reg_data_ex;
				end
				else if (reg_data_valid_lr && reg_id_lr == i) begin
					cpuregs[i] <= reg_data_lr;
				end
			end
		end
	end

	//* read registers;
	reg [31:0]	temp_current_pc,temp_decoded_imm;
	reg [5:0]	temp_decoded_rd[3:0], temp_decoded_rs1, temp_decoded_rs2;
	reg 		is_load[5:0];
	reg [31:0]	temp_reg_data_ex;
	reg 		temp_reg_data_valid_ex;
	reg [31:0]	cpuregs_rs1, cpuregs_rs2;
	reg 		instr_lui_auipc_jal, instr_lb_lh_lw_lbu_lhu, instr_jalr_addi_slti_sltiu_xori_ori_andi,
				instr_slli_srli_srai, temp_instr_lui, temp_instr_jal;
	always @(posedge clk) begin
		if(decoded_rs1) cpuregs_rs1 <= cpuregs[decoded_rs1];
		else 			cpuregs_rs1 <= 0;

		if(decoded_rs2) cpuregs_rs2 <= cpuregs[decoded_rs2];
		else 			cpuregs_rs2 <= 0;
		temp_current_pc				<= current_pc;
		temp_decoded_imm			<= is_slli_srli_srai? {28'b0,decoded_rs2}: decoded_imm;
		{instr_lui_auipc_jal, instr_lb_lh_lw_lbu_lhu, instr_jalr_addi_slti_sltiu_xori_ori_andi,
			instr_slli_srli_srai}	<= {is_lui_auipc_jal, is_lb_lh_lw_lbu_lhu, 
										is_jalr_addi_slti_sltiu_xori_ori_andi, is_slli_srli_srai};
		{temp_instr_lui, temp_instr_jal}	<= {instr_lui, instr_jal};
	end

	// always @* begin
	// 	(* parallel_case *)
	// 	case (1'b1)
	// 		instr_lui_auipc_jal: begin
	// 			reg_op1_o = temp_instr_lui ? 0 : temp_current_pc;
	// 			reg_op2_o = temp_instr_jal ? 32'd4 : temp_decoded_imm;
	// 		end
	// 		instr_lb_lh_lw_lbu_lhu: begin
	// 			reg_op1_o = (temp_decoded_rs1 == temp_decoded_rd[1])? reg_data_ex: cpuregs_rs1;
	// 			reg_op2_o = temp_decoded_imm;
	// 		end
	// 		instr_jalr_addi_slti_sltiu_xori_ori_andi, instr_slli_srli_srai && BARREL_SHIFTER: begin
	// 			reg_op1_o = (temp_decoded_rs1 == temp_decoded_rd[1])? reg_data_ex: cpuregs_rs1;
	// 			reg_op2_o = is_slli_srli_srai? temp_decoded_rd[0] :temp_decoded_imm;
	// 		end
	// 		default: begin
	// 			reg_op1_o = (temp_decoded_rs1 == temp_decoded_rd[1])? reg_data_ex:  cpuregs_rs1;
	// 			reg_op2_o = (temp_decoded_rs2 == temp_decoded_rd[1])? reg_data_ex: cpuregs_rs2;
	// 		end
	// 	endcase
	// end
	always @* begin
		(* parallel_case *)
		case (1'b1)
			instr_lui_auipc_jal: begin
				reg_op1_o = temp_instr_lui ? 0 : temp_current_pc;
				reg_op2_o = temp_instr_jal ? 32'd4 : temp_decoded_imm;
			end
			instr_lb_lh_lw_lbu_lhu: begin
				reg_op1_o = (temp_decoded_rs1 == temp_decoded_rd[1] && reg_data_valid_ex && temp_decoded_rs1)? reg_data_ex: 
							(temp_decoded_rs1 == temp_decoded_rd[2] && temp_reg_data_valid_ex && temp_decoded_rs1)? temp_reg_data_ex:
								cpuregs_rs1;
				reg_op2_o = temp_decoded_imm;
			end
			instr_jalr_addi_slti_sltiu_xori_ori_andi, instr_slli_srli_srai && BARREL_SHIFTER: begin
				reg_op1_o = (temp_decoded_rs1 == temp_decoded_rd[1] && reg_data_valid_ex && temp_decoded_rs1)? reg_data_ex: 
							(temp_decoded_rs1 == temp_decoded_rd[2] && temp_reg_data_valid_ex && temp_decoded_rs1)? temp_reg_data_ex: 
								cpuregs_rs1;
				reg_op2_o = temp_decoded_imm;
			end
			default: begin
				reg_op1_o = (temp_decoded_rs1 == temp_decoded_rd[1] && reg_data_valid_ex && temp_decoded_rs1)? reg_data_ex: 
							(temp_decoded_rs1 == temp_decoded_rd[2] && temp_reg_data_valid_ex && temp_decoded_rs1)? temp_reg_data_ex: 
								cpuregs_rs1;
				reg_op2_o = (temp_decoded_rs2 == temp_decoded_rd[1] && reg_data_valid_ex && temp_decoded_rs2)? reg_data_ex: 
							(temp_decoded_rs2 == temp_decoded_rd[2] && temp_reg_data_valid_ex && temp_decoded_rs2)? temp_reg_data_ex: 
								cpuregs_rs2;
			end
		endcase
	end

	// always @* begin
	// 	(* parallel_case *)
	// 	case (1'b1)
	// 		is_lui_auipc_jal: begin
	// 			reg_op1_o = instr_lui ? 0 : temp_current_pc;
	// 			reg_op2_o = instr_jal ? 32'd4 : temp_decoded_imm;
	// 		end
	// 		is_lb_lh_lw_lbu_lhu: begin
	// 			reg_op1_o = (temp_decoded_rd[0] == temp_decoded_rd[1])? reg_data_ex: cpuregs_rs1;
	// 			reg_op2_o = temp_decoded_imm;
	// 		end
	// 		is_jalr_addi_slti_sltiu_xori_ori_andi, is_slli_srli_srai && BARREL_SHIFTER: begin
	// 			reg_op1_o = (temp_decoded_rd[0] == temp_decoded_rd[1])? reg_data_ex: cpuregs_rs1;
	// 			reg_op2_o = is_slli_srli_srai? temp_decoded_rd[0] :temp_decoded_imm;
	// 		end
	// 		default: begin
	// 			reg_op1_o = (temp_decoded_rd[0] == temp_decoded_rd[1])? reg_data_ex: cpuregs_rs1;
	// 			reg_op2_o = (temp_decoded_rd[0] == temp_decoded_rd[1])? reg_data_ex: cpuregs_rs2;
	// 		end
	// 	endcase
	// end

	/** assign reg_op1_o & reg_op2_o */
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			branch_hit_o		<= 1'b0;
			branch_pc_o			<= 32'b0;
			load_realted_o		<= 1'b0;
			refetch_pc_o		<= 32'b0;
			reg_data_valid_o 	<= 1'b0;
			reg_data_o 			<= 32'b0;
			reg_id_o 			<= 6'b0;
			for(i=0; i<6; i=i+1) begin
				temp_decoded_rd[i]	<= 6'b0;
				is_load[i]			<= 1'b0;
			end
			temp_reg_data_ex	<= 32'b0;
			temp_decoded_rs1	<= 6'b0;
			temp_decoded_rs2	<= 6'b0;
		end
		else begin
			branch_hit_o 		<= 1'b0;
			load_realted_o		<= 1'b0;
			reg_data_valid_o 	<= 1'b0;
			reg_id_o 			<= decoded_rd;
			(* parallel_case *)
			case (1'b1)					
				ENABLE_COUNTERS && is_rdcycle_rdcycleh_rdinstr_rdinstrh: begin
					(* parallel_case, full_case *)
					case (1'b1)
						instr_rdcycle:
							reg_data_o 	<= count_cycle[31:0];
						instr_rdcycleh && ENABLE_COUNTERS64:
							reg_data_o 	<= count_cycle[63:32];
						instr_rdinstr:
							reg_data_o 	<= count_instr[31:0];
						instr_rdinstrh && ENABLE_COUNTERS64:
							reg_data_o 	<= count_instr[63:32];
					endcase
					reg_data_valid_o 	<= 1'b1;
				end
				instr_jal: begin
					branch_pc_o 		<= current_pc + decoded_imm;
					branch_hit_o 		<= 1'b1;
					reg_data_valid_o 	<= 1'b1;
					reg_data_o 			<= current_pc + 32'd4;
				end
			endcase

			if((decoded_rs1 == temp_decoded_rd[0] && is_load[0] == 1'b1) || 
				(decoded_rs1 == temp_decoded_rd[1] && is_load[1] == 1'b1)|| 
				(decoded_rs1 == temp_decoded_rd[2] && is_load[2] == 1'b1)|| 
				(decoded_rs1 == temp_decoded_rd[3] && is_load[3] == 1'b1)|| 
				(decoded_rs2 == temp_decoded_rd[0] && is_load[0] == 1'b1 && (is_beq_bne_blt_bge_bltu_bgeu || is_sb_sh_sw || is_alu_reg_reg))|| 
				(decoded_rs2 == temp_decoded_rd[1] && is_load[1] == 1'b1 && (is_beq_bne_blt_bge_bltu_bgeu || is_sb_sh_sw || is_alu_reg_reg))|| 
				(decoded_rs2 == temp_decoded_rd[2] && is_load[2] == 1'b1 && (is_beq_bne_blt_bge_bltu_bgeu || is_sb_sh_sw || is_alu_reg_reg))|| 
				(decoded_rs2 == temp_decoded_rd[3] && is_load[3] == 1'b1 && (is_beq_bne_blt_bge_bltu_bgeu || is_sb_sh_sw || is_alu_reg_reg))) 
			begin
				refetch_pc_o 	<= current_pc;
				load_realted_o 	<= 1'b1;
			end
			{temp_decoded_rd[3],temp_decoded_rd[2],temp_decoded_rd[1],temp_decoded_rd[0]} <= {temp_decoded_rd[2],temp_decoded_rd[1],temp_decoded_rd[0],decoded_rd};
			{is_load[3],is_load[2],is_load[1],is_load[0]} <= {is_load[2],is_load[1],is_load[0], is_lb_lh_lw_lbu_lhu};
			temp_reg_data_ex						<= reg_data_ex;
			temp_reg_data_valid_ex					<= reg_data_valid_ex;
			{temp_decoded_rs1, temp_decoded_rs2}	<= {decoded_rs1, decoded_rs2};
		end
	end

endmodule

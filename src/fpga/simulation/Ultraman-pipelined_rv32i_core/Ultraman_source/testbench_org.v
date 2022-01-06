`timescale 1 ns / 1 ps
//`define SRAM_ADOPTED

module testbench();
	reg clk = 1;
	reg resetn = 0;
	wire tests_passed;


	/** clk */
	always #5 clk = ~clk;
	/** reset */
	initial begin
		repeat (100) @(posedge clk);
		resetn <= 1;
	end
	
	/** read firmware.hex and write memory */
	reg [1023:0] firmware_file;
	initial begin
		if (!$value$plusargs("firmware=%s", firmware_file))
			firmware_file = "D:/0-Code/Code_of_hw/1-sim/15-pipeline_core/TuMan_test/TuMan_source/firmware.hex";
		$readmemh(firmware_file, mem.memory);
	end

	
	wire        mem_rinst;
	wire 		mem_wren, mem_rden;
	wire [31:0] mem_rinst_addr, mem_addr;
	wire [31:0] mem_wdata;
	wire [ 3:0] mem_wstrb;
	wire [31:0] mem_rdata, mem_rdata_instr;


	Ultraman_core Ultraman(
		.clk(clk), 
		.resetn(resetn),
		.finish(tests_passed),

		.mem_rinst(mem_rinst),
		.mem_rinst_addr(mem_rinst_addr),
		.mem_rdata_instr(mem_rdata_instr),
		.mem_wren(mem_wren),
		.mem_rden(mem_rden),
		.mem_addr(mem_addr),
		.mem_wdata(mem_wdata),
		.mem_wstrb(mem_wstrb),
		.mem_rdata(mem_rdata)
	);	
	
	
	memory_adapter mem (
		.clk       (clk       ),
		.resetn	   (resetn),
		.mem_rinst(mem_rinst),
		.mem_rinst_addr(mem_rinst_addr),
		.mem_rdata_instr(mem_rdata_instr),
		.mem_wren(mem_wren),
		.mem_rden(mem_rden),
		.mem_addr(mem_addr),
		.mem_wdata(mem_wdata),
		.mem_wstrb(mem_wstrb),
		.mem_rdata(mem_rdata),
		.tests_passed(tests_passed)
	);
	
	
endmodule

module memory_adapter(
	/* verilator lint_off MULTIDRIVEN */	
	
	input             clk,
	input			  resetn,
	
	//* instr;
	input        		mem_rinst,
	input 		[31:0] 	mem_rinst_addr,
	output	reg	[31:0] 	mem_rdata_instr,
	//* data;
	input 	  			mem_wren,
	input 	  			mem_rden,
	input 		[31:0] 	mem_addr,
	input 		[31:0] 	mem_wdata,
	input 		[ 3:0] 	mem_wstrb,
	output  reg [31:0] 	mem_rdata,
	output	reg	  		tests_passed
);

	reg [31:0]  memory [0:64*1024/4-1] /* verilator public */;

	initial begin
		mem_rdata_instr = 0;
		mem_rdata = 0;
		tests_passed = 0;
	end

	task handle_instrMem_rdata; begin
		if (mem_rinst_addr < 64*1024) begin
			mem_rdata_instr <= memory[mem_rinst_addr >> 2];
		end
		else begin
			$display("OUT-OF-BOUNDS MEMORY READ FROM %08x", mem_rinst_addr);
			$finish;
		end
	end endtask

	task handle_mem_rdata; begin
		if (mem_addr < 64*1024) begin
			mem_rdata <= memory[mem_addr >> 2];
		end
		else begin
			$display("OUT-OF-BOUNDS MEMORY READ FROM %08x", mem_addr);
			// $finish; //* pipelined core maybe read a wrong address (wrong instr) after beq instr;
			mem_rdata <= 32'b0;
		end
	end endtask


	task handle_mem_wdata; begin
		if (mem_addr < 64*1024) begin
			if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
			if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
			if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
			if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
		end 
		else if (mem_addr == 32'h1000_0000) begin
			$write("%c", mem_wdata[7:0]);
			// `ifndef VERILATOR
			// 	fflush();
			// `endif
		end 
		else if (mem_addr == 32'h2000_0000) begin
			if (mem_wdata == 123456789)
				tests_passed = 1;
		end
		else begin
			$display("OUT-OF-BOUNDS MEMORY WRITE TO %08x", mem_addr);
			// $finish; //* pipelined core maybe write a wrong address (wrong instr) after beq instr;
		end
	end endtask

	always @(negedge clk or negedge resetn) begin
		if(!resetn) begin
		end
		else begin 
			//* instr
			if (mem_rinst) handle_instrMem_rdata;
			//* data
			if (mem_rden) handle_mem_rdata;
			else if (mem_wren) handle_mem_wdata;
		end
	end


endmodule



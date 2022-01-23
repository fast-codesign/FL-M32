/*
 *  iCore_hardware -- Hardware for TuMan RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2020 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2020.01.01
 *  Description: This module is the top module.
 */
 `timescale 1 ns / 1 ps

module pico_top(
  input                 clk,
  input                 resetn,
  //* interface for configuring memory
  input                 conf_rden,
  input                 conf_wren,
  input         [31:0]  conf_addr,
  input         [31:0]  conf_wdata,
  output  wire  [31:0]  conf_rdata,
  input                 conf_sel,
  //* interface for peripheral
  output                peri_rden,
  output                peri_wren,
  output        [31:0]  peri_addr,
  output        [31:0]  peri_wdata,
  input   wire  [31:0]  peri_rdata,
  input                 peri_ready,
  input   wire  [31:0]  irq_bitmap
);

/** sram interface for instruction and data*/
  (* mark_debug = "true"*)wire        mem_valid;            //  read/write is valid;
  (* mark_debug = "true"*)wire        mem_instr;            //  read instr, not used;
  (* mark_debug = "true"*)wire        mem_wren;             //  write data request
  (* mark_debug = "true"*)wire        mem_rden;             //  read data request
  (* mark_debug = "true"*)wire        mem_ready, mem_ready_mem;            //  read/write ready;
  (* mark_debug = "true"*)wire [31:0] mem_addr;             //  write/read addr
  (* mark_debug = "true"*)wire [31:0] mem_wdata;            //  write data
  (* mark_debug = "true"*)wire [3:0]  mem_wstrb;            //  write wstrb
  (* mark_debug = "true"*)wire [31:0] mem_rdata, mem_rdata_mem;            //  data

  reg  [31:0] clk_counter;          //  timer;
  reg         finish_tag;           //  finish_tag is 0 when cpu writes 0x20000000;
  // reg  [31:0] irq_bitmap;

  (* mark_debug = "true"*)wire        trap;

// picorv32_simplified_wo_ctrlirq picorv32(
picorv32_simplified picorv32(
  .clk(clk),
  .resetn(resetn&~conf_sel&finish_tag),
  .trap(trap),
  .mem_valid(mem_valid),
  .mem_instr(mem_instr),
  .mem_ready(mem_ready),
  .mem_addr(mem_addr),
  .mem_wdata(mem_wdata),
  .mem_wstrb(mem_wstrb),
  .mem_rdata(mem_rdata),
  .mem_la_read(),
  .mem_la_write(),
  .mem_la_addr(),
  .mem_la_wdata(),
  .mem_la_wstrb(),
  .irq(irq_bitmap),
  .eoi(),
  .trace_valid(),
  .trace_data()
);


memory mem(
  .clk(clk),
  .resetn(resetn),
  .mem_wren(mem_wren),
  .mem_rden(mem_rden),
  .mem_addr({2'b0,mem_addr[31:2]}),
  .mem_wdata(mem_wdata),
  .mem_wstrb(mem_wstrb),
  .mem_rdata(mem_rdata_mem),
  .mem_ready(mem_ready_mem),

  .conf_sel(conf_sel),
  .conf_rden(conf_rden),
  .conf_wren(conf_wren),
  .conf_addr(conf_addr),
  .conf_wdata(conf_wdata),
  .conf_rdata(conf_rdata)
);

  //* assign memory interface signals;
  assign mem_wren = (mem_addr[31:28] == 4'b0)? mem_valid & (|mem_wstrb) : 1'b0;
  assign mem_rden = (mem_addr[31:28] == 4'b0)? mem_valid & (mem_wstrb == 4'b0): 1'b0;

  //* assign finish_tag;
  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      finish_tag      <= 1'b1;
    end
    else begin
      if(mem_addr == 32'h20000000 && mem_wren == 1'b1)
        finish_tag    <= 1'b0;
      else
        finish_tag    <= finish_tag|conf_sel;
    end
  end

  assign peri_wren = mem_valid & (|mem_wstrb);
  assign peri_rden = mem_valid & (mem_wstrb == 4'b0);
  assign peri_addr = mem_addr;
  assign peri_wdata = mem_wdata;

  assign mem_rdata = (mem_ready_mem == 1'b1)? mem_rdata_mem: peri_rdata;
  assign mem_ready = mem_ready_mem | peri_ready;


endmodule


/*
 *  iCore_hardware -- Hardware for TuMan RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2020 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Date: 2020.01.01
 *  Description: This module is used to store instruction & data. 
 *   And we use "conf_sel" to distinguish configuring or running mode.
 */

`timescale 1 ns / 1 ps


module memory_fake(
  /* verilator lint_off MULTIDRIVEN */  
  input                 clk,
  input                 resetn,
  // interface for cpu
  input                 mem_wren,     
  input                 mem_rden,
  input         [31:0]  mem_addr,
  input         [3:0]   mem_wstrb,
  input         [31:0]  mem_wdata,
  output  reg   [31:0]  mem_rdata,
  output  reg           mem_ready,

  // interface for configuration
  input                 conf_sel,   // 1 is configuring;
  input                 conf_rden,
  input                 conf_wren,
  input         [31:0]  conf_addr,
  input         [31:0]  conf_wdata,
  output  wire  [31:0]  conf_rdata
);
  assign conf_rdata = 32'b0;

  reg [31:0]  memory [0:128*1024/4-1] /* verilator public */;
  reg [31:0]  mem_rdata_temp;
  reg         mem_ready_temp;

  initial begin
    mem_ready = 0;
    mem_rdata = 0;
  end

  task handle_mem_rdata; begin
    if (mem_addr < 128*1024) begin
      mem_rdata <= memory[mem_addr];
    end
    else begin
      $display("OUT-OF-BOUNDS MEMORY READ FROM %08x", mem_addr);
      $finish;
    end
    mem_ready <= 1;
  end endtask


  task handle_mem_wdata; begin
    if (mem_addr < 128*1024) begin
      if (mem_wstrb[0]) memory[mem_addr][ 7: 0] <= mem_wdata[ 7: 0];
      if (mem_wstrb[1]) memory[mem_addr][15: 8] <= mem_wdata[15: 8];
      if (mem_wstrb[2]) memory[mem_addr][23:16] <= mem_wdata[23:16];
      if (mem_wstrb[3]) memory[mem_addr][31:24] <= mem_wdata[31:24];
    end
    else begin
      $display("OUT-OF-BOUNDS MEMORY WRITE TO %08x", mem_addr);
      $finish;
    end
    mem_ready <= 1;
  end endtask


  always @(negedge clk or negedge resetn) begin
    if(!resetn) begin
      mem_ready <= 0;
    end
    else begin 
      if (mem_rden) handle_mem_rdata;
      else if (mem_wren) handle_mem_wdata;
      else 
        mem_ready <= 0;
    end
  end


endmodule
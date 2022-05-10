/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        connect_bus.
 *  Description:        This module is used to connect timelyRV_top with 
 *                       configuration, pkt sram, can, and uart.
 *  Last updated date:  2022.04.02.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

module connect_bus(
  input                           clk_i,
  input                           rst_n_i,
    
  input                           peri_rden_i,
  input                           peri_wren_i,
  input       [31:0]              peri_addr_i,
  input       [31:0]              peri_wdata_i,
  input       [3:0]               peri_wstrb_i,

  output reg                      peri_ready_o,
  output reg  [31:0]              peri_rdata_o,

  (* mark_debug = "true"*)output reg  [`NUM_PERI*32-1:0]  addr_32b_o,
  (* mark_debug = "true"*)output reg  [`NUM_PERI-1:0]     wren_o,
  (* mark_debug = "true"*)output reg  [`NUM_PERI-1:0]     rden_o,
  output reg  [`NUM_PERI*32-1:0]  din_32b_o,
  output reg  [`NUM_PERI*4-1:0]   wstrb_o,
  input       [`NUM_PERI-1:0]     dout_32b_valid_i,
  input       [`NUM_PERI*32-1:0]  dout_32b_i

  `ifdef CV32E40P
    ,output   wire                gnt_o
  `endif
);

  `ifdef CV32E40P
    assign gnt_o = |dout_32b_valid_i; //* just valid before peri_ready_o 1 clk;
  `endif

  //* wire

  //* TODO, current bus is simple, just one stage;
  integer i;
  (* mark_debug = "true"*)reg  [`NUM_PERI-1:0]  pre_wr_rd;
  (* mark_debug = "true"*)wire [15:0]           peri_addr_test;
  assign peri_addr_test =                       peri_addr_i[31:16];

  always @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      addr_32b_o                  <= 0;
      din_32b_o                   <= 0;
      wren_o                      <= 0;
      rden_o                      <= 0;
      wstrb_o                     <= 0;
      peri_ready_o                <= 1'b0;
      peri_rdata_o                <= 32'b0;
      pre_wr_rd                   <= 0;
    end
    else begin
      addr_32b_o                  <= 0;
      din_32b_o                   <= 0;
      wren_o                      <= 0;
      rden_o                      <= 0;
      peri_ready_o                <= |dout_32b_valid_i;
      pre_wr_rd                   <= 0;
      //* UART;
      if(peri_addr_i[31:16] == `BASE_ADDR_UART) begin
      // if(peri_addr_i[31:16] == 16'h1001) begin
        wren_o[`UART]             <= peri_wren_i&(~pre_wr_rd[`UART]);
        rden_o[`UART]             <= peri_rden_i&(~pre_wr_rd[`UART]);
        addr_32b_o[`UART*32+:32]  <= peri_addr_i;
        din_32b_o[`UART*32+:32]   <= peri_wdata_i;
        pre_wr_rd[`UART]          <= peri_wren_i|peri_rden_i;
      end
      if(dout_32b_valid_i[`UART] == 1'b1)
        peri_rdata_o              <= dout_32b_i[`UART*32+:32];
      
      `ifdef CAN
        //* CAN
        if(peri_addr_i[31:16] == `BASE_ADDR_CAN) begin
          wren_o[`CAN]            <= peri_wren_i&(~pre_wr_rd[`CAN]);
          rden_o[`CAN]            <= peri_rden_i&(~pre_wr_rd[`CAN]);
          addr_32b_o[`CAN*32+:32] <= peri_addr_i;
          din_32b_o[`CAN*32+:32]  <= peri_wdata_i;
          pre_wr_rd[`CAN]         <= peri_wren_i|peri_rden_i;
        end
        if(dout_32b_valid_i[`CAN] == 1'b1)
          peri_rdata_o            <= dout_32b_i[`CAN*32+:32];
      `endif
      
      `ifdef LCD
        //* LCD
        if(peri_addr_i[31:16] == `BASE_ADDR_LCD) begin
          wren_o[`LCD]            <= peri_wren_i&(~pre_wr_rd[`LCD]);
          rden_o[`LCD]            <= peri_rden_i&(~pre_wr_rd[`LCD]);
          addr_32b_o[`LCD*32+:32] <= peri_addr_i;
          din_32b_o[`LCD*32+:32]  <= peri_wdata_i;
          pre_wr_rd[`LCD]         <= peri_wren_i|peri_rden_i;
        end
        if(dout_32b_valid_i[`LCD] == 1'b1)
          peri_rdata_o            <= dout_32b_i[`LCD*32+:32];
      `endif

      `ifdef PKT
        //* PKT
        if(peri_addr_i[31:16] == `BASE_ADDR_PKT) begin
          wren_o[`PKT]            <= peri_wren_i&(~pre_wr_rd[`PKT]);
          rden_o[`PKT]            <= peri_rden_i&(~pre_wr_rd[`PKT]);
          addr_32b_o[`PKT*32+:32] <= peri_addr_i;
          din_32b_o[`PKT*32+:32]  <= peri_wdata_i;
          wstrb_o[`PKT*4+:4]      <= peri_wstrb_i;
          pre_wr_rd[`PKT]         <= peri_wren_i|peri_rden_i;
        end
        if(dout_32b_valid_i[`PKT] == 1'b1)
          peri_rdata_o            <= dout_32b_i[`PKT*32+:32];
      `endif

      `ifdef RS485_0
        //* RS485
        if(peri_addr_i[31:16] == `BASE_ADDR_RS485_0) begin
          wren_o[`RS485_0]            <= peri_wren_i&(~pre_wr_rd[`RS485_0]);
          rden_o[`RS485_0]            <= peri_rden_i&(~pre_wr_rd[`RS485_0]);
          addr_32b_o[`RS485_0*32+:32] <= peri_addr_i;
          din_32b_o[`RS485_0*32+:32]  <= peri_wdata_i;
          wstrb_o[`RS485_0*4+:4]      <= peri_wstrb_i;
          pre_wr_rd[`RS485_0]         <= peri_wren_i|peri_rden_i;
        end
        if(dout_32b_valid_i[`RS485_0] == 1'b1)
          peri_rdata_o                <= dout_32b_i[`RS485_0*32+:32];
      `endif

      `ifdef RS485_1
        //* RS485
        if(peri_addr_i[31:16] == `BASE_ADDR_RS485_1) begin
          wren_o[`RS485_1]            <= peri_wren_i&(~pre_wr_rd[`RS485_1]);
          rden_o[`RS485_1]            <= peri_rden_i&(~pre_wr_rd[`RS485_1]);
          addr_32b_o[`RS485_1*32+:32] <= peri_addr_i;
          din_32b_o[`RS485_1*32+:32]  <= peri_wdata_i;
          wstrb_o[`RS485_1*4+:4]      <= peri_wstrb_i;
          pre_wr_rd[`RS485_1]         <= peri_wren_i|peri_rden_i;
        end
        if(dout_32b_valid_i[`RS485_1] == 1'b1)
          peri_rdata_o                <= dout_32b_i[`RS485_1*32+:32];
      `endif

      `ifdef PWM
        //* PKT
        if(peri_addr_i[31:16] == `BASE_ADDR_PWM) begin
          wren_o[`PWM]            <= peri_wren_i&(~pre_wr_rd[`PWM]);
          rden_o[`PWM]            <= peri_rden_i&(~pre_wr_rd[`PWM]);
          addr_32b_o[`PWM*32+:32] <= peri_addr_i;
          din_32b_o[`PWM*32+:32]  <= peri_wdata_i;
          wstrb_o[`PWM*4+:4]      <= peri_wstrb_i;
          pre_wr_rd[`PWM]         <= peri_wren_i|peri_rden_i;
        end
        if(dout_32b_valid_i[`PWM] == 1'b1)
          peri_rdata_o            <= dout_32b_i[`PWM*32+:32];
      `endif
    end
  end


endmodule    

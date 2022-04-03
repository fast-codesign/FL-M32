/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        interrupt_ctrl.
 *  Description:        This module is used to contorl irqs from pkt 
 *                        sram, can, uart.
 *  Last updated date:  2022.04.03.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

module interrupt_ctrl(
  input                       clk_i,
  input                       rst_n_i,

  input       [`NUM_PERI-1:0] irq_i,
  output reg  [31:0]          irq_o
);

  //* TODO, irq ctrl is simple, just one stage;
  reg         [`NUM_PERI-1:0] irq_pre;

  always @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      irq_o                   <= 0;
      irq_pre                 <= 0;
    end
    else begin
      irq_pre                 <= irq_i;
      irq_o[4+:`NUM_PERI]     <= ~irq_pre & irq_i;
    end
  end

endmodule    

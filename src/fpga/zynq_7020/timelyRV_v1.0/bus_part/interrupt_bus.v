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

  `ifdef CV32E40P
    ,input                    irq_ack_i
    ,input    [4:0]           irq_id_i
  `endif
);

  //* TODO, irq ctrl is simple, just one stage;
  (* mark_debug = "true"*)reg         [`NUM_PERI-1:0] irq_pre;
  (* mark_debug = "true"*)wire [`NUM_PERI-1:0] irq_o_test;
  assign      irq_o_test = irq_o[16+:`NUM_PERI];

  integer i;
  always @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      irq_o                   <= 0;
      irq_pre                 <= 0;
    end
    else begin
      irq_pre                 <= irq_i;
      `ifdef CV32E40P
        for(i=0; i<`NUM_PERI; i=i+1) begin
          //* set irq with '1';
          if(irq_pre[i] == 1'b0 && irq_i[i] == 1'b1)
            irq_o[16+i]       <= 1'b1;
          //* set irq with '0';
          else if(irq_ack_i == 1'b1 && irq_id_i == (i+16))
            irq_o[16+i]       <= 1'b0;
          //* maintain irq;
          else
            irq_o[16+i]       <= irq_o[16+i];
        end
      `else
        irq_o[4+:`NUM_PERI]   <= ~irq_pre & irq_i;
      `endif
    end
  end

endmodule    

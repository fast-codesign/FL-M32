/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        um_for_cpu.
 *  Description:        This module is used to connect timelyRV_top with 
 *                       configuration, pkt sram, can, and uart.
 *  Last updated date:  2022.04.01.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

module um_for_cpu(
   input               clk
  ,input               rst_n
    
  ,input               data_in_valid
  ,input       [133:0] data_in    //* 2'b01 is head, 2'b00 is body, and 2'b10 is tail;
  ,output reg          data_out_valid
  ,output reg  [133:0] data_out

  ,input               uart_rx
  ,output wire         uart_tx
  ,input               uart_cts_i
  
  ,output wire         led_out

`ifdef CAN
  ,inout       [7:0]   can_ad
  ,output wire         can_cs_n
  ,output wire         can_ale
  ,output wire         can_wr_n
  ,output wire         can_rd_n
  ,input               can_int_n
  ,output reg          can_rst_n
  ,output wire         can_mode
`endif

`ifdef LCD
  ,input               lcd_clk    //* lcd clock;
  ,input               lcd_rst    //* lcd rst;
  ,output  wire        lcd_hs     //* lcd horizontal synchronization;
  ,output  wire        lcd_vs     //* lcd vertical synchronization;  
  ,output  wire        lcd_de     //* lcd data valid;
  ,output  wire  [7:0] lcd_r      //* lcd red;
  ,output  wire  [7:0] lcd_g      //* lcd green;
  ,output  wire  [7:0] lcd_b      //* lcd blue;
`endif
);

  //* wire
  (* mark_debug = "true"*)wire          conf_rden, conf_wren;
  (* mark_debug = "true"*)wire [31:0]   conf_addr, conf_wdata, conf_rdata;
  (* mark_debug = "true"*)wire          conf_sel;
  (* mark_debug = "true"*)wire          peri_rden, peri_wren;
  (* mark_debug = "true"*)wire [31:0]   peri_addr, peri_wdata;
  (* mark_debug = "true"*)wire [3:0]    peri_wstrb;
  (* mark_debug = "true"*)wire [31:0]   peri_rdata;
  (* mark_debug = "true"*)wire          peri_ready;
  (* mark_debug = "true"*)wire [31:0]   irq_bitmap;

  //* bus to connect Peripherals;
  (* mark_debug = "true"*)wire  [`NUM_PERI*32-1:0]  addr_32b_p;
  (* mark_debug = "true"*)wire  [`NUM_PERI-1:0]     wren_p;
  (* mark_debug = "true"*)wire  [`NUM_PERI-1:0]     rden_p;
  (* mark_debug = "true"*)wire  [`NUM_PERI*32-1:0]  din_32b_p;
  (* mark_debug = "true"*)wire  [`NUM_PERI*4-1:0]   wstrb_p;
  (* mark_debug = "true"*)wire  [`NUM_PERI*32-1:0]  dout_32b_p;
  (* mark_debug = "true"*)wire  [`NUM_PERI-1:0]     dout_32b_valid_p;
  (* mark_debug = "true"*)wire  [`NUM_PERI-1:0]     interrupt_p;

  //* pkt mux;
  wire            data_out_valid_mem, data_out_valid_memPkt;
  wire  [133:0]   data_out_mem, data_out_memPkt;

  //* top of timeRV core;
  timelyRV_top timelyRV_top(
    .clk          (clk                ),
    .resetn       (rst_n              ),

    .conf_rden    (conf_rden          ),
    .conf_wren    (conf_wren          ),
    .conf_addr    (conf_addr          ),
    .conf_wdata   (conf_wdata         ),
    .conf_rdata   (conf_rdata         ),
    .conf_sel     (conf_sel           ),

    .peri_rden    (peri_rden          ),
    .peri_wren    (peri_wren          ),
    .peri_addr    (peri_addr          ),
    .peri_wdata   (peri_wdata         ),
    .peri_wstrb   (peri_wstrb         ),
    .peri_rdata   (peri_rdata         ),
    .peri_ready   (peri_ready         ),
    .irq_bitmap   (irq_bitmap         )
  );

  //* configuration module;
  conf_mem confMem(
    .clk          (clk                ),
    .resetn       (rst_n              ),
    //* ethernet's type is 0x9001, 0x9002, 0x9003, 0x9004;
    .data_in_valid(data_in_valid      ),
    .data_in      (data_in            ),
    .data_out_valid(data_out_valid_mem),
    .data_out     (data_out_mem       ),

    .conf_rden    (conf_rden          ),
    .conf_wren    (conf_wren          ),
    .conf_addr    (conf_addr          ),
    .conf_wdata   (conf_wdata         ),
    .conf_rdata   (conf_rdata         ),
    .conf_sel     (conf_sel           )
  );

  connect_bus bus (
    .clk_i        (clk                        ),
    .rst_n_i      (rst_n                      ),
    .peri_rden_i  (peri_rden                  ),
    .peri_wren_i  (peri_wren                  ),
    .peri_addr_i  (peri_addr                  ),
    .peri_wdata_i (peri_wdata                 ),
    .peri_wstrb_i (peri_wstrb                 ),
    .peri_rdata_o (peri_rdata                 ),
    .peri_ready_o (peri_ready                 ),

    .addr_32b_o   (addr_32b_p                 ),
    .wren_o       (wren_p                     ),
    .rden_o       (rden_p                     ),
    .din_32b_o    (din_32b_p                  ),
    .wstrb_o      (wstrb_p                    ),
    .dout_32b_i   (dout_32b_p                 ),
    .dout_32b_valid_i(dout_32b_valid_p        )
  );



  interrupt_ctrl irq_ctrl(
    .clk_i        (clk                        ),
    .rst_n_i      (rst_n                      ),
    .irq_i        (interrupt_p                ),
    .irq_o        (irq_bitmap                 )
  );

  uart uart_inst(
    .clk_i        (clk                        ),
    .rst_n_i      (rst_n                      ),
    
    .uart_tx_o    (uart_tx                    ),
    .uart_rx_i    (uart_rx                    ),
    
    .addr_32b_i   (addr_32b_p[`UART*32+:32]   ),
    .wren_i       (wren_p[`UART]              ),
    .rden_i       (rden_p[`UART]              ),
    .din_32b_i    (din_32b_p[`UART*32+:32]    ),
    .dout_32b_o   (dout_32b_p[`UART*32+:32]   ),
    .dout_32b_valid_o(dout_32b_valid_p[`UART] ),
    .interrupt_o  (interrupt_p[`UART]         )
  );

`ifdef CAN
  //* irq_bitmap[5];
  can can_inst(
    .sys_clk      (clk                        ),
    .rst_n        (rst_n                      ),
    
    .addr_32b_i   (addr_32b_p[`CAN*32+:32]    ),
    .wren_i       (wren_p[`CAN]               ),
    .rden_i       (rden_p[`CAN]               ),
    .din_32b_i    (din_32b_p[`CAN*32+:32]     ),
    .dout_32b_o   (dout_32b_p[`CAN*32+:32]    ),
    .dout_32b_valid_o(dout_32b_valid_p[`CAN]  ),
    .interrupt_o  (interrupt_p[`CAN]          ),

    .can_ad       (can_ad                     ),
    .can_cs_n     (can_cs_n                   ),
    .can_ale      (can_ale                    ),
    .can_wr_n     (can_wr_n                   ),
    .can_rd_n     (can_rd_n                   ),
    .can_int_n    (can_int_n                  ),
    .can_rst_n    (                           ),
    .can_mode     (can_mode                   )
  );
`endif

`ifdef LCD
  lcd lcd_inst(
    .core_clk     (clk                        ),

    .addr_32b_i   (addr_32b_p[`LCD*32+:32]    ),
    .wren_i       (wren_p[`LCD]               ),
    .rden_i       (rden_p[`LCD]               ),
    .din_32b_i    (din_32b_p[`LCD*32+:32]     ),
    .dout_32b_o   (dout_32b_p[`LCD*32+:32]    ),
    .dout_32b_valid_o(dout_32b_valid_p[`LCD]  ),
    .interrupt_o  (interrupt_p[`LCD]          ),

    .lcd_clk      (lcd_clk                    ),
    .rst          (lcd_rst                    ),
    .hs           (lcd_hs                     ),
    .vs           (lcd_vs                     ),
    .de           (lcd_de                     ),
    .rgb_r        (lcd_r                      ),
    .rgb_g        (lcd_g                      ),
    .rgb_b        (lcd_b                      )
  );
`endif

`ifdef PKT
  memPkt memPkt_inst(
    .clk          (clk                        ),
    .rst_n        (rst_n                      ),

    .data_in_valid(data_in_valid              ),
    .data_in      (data_in                    ),
    .data_out_valid(data_out_valid_memPkt     ),
    .data_out     (data_out_memPkt            ),

    .memPkt_rden  (rden_p[`PKT]               ),
    .memPkt_wren  (wren_p[`PKT]               ),
    .memPkt_addr  (addr_32b_p[`PKT*32+:32]    ),
    .memPkt_wdata (din_32b_p[`PKT*32+:32]     ),
    .memPkt_wstrb (wstrb_p[`PKT*4+:4]         ),
    .memPkt_rdata (dout_32b_p[`PKT*32+:32]    ),
    .memPkt_ready (dout_32b_valid_p[`PKT]     ),
    .interrupt_o  (interrupt_p[`PKT]          )
  );
`endif


//***************************************pkt dmux***********************************//
  //* output pkt;
  reg type_mem;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_out_valid  <= 1'b0;
      data_out        <= 134'b0;
      type_mem        <= 1'b0;
    end
    else begin
      data_out_valid  <= data_out_valid_mem | data_out_valid_memPkt;
      if(data_out_valid == 1'b0) begin
        if(data_out_valid_mem == 1'b1) begin
          type_mem    <= 1'b0;
          data_out    <= data_out_mem;
        end
        else begin
          type_mem    <= 1'b1;
          data_out    <= data_out_memPkt;
        end
      end
      else begin
        data_out      <= (type_mem == 1'b0)? data_out_mem: data_out_memPkt;
      end
    end
  end
//***************************************pkt dmux***********************************//


endmodule    

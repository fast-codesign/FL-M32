/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        rs485.
 *  Description:        top module of rs485.
 *  Last updated date:  2021.11.20.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

module rs485(
  input                 clk_i,
  input                 rst_n_i,
  output  wire          rs485_tx_o,
  input                 rs485_rx_i,
  output  wire          rs485_de_o,

  input         [31:0]  addr_32b_i,
  input                 wren_i,
  input                 rden_i,
  input         [31:0]  din_32b_i,
  output  wire  [31:0]  dout_32b_o,
  output  wire          dout_32b_valid_o,
  output  wire          interrupt_o
);

//* clk for sampling rx/tx;
(* mark_debug = "true"*)wire  rxclk_en, txclk_en;

//* data and valid signals;
(* mark_debug = "true"*)wire  rs485_dataTx_valid, rs485_dataRx_valid;
(* mark_debug = "true"*)wire  [7:0] rs485_dataTx, rs485_dataRx;
(* mark_debug = "true"*)wire  rs485_tx_busy_o;

//* gen rx/tx sample clk;
baud_rate_gen rs485_baud(
  .clk_i          (clk_i              ),
  .rst_n_i        (rst_n_i            ),
  .rxclk_en_o     (rxclk_en           ),
  .txclk_en_o     (txclk_en           )
);
//* 8b din -> 1b tx;
transmitter rs485_tx(
  .clk_i          (clk_i              ),
  .rst_n_i        (rst_n_i            ),
  .din_8b_i       (rs485_dataTx       ),
  .wren_i         (rs485_dataTx_valid ),
  .clken_i        (txclk_en           ),
  .tx_o           (rs485_tx_o         ),
  .tx_busy_o      (rs485_tx_busy_o    )
);
//* 1b rx -> 8b dout;
receiver rs485_rx(
  .clk_i          (clk_i              ),
  .rst_n_i        (rst_n_i            ),
  .clken_i        (rxclk_en           ),
  .dout_8b_o      (rs485_dataRx       ),
  .dout_valid_o   (rs485_dataRx_valid ),
  .rx_i           (rs485_rx_i         )
);

uart_control rs485_ctl(
  .clk_i          (clk_i              ),
  .rst_n_i        (rst_n_i            ),
  .addr_32b_i     (addr_32b_i         ),
  .wren_i         (wren_i             ),
  .rden_i         (rden_i             ),
  .din_32b_i      (din_32b_i          ),
  .dout_32b_o     (dout_32b_o         ),
  .dout_32b_valid_o(dout_32b_valid_o  ),
  .interrupt_o    (interrupt_o        ),

  .din_8b_i       (rs485_dataRx       ),
  .din_valid_i    (rs485_dataRx_valid ),
  .dout_8b_o      (rs485_dataTx       ),
  .dout_valid_o   (rs485_dataTx_valid ),
  .tx_busy_i      (rs485_tx_busy_o    )
);

//* delay 2^5 clks to recv data after sending data;
reg       temp_de;
reg [7:0] cnt_clk;
always @(posedge  clk_i or negedge rst_n_i) begin
  if(!rst_n_i) begin
    cnt_clk         <= 8'b0;
    temp_de         <= 1'b0;
  end
  else begin
    if(rs485_tx_busy_o == 1'b1 || cnt_clk != 8'b0) begin
      temp_de       <= 1'b1;
      cnt_clk       <= 8'd1 + cnt_clk;
    end
    if(cnt_clk[5] == 1'b1) begin
      temp_de       <= 1'b0;
      cnt_clk       <= 8'b0;
    end
  end
end

assign rs485_de_o = rs485_tx_busy_o | temp_de;

endmodule

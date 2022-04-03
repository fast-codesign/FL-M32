/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        baud_rate_gen.
 *  Description:        generating clk for sampling rx/tx data. 
 *  Last updated date:  2021.11.20.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

module baud_rate_gen(
  input       clk_i,
  input       rst_n_i,
  output wire rxclk_en_o,
  output wire txclk_en_o
);
parameter CLK_HZ        = 125000000,
          RX_ACC_MAX    = CLK_HZ / (115200 * 16),
          TX_ACC_MAX    = CLK_HZ / 115200,
          RX_ACC_WIDTH  = 12,
          TX_ACC_WIDTH  = 16;

reg [11:0]  rx_acc;
reg [15:0]  tx_acc;

assign rxclk_en_o = (rx_acc == 12'd0);
assign txclk_en_o = (tx_acc == 16'd0);

always @(posedge clk_i or negedge rst_n_i) begin
  if(!rst_n_i) begin
    rx_acc        <= 12'd0;
    tx_acc        <= 16'd0;
  end
  else begin
    //* rx;
    if(rx_acc == RX_ACC_MAX)
      rx_acc      <= 12'd0;
    else
      rx_acc      <= rx_acc + 12'd1;
    //* tx;
    if(tx_acc == TX_ACC_MAX)
      tx_acc      <= 16'd0;
    else
      tx_acc      <= tx_acc + 16'd1;
  end
end

endmodule

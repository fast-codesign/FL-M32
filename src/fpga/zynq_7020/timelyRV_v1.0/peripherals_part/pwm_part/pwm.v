/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        uart.
 *  Description:        top module of uart.
 *  Last updated date:  2021.11.20.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

module pwm(
  input                 clk_i,
  input                 rst_n_i,
  output  reg           pwm_0_o,
  output  reg           pwm_1_o,

  input         [31:0]  addr_32b_i,
  input                 wren_i,
  input                 rden_i,
  input         [31:0]  din_32b_i,
  output  reg   [31:0]  dout_32b_o,
  output  reg           dout_32b_valid_o,
  output  wire          interrupt_o
);

assign interrupt_o = 0;
//* gen 1M clk;
reg   [15:0]  cnt_clk;
(* mark_debug = "true"*)reg           clk_1M_en;
always @(posedge clk_i or negedge rst_n_i) begin
  if(~rst_n_i) begin
    cnt_clk         <= 16'b0;
    clk_1M_en       <= 1'b0;
  end 
  else begin
    clk_1M_en       <= 1'b0;
    cnt_clk         <= 16'd1 + cnt_clk;
    if(cnt_clk == 16'd1024) begin
      cnt_clk       <= 16'd0;
      clk_1M_en     <= 1'd1;
    end
  end
end

//* time occupancy, each turn is 512 clks (1MHz);
(* mark_debug = "true"*)reg   [8:0]   cnt_enable, cnt_target;
always @(posedge clk_i or negedge rst_n_i) begin
  if(~rst_n_i) begin
    pwm_0_o             <= 0;
    pwm_1_o             <= 0;
    cnt_enable          <= 0;
    cnt_target          <= 0;
    //* comm with CPU;
    dout_32b_valid_o    <= 1'b0;
    dout_32b_o          <= 32'b0;
  end 
  else begin
    if(clk_1M_en) begin
      pwm_0_o             <= 0;
      pwm_1_o             <= 0;
      cnt_enable          <= cnt_enable + 9'd1;
      if(cnt_enable <= cnt_target) begin
        pwm_0_o           <= 1;
        pwm_1_o           <= 0;
      end
    end

    dout_32b_valid_o      <= wren_i | rden_i;
    if(wren_i) begin
      cnt_target          <= din_32b_i[8:0];
    end
    else if(rden_i) begin
      dout_32b_o          <= {23'b0, cnt_target};
    end
  end
end


endmodule

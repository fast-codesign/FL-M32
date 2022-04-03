/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        can.
 *  Description:        top module of can.
 *  Last updated date:  2021.11.21.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

//*******************************************************************************/
module can(
    input                   sys_clk,           //system clock 125Mhz on board
    input                   rst_n,             //reset ,low active

    input         [31:0]    addr_32b_i,
    input                   wren_i,
    input                   rden_i,
    input         [31:0]    din_32b_i,
    output  wire  [31:0]    dout_32b_o,
    output  wire            dout_32b_valid_o,
    output  reg             interrupt_o,

    inout         [7:0]     can_ad,
    output  wire            can_cs_n,
    output  wire            can_ale,
    output  wire            can_wr_n,
    output  wire            can_rd_n,
    input                   can_int_n,
    output  wire            can_rst_n,
    output  wire            can_mode
);

assign can_mode     = 1'b1; //* selete intel mode;

wire [7:0]      can_ad_i, can_ad_o;
wire            can_ad_sel;     


read_write_can rd_wr_can_inst(
    .clk(sys_clk),
    .rst_n(rst_n),
    
    .addr_32b_i(addr_32b_i),
    .wren_i(wren_i),
    .rden_i(rden_i),
    .din_32b_i(din_32b_i),
    .dout_32b_o(dout_32b_o),
    .dout_32b_valid_o(dout_32b_valid_o),
    
    .can_ad_i(can_ad_i),
    .can_ad_o(can_ad_o),
    .can_cs_n(can_cs_n),
    .can_ale(can_ale),
    .can_wr_n(can_wr_n),
    .can_rd_n(can_rd_n),
    .can_int_n(can_int_n),
    .can_rst_n(can_rst_n),
    .can_ad_sel(can_ad_sel)
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        IOBUF can_iobuf(
            .O(can_ad_i[i]),
            .IO(can_ad[i]),
            .I(can_ad_o[i]),
            .T(can_ad_sel)
        );
    end
endgenerate

//* TODO, a simple irq controller for can;
reg             tag_has_gen_irq_can;
reg     [10:0]  cnt_to_release;
always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        interrupt_o             <= 1'b0;
        tag_has_gen_irq_can     <= 1'b0;
        cnt_to_release          <= 11'b0;
    end
    else begin
        interrupt_o             <= 1'b0;

        //* gen interrupt for can, noeted that can_int_n is valid for many clocks, 
        //*   and we use cnt_to_release to guarantee generating only one interrupt once;
        cnt_to_release          <= 11'd1 + cnt_to_release;
        if(tag_has_gen_irq_can == 1'b0 && can_int_n == 1'b0) begin
            tag_has_gen_irq_can <= 1'b1;
            interrupt_o         <= 1'b1;
            cnt_to_release      <= 11'b0;
        end
        else if(can_int_n == 1'b1 || cnt_to_release[10] == 1'b1) begin
            tag_has_gen_irq_can <= 1'b0;
        end
    end
end
        

// (* mark_debug = "true"*)reg [7:0]   temp_can_ad;
// always @(posedge clk_24MHz or negedge rst_n) begin
//     if (!rst_n) begin
//         temp_can_ad     <= 8'b0;
//     end
//     else begin
//         temp_can_ad     <= can_ad;
//     end
// end

endmodule
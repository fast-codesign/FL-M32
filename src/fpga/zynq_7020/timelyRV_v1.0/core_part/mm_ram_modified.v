/*
 *  Project:            timelyRV_v1.0 -- a RISCV-32IMC SoC.
 *  Module name:        mm_ram_modified.
 *  Description:        instr/data memory of timelyRV core.
 *  Last updated date:  2022.05.06.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Noted:
 *    This module is used to store instruction & data. And we use
 *      "conf_sel" to distinguish configuring or running mode.
 */

module mm_ram_modified (
    input                 clk_i,
    input                 rst_ni,


    // interface for configuration
    input                 conf_sel,   //* 1 is configuring;
    input                 conf_rden,
    input                 conf_wren,
    input         [31:0]  conf_addr,
    input         [31:0]  conf_wdata,
    output  wire  [31:0]  conf_rdata,

    input                 instr_req_i,
    input         [31:0]  instr_addr_i,
    output  wire  [31:0]  instr_rdata_o,
    output  wire          instr_rvalid_o,
    output  wire          instr_gnt_o,

    input                 data_req_i,
    input         [31:0]  data_addr_i,
    input                 data_we_i,
    input         [ 3:0]  data_be_i,
    input         [31:0]  data_wdata_i,
    output  wire  [31:0]  data_rdata_o,
    output  wire          data_rvalid_o,
    output  wire          data_gnt_o,
    input         [ 5:0]  data_atop_i,

    input         [31:0]  pc_core_id_i
);
  assign instr_gnt_o  = instr_req_i;
  assign data_gnt_o   = data_req_i;

  //* selete one ram for writing;
  wire            [3:0]   wren_data;

  //* mux of configuration or cpu writing
  assign wren_data[0] = data_be_i[0]? data_we_i&data_req_i: 1'b0;
  assign wren_data[1] = data_be_i[1]? data_we_i&data_req_i: 1'b0;
  assign wren_data[2] = data_be_i[2]? data_we_i&data_req_i: 1'b0;
  assign wren_data[3] = data_be_i[3]? data_we_i&data_req_i: 1'b0;

  genvar i_ram;
  generate
    for (i_ram = 0; i_ram < 4; i_ram = i_ram+1) begin: ram_mem
      //* instr;
      ram_8_16384 sram_for_instr(
        .clka   (clk_i                          ),
        .wea    (conf_wren&(~conf_addr[14])     ),
        // .wea    (conf_wren                      ),
        .addra  (conf_addr[13:0]                ),
        .dina   (conf_wdata[i_ram*8+7:i_ram*8]  ),
        .douta  (conf_rdata[i_ram*8+7:i_ram*8]  ),
        .clkb   (clk_i                          ),
        .web    (1'b0                           ),
        .addrb  (instr_addr_i[13:0]             ),
        .dinb   (8'b0                           ),
        .doutb  (instr_rdata_o[i_ram*8+7:i_ram*8])
      );

      //* data;
      ram_8_16384 sram_for_data(
        .clka   (clk_i                          ),
        .wea    (conf_wren&conf_addr[14]        ),
        // .wea    (conf_wren                      ),
        .addra  (conf_addr[13:0]                ),
        .dina   (conf_wdata[i_ram*8+7:i_ram*8]  ),
        .douta  (  ),
        .clkb   (clk_i                          ),
        .web    (wren_data[i_ram]               ),
        .addrb  (data_addr_i[13:0]              ),
        .dinb   (data_wdata_i[i_ram*8+7:i_ram*8]),
        .doutb  (data_rdata_o[i_ram*8+7:i_ram*8])
      );
  end
  endgenerate

  //* assign mem_ready;
  reg [1:0] temp_ready_inst, temp_ready_data;
  always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      temp_ready_inst     <= 2'b0;
      temp_ready_data     <= 2'b0;
    end
    else begin
      temp_ready_inst     <= {temp_ready_inst[0],instr_req_i};
      temp_ready_data     <= {temp_ready_data[0],data_req_i};
    end
  end
  assign instr_rvalid_o   = temp_ready_inst[1];
  assign data_rvalid_o    = temp_ready_data[1];

endmodule
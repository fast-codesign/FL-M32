/*
 *  Project:            timelyRV_v1.0 -- a RISCV-32IMC SoC.
 *  Module name:        um_for_cpu.
 *  Description:        top module of timelyRV core.
 *  Last updated date:  2022.05.06.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Noted:
 *    1) irq for cv32e40p: {irq_fast, 4'b0, irq_external, 3'b0, irq_timer, 3'b0, 
 *                            irq_software, 3'b0};
 */

 `timescale 1 ns / 1 ps

module timelyRV_top(
   input                  clk
  ,input                  resetn
  //* interface for configuring memory
  ,input                  conf_rden
  ,input                  conf_wren
  ,input          [31:0]  conf_addr
  ,input          [31:0]  conf_wdata
  ,output   wire  [31:0]  conf_rdata
  ,input                  conf_sel
  //* interface for peripheral
  ,output   wire          peri_rden
  ,output   wire          peri_wren
  ,output   wire  [31:0]  peri_addr
  ,output   wire  [31:0]  peri_wdata
  ,output   wire  [3:0]   peri_wstrb
  ,input          [31:0]  peri_rdata
  ,input                  peri_ready
  ,input          [31:0]  irq_bitmap

//`ifdef CV32E40P
  ,input                  peri_gnt
  ,output  wire           irq_ack_o
  ,output  wire   [4:0]   irq_id_o
//`endif
);
// `ifdef CV32E40P
  import cv32e40p_apu_core_pkg::*;

  localparam  INSTR_RDATA_WIDTH = 32,
              BOOT_ADDR         = 'h180,
              PULP_XPULP        = 0,
              PULP_CLUSTER      = 0,
              FPU               = 0,
              PULP_ZFINX        = 0,
              NUM_MHPMCOUNTERS  = 1,
              DM_HALTADDRESS    = 32'h1A110800;  

  //* signals connecting core to memory
  (* mark_debug = "true"*)logic                               instr_req;
  (* mark_debug = "true"*)logic                               instr_gnt;
  (* mark_debug = "true"*)logic                               instr_rvalid;
  (* mark_debug = "true"*)logic [                 31:0]       instr_addr;
  (* mark_debug = "true"*)logic [INSTR_RDATA_WIDTH-1:0]       instr_rdata;

  (* mark_debug = "true"*)logic                               data_req, data_req_m;
  (* mark_debug = "true"*)logic                               data_gnt, data_gnt_m;
  (* mark_debug = "true"*)logic                               data_rvalid, data_rvalid_m;
  (* mark_debug = "true"*)logic [                 31:0]       data_addr;
  (* mark_debug = "true"*)logic                               data_we;
  (* mark_debug = "true"*)logic [                  3:0]       data_be;
  (* mark_debug = "true"*)logic [                 31:0]       data_rdata, data_rdata_m;
  (* mark_debug = "true"*)logic [                 31:0]       data_wdata;
  logic [                  5:0]       data_atop = 6'b0;

  // signals to debug unit
  logic                               debug_req_i = 1'b0;
  logic                               core_sleep_o;

  // APU Core to FP Wrapper
  logic                               apu_req;
  logic [    APU_NARGS_CPU-1:0][31:0] apu_operands;
  logic [      APU_WOP_CPU-1:0]       apu_op;
  logic [ APU_NDSFLAGS_CPU-1:0]       apu_flags;


  // APU FP Wrapper to Core
  logic                               apu_gnt;
  logic                               apu_rvalid;
  logic [                 31:0]       apu_rdata;
  logic [ APU_NUSFLAGS_CPU-1:0]       apu_rflags;


  //* for test;
  (* mark_debug = "true"*)wire [31:0] mem_addr_test[1:0];
  assign mem_addr_test[0] = instr_addr;
  assign mem_addr_test[1] = data_addr;

  //* instantiate the core
  cv32e40p_wrapper #(
    .PULP_XPULP         (PULP_XPULP           ),
    .PULP_CLUSTER       (PULP_CLUSTER         ),
    .FPU                (FPU                  ),
    .PULP_ZFINX         (PULP_ZFINX           ),
    .NUM_MHPMCOUNTERS   (NUM_MHPMCOUNTERS     )
  ) wrapper_i (
    .clk_i              (clk                  ),
    .rst_ni             (resetn&~conf_sel     ),

    .pulp_clock_en_i    (1'b1                 ),
    .scan_cg_en_i       (1'b0                 ),

    .boot_addr_i        (BOOT_ADDR            ),
    .mtvec_addr_i       (32'h0                ),
    .dm_halt_addr_i     (DM_HALTADDRESS       ),
    .hart_id_i          (32'h0                ),
    .dm_exception_addr_i(32'h0                ),

    .instr_addr_o       (instr_addr           ),
    .instr_req_o        (instr_req            ),
    .instr_rdata_i      (instr_rdata          ),
    .instr_gnt_i        (instr_gnt            ),
    .instr_rvalid_i     (instr_rvalid         ),

    .data_addr_o        (data_addr            ),
    .data_wdata_o       (data_wdata           ),
    .data_we_o          (data_we              ),
    .data_req_o         (data_req             ),
    .data_be_o          (data_be              ),
    .data_rdata_i       (data_rdata           ),
    .data_gnt_i         (data_gnt             ),
    .data_rvalid_i      (data_rvalid          ),

    .apu_req_o          (apu_req              ),
    .apu_gnt_i          (apu_gnt              ),
    .apu_operands_o     (apu_operands         ),
    .apu_op_o           (apu_op               ),
    .apu_flags_o        (apu_flags            ),
    .apu_rvalid_i       (apu_rvalid           ),
    .apu_result_i       (apu_rdata            ),
    .apu_flags_i        (apu_rflags           ),

    // .irq_i              (32'b0),
    .irq_i              (irq_bitmap           ),
    .irq_ack_o          (irq_ack_o            ),
    .irq_id_o           (irq_id_o             ),

    .debug_req_i        (debug_req_i          ),
    .debug_havereset_o  (                     ),
    .debug_running_o    (                     ),
    .debug_halted_o     (                     ),

    .fetch_enable_i     (1'b1                 ),
    .core_sleep_o       (core_sleep_o         )
  );

  //* TODO, to add FPU ...
  assign apu_gnt      = '0;
  assign apu_rvalid   = '0;
  assign apu_rdata    = '0;
  assign apu_rflags   = '0;

  generate
    if (FPU) begin
      cv32e40p_fp_wrapper fp_wrapper_i (
        .clk_i          (clk                 ),
        .rst_ni         (resetn              ),
        .apu_req_i      (apu_req             ),
        .apu_gnt_o      (apu_gnt             ),
        .apu_operands_i (apu_operands        ),
        .apu_op_i       (apu_op              ),
        .apu_flags_i    (apu_flags           ),
        .apu_rvalid_o   (apu_rvalid          ),
        .apu_rdata_o    (apu_rdata           ),
        .apu_rflags_o   (apu_rflags          )
      );
    end
  endgenerate

  //* this handles read to RAM and memory mapped pseudo peripherals
  mm_ram_modified memory (
    .clk_i              (clk                  ),
    .rst_ni             (resetn               ),

    .conf_sel           (conf_sel             ),
    .conf_rden          (conf_rden            ),
    .conf_wren          (conf_wren            ),
    .conf_addr          (conf_addr            ),
    .conf_wdata         (conf_wdata           ),
    .conf_rdata         (conf_rdata           ),

    .instr_req_i        (instr_req            ),
    .instr_addr_i       ({2'b0,instr_addr[31:2]}),
    .instr_rdata_o      (instr_rdata          ),
    .instr_rvalid_o     (instr_rvalid         ),
    .instr_gnt_o        (instr_gnt            ),

    .data_req_i         (data_req_m           ),
    .data_addr_i        ({2'b0,data_addr[31:2]}),
    .data_we_i          (data_we              ),
    .data_be_i          (data_be              ),
    .data_wdata_i       (data_wdata           ),
    .data_rdata_o       (data_rdata_m         ),
    .data_rvalid_o      (data_rvalid_m        ),
    .data_gnt_o         (data_gnt_m           ),
    .data_atop_i        (data_atop            ),

    // .pc_core_id_i(wrapper_i.core_i.pc_id),
    .pc_core_id_i       (0                    )

    // ,.tests_passed_o      (tests_passed_o     )
    // ,.tests_failed_o      (tests_failed_o     )
    // ,.exit_valid_o        (exit_valid_o       )
    // ,.exit_value_o        (exit_value_o       )
  );

  //* assign memory interface signals, top 4b of data sram is "0";
  assign data_req_m = (data_addr[31:28] == 4'b0)? data_req : 1'b0;
  //* all to peri;
  assign peri_wren  = data_req & data_we;
  assign peri_rden  = data_req & (data_we == 1'b0);
  assign peri_addr  = data_addr;
  assign peri_wdata = data_wdata;
  assign peri_wstrb = data_be;
  //* return back;
  assign data_rdata = (data_rvalid_m == 1'b1)? data_rdata_m: peri_rdata;
  assign data_rvalid= data_rvalid_m | peri_ready;
  assign data_gnt   = data_req_m | peri_gnt;

// `else
//   /** sram interface for instruction and data*/
//   (* mark_debug = "true"*)wire        mem_valid;            //  read/write is valid;
//   (* mark_debug = "true"*)wire        mem_instr;            //  read instr, not used;
//   (* mark_debug = "true"*)wire        mem_wren;             //  write data request
//   (* mark_debug = "true"*)wire        mem_rden;             //  read data request
//   (* mark_debug = "true"*)wire        mem_ready, mem_ready_mem;            //  read/write ready;
//   (* mark_debug = "true"*)wire [31:0] mem_addr;             //  write/read addr
//   (* mark_debug = "true"*)wire [31:0] mem_wdata;            //  write data
//   (* mark_debug = "true"*)wire [3:0]  mem_wstrb;            //  write wstrb
//   (* mark_debug = "true"*)wire [31:0] mem_rdata, mem_rdata_mem;            //  data

//   //* for test;
//   (* mark_debug = "true"*)wire [29:0] mem_addr_test;
//   assign mem_addr_test = mem_addr[31:2];

//   reg  [31:0] clk_counter;          //  timer;
//   reg         finish_tag;           //  finish_tag is 0 when cpu writes 0x20000000;

//   (* mark_debug = "true"*)wire        trap;

//   picorv32_simplified picorv32(
//     .clk            (clk                        ),
//     .resetn         (resetn&~conf_sel&finish_tag),
//     .trap           (trap                       ),
//     .mem_valid      (mem_valid                  ),
//     .mem_instr      (mem_instr                  ),
//     .mem_ready      (mem_ready                  ),
//     .mem_addr       (mem_addr                   ),
//     .mem_wdata      (mem_wdata                  ),
//     .mem_wstrb      (mem_wstrb                  ),
//     .mem_rdata      (mem_rdata                  ),
//     .mem_la_read    (                           ),
//     .mem_la_write   (                           ),
//     .mem_la_addr    (                           ),
//     .mem_la_wdata   (                           ),
//     .mem_la_wstrb   (                           ),
//     .irq            (irq_bitmap                 ),
//     .eoi            (                           ),
//     .trace_valid    (                           ),
//     .trace_data     (                           )
//   );


//   memory mem(
//     .clk            (clk                        ),
//     .resetn         (resetn                     ),
//     .mem_wren       (mem_wren                   ),
//     .mem_rden       (mem_rden                   ),
//     .mem_addr       ({2'b0,mem_addr[31:2]}      ),
//     .mem_wdata      (mem_wdata                  ),
//     .mem_wstrb      (mem_wstrb                  ),
//     .mem_rdata      (mem_rdata_mem              ),
//     .mem_ready      (mem_ready_mem              ),

//     .conf_sel       (conf_sel                   ),
//     .conf_rden      (conf_rden                  ),
//     .conf_wren      (conf_wren                  ),
//     .conf_addr      (conf_addr                  ),
//     .conf_wdata     (conf_wdata                 ),
//     .conf_rdata     (conf_rdata                 )
//   );

//   //* assign memory interface signals, top 4b of isntr/data sram is "0";
//   assign mem_wren = (mem_addr[31:28] == 4'b0)? mem_valid & (|mem_wstrb) : 1'b0;
//   assign mem_rden = (mem_addr[31:28] == 4'b0)? mem_valid & (mem_wstrb == 4'b0): 1'b0;
//   //* all to peri;
//   assign peri_wren = mem_valid & (|mem_wstrb);
//   assign peri_rden = mem_valid & (mem_wstrb == 4'b0);
//   assign peri_addr = mem_addr;
//   assign peri_wdata = mem_wdata;
//   assign peri_wstrb = mem_wstrb;
//   //* return back;
//   assign mem_rdata = (mem_ready_mem == 1'b1)? mem_rdata_mem: peri_rdata;
//   assign mem_ready = mem_ready_mem | peri_ready;

//   //* assign finish_tag;
//   always @(posedge clk or negedge resetn) begin
//     if (!resetn) begin
//       finish_tag      <= 1'b1;
//     end
//     else begin
//       if(mem_addr == 32'h20000000 && mem_wren == 1'b1)
//         finish_tag    <= 1'b0;
//       else
//         finish_tag    <= finish_tag|conf_sel;
//     end
//   end
// `endif


endmodule


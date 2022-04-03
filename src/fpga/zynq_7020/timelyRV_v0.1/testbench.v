// Copyright (C) lijunnan
// Verilog module name - testbench 
// Version: 
// Created:
//         by -  
//         at - 2021/07/09
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module testbench(
  
);

  reg           clk,rst_n;
  reg   [133:0] pktData_gmii;
  reg           pktData_valid_gmii;
  wire  [133:0] pktData_um;
  wire          pktData_valid_um;


  um_for_cpu UMforCPU(
      .clk(clk),
      .rst_n(rst_n),
      .data_in_valid(pktData_valid_gmii),
      .data_in(pktData_gmii),
      .data_out_valid(pktData_valid_um),
      .data_out(pktData_um),

      //* left for packet process;
      .mem_wren(),
      .mem_rden(),
      .mem_addr(),
      .mem_wdata(),
      .mem_rdata(32'b0),
      .cpu_ready()
  );

  initial begin
    clk = 0;
    rst_n = 0;
    #10 rst_n = 1;
    forever #1 clk = ~clk;
  end
  
  localparam  DATA_WR_SEL       = 128'h1111_2222_3333_4444_5555_6666_9001_0000,  // write conf_sel;
              DATA_RD_SEL       = 128'h1111_2222_3333_4444_5555_6666_9002_0000,  // read conf_sel;
              DATA_WR_PROGM     = 128'h1111_2222_3333_4444_5555_6666_9003_0000,  // write program;
              DATA_RD_PROGM     = 128'h1111_2222_3333_4444_5555_6666_9004_0000,  // read program;
              DATA_SET_SEL_1    = 128'h1_0000,  // write conf_sel with 1;
              DATA_SET_SEL_0    = 128'h0,       // write conf_sel with 0;
              PAD               = 128'h0,       // pad with 0;
              DATA_SET_PROGM_0  = 128'h1000_0537_0000_0000_0000,  // write program;
              DATA_SET_PROGM_1  = 128'h0440_0593_0000_0001_0001,  // write program;
              DATA_SET_PROGM_2  = 128'h04f0_0613_0000_0002_0002,  // write program;
              DATA_SET_PROGM_3  = 128'h04e0_0693_0000_0003_0003,  // write program;
              DATA_SET_PROGM_4  = 128'h0450_0713_0000_0004_0004,  // write program;
              DATA_SET_PROGM_5  = 128'h00a0_0793_0000_0005_0005,  // write program;
              DATA_SET_PROGM_6  = 128'h00b5_2023_0000_0006_0006,  // write program;
              DATA_SET_PROGM_7  = 128'h00c5_2023_0000_0007_0007,  // write program;
              DATA_SET_PROGM_8  = 128'h00d5_2023_0000_0008_0008,  // write program;
              DATA_SET_PROGM_9  = 128'h00e5_2023_0000_0009_0009,  // write program;
              DATA_SET_PROGM_10 = 128'h00f5_2023_0000_000a_000a,  // write program;
              DATA_SET_PROGM_11 = 128'h2000_0537_0000_000b_000b,  // write program;
              DATA_SET_PROGM_12 = 128'h0005_0513_0000_000c_000c,  // write program;
              DATA_SET_PROGM_13 = 128'h075b_d5b7_0000_000d_000d,  // write program;
              DATA_SET_PROGM_14 = 128'hd155_8593_0000_000e_000e,  // write program;
              DATA_SET_PROGM_15 = 128'h00b5_2023_0000_000f_000f,  // write program;
              DATA_RD_PROGM_1   = 128'h0440_0593_0000_0001_0001,  // read program;
              DATA_RD_PROGM_2   = 128'h04f0_0613_0000_0002_0002;  // read program;
  
  // initial begin
  //   pktData_valid_gmii  = 1'b0;
  //   pktData_gmii        = 134'b0;

  //   //* set conf_sel with 1;
  //   #50 begin
  //       pktData_valid_gmii  = 1'b1;
  //       pktData_gmii        = {2'b01,4'hf,DATA_WR_SEL};
  //   end
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_SEL_1};
  //   #2  pktData_gmii        = {2'b00,4'hf,PAD};
  //   #2  pktData_gmii        = {2'b10,4'hf,PAD};
  //   #2  pktData_valid_gmii  = 1'b0;

  //   //* write program;
  //   #20 begin
  //       pktData_valid_gmii  = 1'b1;
  //       pktData_gmii        = {2'b01,4'hf,DATA_WR_PROGM};
  //   end
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_0};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_1};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_2};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_3};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_4};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_5};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_6};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_7};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_8};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_9};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_10};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_11};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_12};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_13};
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_PROGM_14};
  //   #2  pktData_gmii        = {2'b10,4'hf,DATA_SET_PROGM_15};
  //   #2  pktData_valid_gmii  = 1'b0;

  //   //* set conf_sel with 0, start cpu;
  //   #51 begin
  //       pktData_valid_gmii  = 1'b1;
  //       pktData_gmii        = {2'b01,4'hf,DATA_WR_SEL};
  //   end
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_SET_SEL_0};
  //   #2  pktData_gmii        = {2'b00,4'hf,PAD};
  //   #2  pktData_gmii        = {2'b10,4'hf,PAD};
  //   #2  pktData_valid_gmii  = 1'b0;

  //   //* read conf_sel;
  //   #51 begin
  //       pktData_valid_gmii  = 1'b1;
  //       pktData_gmii        = {2'b01,4'hf,DATA_RD_SEL};
  //   end
  //   #2  pktData_gmii        = {2'b00,4'hf,PAD};
  //   #2  pktData_gmii        = {2'b00,4'hf,PAD};
  //   #2  pktData_gmii        = {2'b10,4'hf,PAD};
  //   #2  pktData_valid_gmii  = 1'b0;

  //   //* read program_1;
  //   #51 begin
  //       pktData_valid_gmii  = 1'b1;
  //       pktData_gmii        = {2'b01,4'hf,DATA_RD_PROGM};
  //   end
  //   #2  pktData_gmii        = {2'b00,4'hf,DATA_RD_PROGM_1};
  //   #2  pktData_gmii        = {2'b00,4'hf,PAD};
  //   #2  pktData_gmii        = {2'b10,4'hf,PAD};
  //   #2  pktData_valid_gmii  = 1'b0;

  // end

  /** read firmware.hex and write memory */
  reg [1023:0]  firmware_file;
  reg [31:0]    memory[0:64*1024/4-1]  /* verilator public */;
  initial begin
    if (!$value$plusargs("firmware=%s", firmware_file))
      firmware_file = "D:/1-code/vivado/picorv32i_modified_1026/picorv32i_modified.sim/sim_1/behav/xsim/firmware.hex";
    $readmemh(firmware_file, memory);
  end

  reg [1:0]     tag_conf; //* '0' to set conf_sel with 1;
                          //* '1' to configure program;
                          //* '2' to set conf_sel with 0;
                          //* '3' to maintain this state;
  reg [7:0]     cnt_wait;
  reg [15:0]    count_instr;
  reg [4:0]     state_conf;
  localparam    IDLE_S          = 5'd0,
                CONF_SEL_1      = 5'd1,
                CONF_SET_SEL_1  = 5'd2,
                CONF_PAD_2      = 5'd3,
                CONF_PAD_1      = 5'd4,
                CONF_SEL_0      = 5'd5,
                CONF_SET_SEL_0  = 5'd6,
                CONF_PROGM      = 5'd7,
                CONF_PROGM_TAIL = 5'd8;


  reg [31:0] mem_rdata;
  task handle_mem_rdata; begin
    if (count_instr < 64*1024) begin
      mem_rdata <= memory[count_instr];
    end
  end endtask

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      pktData_valid_gmii        <= 1'b0;
      pktData_gmii              <= 134'b0;
      tag_conf                  <= 2'b0;
      cnt_wait                  <= 8'b0;
      count_instr               <= 16'b0;
    end
    else begin
      case(state_conf)
        IDLE_S: begin
          pktData_valid_gmii    <= 1'b0;
          cnt_wait              <= cnt_wait + 8'd1;
          if(cnt_wait[7] == 1'b1) begin
            (*full_case, parallel_case*)
            case(tag_conf)
              2'd0: state_conf  <= CONF_SEL_1;
              2'd1: state_conf  <= CONF_PROGM;
              2'd2: state_conf  <= CONF_SEL_0;
              2'd3: state_conf  <= IDLE_S;
            endcase
          end
          else begin
            state_conf          <= IDLE_S;
          end
        end
        CONF_SEL_1: begin
          tag_conf              <= 2'd1 + tag_conf;
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b01,4'hf,DATA_WR_SEL};
          state_conf            <= CONF_SET_SEL_1;
        end
        CONF_SET_SEL_1: begin
          pktData_gmii          <= {2'b00,4'hf,DATA_SET_SEL_1};
          state_conf            <= CONF_PAD_2;
        end
        CONF_PAD_2: begin
          pktData_gmii          <= {2'b00,4'hf,PAD};
          state_conf            <= CONF_PAD_1;
        end
        CONF_PAD_1: begin
          pktData_gmii          <= {2'b10,4'hf,PAD};
          state_conf            <= IDLE_S;
          cnt_wait              <= 8'b0;
        end
        CONF_PROGM: begin
          tag_conf              <= 2'd1 + tag_conf;
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b01,4'hf,DATA_WR_PROGM};
          count_instr           <= 16'd1;
          state_conf            <= CONF_PROGM_TAIL;
          handle_mem_rdata;
        end
        CONF_PROGM_TAIL: begin
          count_instr           <= count_instr + 16'd1;
          pktData_gmii          <= {2'b00,4'hf,48'b0,mem_rdata,{16'b0,count_instr-16'd1},16'b0};
          handle_mem_rdata;

          if(count_instr == 16'd10000) begin
            state_conf          <= IDLE_S;
            count_instr         <= 16'b0;
            cnt_wait            <= 8'b0;
            pktData_gmii[133:132] <= 2'b10;
          end
        end
        CONF_SEL_0: begin
          tag_conf              <= 2'd1 + tag_conf;
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b01,4'hf,DATA_WR_SEL};
          state_conf            <= CONF_SET_SEL_0;
        end
        CONF_SET_SEL_0: begin
          pktData_gmii          <= {2'b00,4'hf,DATA_SET_SEL_0};
          state_conf            <= CONF_PAD_2;
        end

        default: state_conf     <= IDLE_S;
      endcase
    end
  end

endmodule

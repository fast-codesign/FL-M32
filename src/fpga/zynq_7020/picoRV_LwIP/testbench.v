// Verilog module name - testbench 
// Version: 
// Created:
//         by - lijunnan
//         at - 2022/03/21
// Description:
//         for LwIP

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

      .led_out(),
      .uart_rx(1'b1),
      .uart_tx(),
      .uart_cts_i(),

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
              DATA_RD_PROGM_2   = 128'h04f0_0613_0000_0002_0002,  // read program;
              ARP_0             = 128'hffff_ffff_ffff_000b_3601_0203_0806_0001,
              ARP_1             = 128'h0800_0604_0001_000b_3601_0203_c0a8_010b,
              ARP_2             = 128'h0000_0000_0000_c0a8_010a_0000_0000_0000,
              ARP_2_64b         = 128'h0000_0000_0000_c0a8_010a_0000_ffff_ffff,
              ARP_3_64b         = 128'hffff_0023_cd76_631a_0806_0001_7374_7576,
              ICMP_0            = 128'h000a_3500_0102_000b_3601_0203_0800_4500,
              ICMP_1            = 128'h003c_7919_0000_4001_7e42_c0a8_010b_c0a8,
              ICMP_2            = 128'h010a_0800_445c_0400_0500_6162_6364_6566,
              ICMP_3            = 128'h6768_696a_6b6c_6d6e_6f70_7172_7374_7576,
              ICMP_4            = 128'h7761_6263_6465_6667_6869_0000_0000_0000;
              

  /** read firmware.hex and write memory */
  reg [1023:0]  firmware_file;
  reg [31:0]    memory[0:128*1024/4-1]  /* verilator public */;
  initial begin
    if (!$value$plusargs("firmware=%s", firmware_file))
      firmware_file = "D:/0-code/zynq7020/picorv32i_modified_lwip/icore_source-ok/firmware.hex";
    $readmemh(firmware_file, UMforCPU.picoTop.mem.memory);
  end

  reg [1:0]     tag_conf; //* '0' to set conf_sel with 1;
                          //* '1' to configure program;
                          //* '2' to set conf_sel with 0;
                          //* '3' to maintain this state;
  reg [7:0]     cnt_wait;
  reg [15:0]    count_instr, cnt_wait_16b;
  reg [4:0]     state_conf;
  localparam    IDLE_S          = 5'd0,
                CONF_SEL_1      = 5'd1,
                CONF_SET_SEL_1  = 5'd2,
                CONF_PAD_2      = 5'd3,
                CONF_PAD_1      = 5'd4,
                CONF_SEL_0      = 5'd5,
                CONF_SET_SEL_0  = 5'd6,
                CONF_PROGM      = 5'd7,
                CONF_PROGM_TAIL = 5'd8,
                SEND_ARP_0_S    = 5'd9,
                SEND_ARP_1_S    = 5'd10,
                SEND_ARP_2_S    = 5'd11,
                SEND_WAIT_S     = 5'd12,
                BYPASS_S        = 5'd13,
                SEND_ARP_2_64b_S= 5'd14,
                SEND_ARP_3_64b_S= 5'd15,
                SEND_ICMP_0_S   = 5'd16,
                SEND_ICMP_1_S   = 5'd17,
                SEND_ICMP_2_S   = 5'd18,
                SEND_ICMP_3_S   = 5'd19,
                SEND_ICMP_4_S   = 5'd20;


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
      cnt_wait_16b              <= 16'b0;
      count_instr               <= 16'b0;
    end
    else begin
      case(state_conf)
        IDLE_S: begin
          pktData_valid_gmii    <= 1'b0;
          cnt_wait              <= cnt_wait + 8'd1;
          if(cnt_wait[7] == 1'b1) begin
            (*full_case, parallel_case*)
            // case(tag_conf)
            //   2'd0: state_conf  <= CONF_SEL_1;
            //   2'd1: state_conf  <= CONF_PROGM;
            //   2'd2: state_conf  <= CONF_SEL_0;
            //   2'd3: state_conf  <= IDLE_S;
            // endcase
            case(tag_conf)
              2'd0: state_conf  <= BYPASS_S;
              2'd1: state_conf  <= BYPASS_S;
              2'd2: state_conf  <= CONF_SEL_0;
              2'd3: state_conf  <= IDLE_S;
            endcase
          end
          else if(tag_conf == 2'd3) begin
            state_conf          <= (cnt_wait_16b[12] == 1'b1)? SEND_ARP_0_S: IDLE_S;
            cnt_wait_16b        <= 16'd1 + cnt_wait_16b;
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
        SEND_ARP_0_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b01,4'hf,ARP_0};
          state_conf            <= SEND_ARP_1_S;
        end
        SEND_ARP_1_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b00,4'hf,ARP_1};
          state_conf            <= SEND_ARP_2_64b_S;
        end
        SEND_ARP_2_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b10,4'h9,ARP_2};
          state_conf            <= SEND_WAIT_S;
          cnt_wait_16b          <= 16'd0;
        end
        SEND_ARP_2_64b_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b00,4'hf,ARP_2_64b};
          state_conf            <= SEND_ARP_3_64b_S;
        end
        SEND_ARP_3_64b_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b10,4'hf,ARP_3_64b};
          state_conf            <= SEND_WAIT_S;
          cnt_wait_16b          <= 16'd0;
        end
        SEND_ICMP_0_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b01,4'hf,ICMP_0};
          state_conf            <= SEND_ICMP_1_S;
        end
        SEND_ICMP_1_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b00,4'hf,ICMP_1};
          state_conf            <= SEND_ICMP_2_S;
        end
        SEND_ICMP_2_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b00,4'hf,ICMP_2};
          state_conf            <= SEND_ICMP_3_S;
        end
        SEND_ICMP_3_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b00,4'hf,ICMP_3};
          state_conf            <= SEND_ICMP_4_S;
        end
        SEND_ICMP_4_S: begin
          pktData_valid_gmii    <= 1'b1;
          pktData_gmii          <= {2'b10,4'h9,ICMP_4};
          state_conf            <= SEND_WAIT_S;
          cnt_wait_16b          <= 16'd0;
        end
        SEND_WAIT_S: begin
          pktData_valid_gmii    <= 1'b0;
          state_conf            <= (cnt_wait_16b[12] == 1'b1)? SEND_ICMP_0_S: SEND_WAIT_S;
          cnt_wait_16b          <= 16'd1 + cnt_wait_16b;
        end
        BYPASS_S: begin //* bypass
          tag_conf              <= 2'd1 + tag_conf;
          state_conf            <= IDLE_S;
        end
        default: state_conf     <= IDLE_S;
      endcase
    end
  end

endmodule

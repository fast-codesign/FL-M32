/*
 *  Project:            timelyRV_v0.1 -- a RISCV-32I SoC.
 *  Module name:        recv_send_pkt.
 *  Description:        This module is used to process packets.
 *  Last updated date:  2022.04.16.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 */

`timescale 1 ns / 1 ps

module procPkt(
  input               clk,
  input               rst_n,

  input               data_in_valid,  // input data valid
  input       [133:0] data_in, 

  (* mark_debug = "true"*)output  reg         data_out_valid, // output data valid
  (* mark_debug = "true"*)output  reg [133:0] data_out,       // output data

  input               memPkt_rden,    // mem interface
  input               memPkt_wren,
  input       [31:0]  memPkt_addr,
  input       [31:0]  memPkt_wdata,
  input       [3:0]   memPkt_wstrb,
  output  reg [31:0]  memPkt_rdata,
  output  reg         memPkt_ready,
  output  wire        interrupt_o 
);

//* TODO, ...
assign interrupt_o = 1'b0;

//* ram signals;
(* mark_debug = "true"*)reg   [9:0]   addr_pkt_hw, addr_pkt_sw;
(* mark_debug = "true"*)reg   [3:0]   wren_pkt_hw, wren_pkt_sw;
(* mark_debug = "true"*)reg   [31:0]  din_pkt_hw, din_pkt_sw;
(* mark_debug = "true"*)wire  [31:0]  dout_pkt_hw, dout_pkt_sw;
//* fifo signals;
(* mark_debug = "true"*)reg   [133:0] din_pktRecv, din_pktSend;
(* mark_debug = "true"*)reg           wren_pktRecv, wren_pktSend;
(* mark_debug = "true"*)reg           rden_pktRecv, rden_pktSend;
(* mark_debug = "true"*)wire  [133:0] dout_pktRecv, dout_pktSend;
(* mark_debug = "true"*)wire          empty_pktRecv, empty_pktSend;
wire  [9:0]   usedw_pktRecv;

//* recv pkt;
reg   [15:0]  recv_length;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // reset
    din_pktRecv             <= 134'b0;  //* fifo interface;
    wren_pktRecv            <= 1'b0;
    recv_length             <= 0;
  end
  else begin
    din_pktRecv             <= data_in;
    if(data_in_valid == 1'b1 && data_in[133:132] == 2'b01 &&
      data_in[31:24] != 8'h90 && usedw_pktRecv < 10'd400) 
    begin
      `ifdef FILT_PKT_WITH_MAC
        if(data_in[127:80] == `NIC_MAC_ADDR || (&data_in[127:80]) == 1'b1)
          wren_pktRecv      <= 1'b1;
      `else
        wren_pktRecv        <= 1'b1;
      `endif
      recv_length           <= 16'b0;
    end
    else begin
      wren_pktRecv          <= wren_pktRecv & data_in_valid;
      recv_length           <= (wren_pktRecv == 1'b1)? (recv_length + 16'd16): recv_length;
      //* write length after receiving one completed pkt;
      if(wren_pktRecv == 1'b1 && din_pktRecv[133:132] == 2'b10) begin
        wren_pktRecv        <= 1'b1;
        din_pktRecv         <= 134'b0;
        din_pktRecv[15:0]   <= recv_length + 16'd1 + {12'b0, din_pktRecv[131:128]};
      end
    end
  end
end

//* write pkt from fifo to sram, and read pkt from sram to fifo;
reg   [1:0]   count_data;
(* mark_debug = "true"*)reg   [3:0]   state_checkPkt;
(* mark_debug = "true"*)reg   [15:0]  send_length;
reg   [1:0]   head_tag;
reg   [133:0] temp_pktRecv;
localparam  IDLE_S              = 4'd0,
            WAIT_1_CLK_S        = 4'd1,
            WAIT_2_CLK_S        = 4'd2,
            CHECK_RECV_S        = 4'd3,
            WRITE_RECV_PKT_S    = 4'd4,
            WRITE_RECV_LENGTH_S = 4'd5,
            WRITE_RECV_TAG_S    = 4'd6,
            CHECK_SEND_S        = 4'd7,
            READ_SEND_LENGTH_S  = 4'd8,
            READ_SEND_PKT_S     = 4'd9;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // reset
    addr_pkt_hw             <= 0;
    wren_pkt_hw             <= 4'b0;
    din_pkt_hw              <= 32'b0;

    din_pktSend             <= {2'b10,132'b0};
    wren_pktSend            <= 1'b0;
    rden_pktRecv            <= 1'b0;
    count_data              <= 2'b0;
    temp_pktRecv            <= 134'b0;
    send_length             <= 16'b0;
    head_tag                <= 2'b0;

    state_checkPkt          <= IDLE_S;
  end
  else begin
    case(state_checkPkt)
      IDLE_S: begin
        wren_pkt_hw         <= 4'b0;
        wren_pktSend        <= 1'b0;
        if(empty_pktRecv == 1'b0)
          addr_pkt_hw       <= 0;           //* check recv tag;
        else
          addr_pkt_hw       <= {1'b1,9'b0}; //* check send tag;
        state_checkPkt      <= WAIT_1_CLK_S;
      end
      WAIT_1_CLK_S: begin
        addr_pkt_hw         <= addr_pkt_hw + 10'd1;
        state_checkPkt      <= WAIT_2_CLK_S;
      end
      WAIT_2_CLK_S: begin
        addr_pkt_hw         <= addr_pkt_hw + 10'd1;
        if(addr_pkt_hw[9] == 1'b0)
          state_checkPkt    <= CHECK_RECV_S;
        else
          state_checkPkt    <= CHECK_SEND_S;
      end
      CHECK_RECV_S: begin
        //* write pkt from fifo to sram;
        if(dout_pkt_hw[24] == 1'd0) begin
          rden_pktRecv      <= 1'b1;
          count_data        <= 2'b0;
          addr_pkt_hw       <= 10'd1;
          state_checkPkt    <= WRITE_RECV_PKT_S;
        end
        else begin
          addr_pkt_hw       <= {1'b1,9'b0}; //* check send tag;
          state_checkPkt    <= WAIT_1_CLK_S;
        end
      end
      WRITE_RECV_PKT_S: begin
        rden_pktRecv        <= 1'b0;
        wren_pkt_hw         <= 4'hf;
        addr_pkt_hw         <= addr_pkt_hw + 10'd1;
        count_data          <= 2'd1 + count_data;
        (* full_case, parallel_case*)
        case(count_data)
          2'd0: din_pkt_hw  <= dout_pktRecv[32*3+:32];
          2'd1: din_pkt_hw  <= temp_pktRecv[32*2+:32];
          2'd2: din_pkt_hw  <= temp_pktRecv[32*1+:32];
          2'd3: din_pkt_hw  <= temp_pktRecv[32*0+:32];
        endcase
        if(count_data == 2'd3) begin
          rden_pktRecv      <= 1'b1;
          if(temp_pktRecv[133:132] == 2'b10)
            state_checkPkt  <= WRITE_RECV_LENGTH_S;
          else
            state_checkPkt  <= WRITE_RECV_PKT_S;
        end
        // else if((count_data == temp_pktRecv[131:130] && count_data != 2'b0) || 
        //   (count_data == dout_pktRecv[131:130] && count_data == 2'b0))
        // begin
        //   rden_pktRecv      <= 1'b1;
        //   state_checkPkt    <= WRITE_RECV_LENGTH_S;
        // end
        temp_pktRecv        <= (rden_pktRecv)? dout_pktRecv: temp_pktRecv;
      end
      WRITE_RECV_LENGTH_S: begin
        rden_pktRecv        <= 1'b0;
        wren_pkt_hw         <= 4'hf;
        addr_pkt_hw         <= 10'd1;
        din_pkt_hw          <= {dout_pktRecv[7:0],dout_pktRecv[15:8],16'b0};
        state_checkPkt      <= WRITE_RECV_TAG_S;
      end
      WRITE_RECV_TAG_S: begin
        wren_pkt_hw         <= 4'hf;
        addr_pkt_hw         <= 10'd0;
        din_pkt_hw          <= {8'd1,24'b0};
        state_checkPkt      <= IDLE_S;
      end
      CHECK_SEND_S: begin
        addr_pkt_hw         <= addr_pkt_hw + 10'd1;
        //* write pkt from fifo to sram;
        if(dout_pkt_hw[24] == 1'd1) begin
          state_checkPkt    <= READ_SEND_LENGTH_S;
        end
        else begin
          state_checkPkt    <= IDLE_S;
        end
      end
      READ_SEND_LENGTH_S: begin
        addr_pkt_hw         <= addr_pkt_hw + 10'd1;
        count_data          <= 2'b0;
        head_tag            <= 2'b1;
        send_length         <= {dout_pkt_hw[23:16], dout_pkt_hw[31:24]} - 16'd1;
        state_checkPkt      <= READ_SEND_PKT_S;
      end
      READ_SEND_PKT_S: begin
        wren_pktSend        <= 1'b0;
        addr_pkt_hw         <= addr_pkt_hw + 10'd1;
        count_data          <= count_data + 2'd1;
        send_length         <= send_length - 16'd4;
        (* full_case, parallel_case*)
        case(count_data)
          4'd0: din_pktSend[32*3+:32]  <= dout_pkt_hw;
          4'd1: din_pktSend[32*2+:32]  <= dout_pkt_hw;
          4'd2: din_pktSend[32*1+:32]  <= dout_pkt_hw;
          4'd3: din_pktSend[32*0+:32]  <= dout_pkt_hw;
        endcase
        if(send_length[15:2] == 14'b0) begin
          wren_pktSend                <= 1'b1;
          din_pktSend[133:128]        <= {2'b10, count_data, send_length[1:0]};

          //* write sending tag with '0';
          wren_pkt_hw                 <= 4'hf;
          din_pkt_hw                  <= 32'd0;
          addr_pkt_hw                 <= {1'b1,9'b0};

          state_checkPkt              <= IDLE_S;
        end
        else if(count_data == 2'd3) begin
          wren_pktSend                <= 1'b1;
          head_tag                    <= 2'b0;
          din_pktSend[133:128]        <= {head_tag,4'hf};
          state_checkPkt              <= READ_SEND_PKT_S;
        end
      end
      default: begin 
        state_checkPkt                <= IDLE_S;
      end
    endcase
  end
end

//* send pkt;
(* mark_debug = "true"*)reg   [7:0]   cnt_pkt;
(* mark_debug = "true"*)reg   [3:0]   state_sendPkt;
localparam  WAIT_TAIL_S         = 4'd1;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // reset
    data_out                <= 134'b0;  //* fifo interface;
    data_out_valid          <= 1'b0;

    rden_pktSend            <= 1'b0;

    cnt_pkt                 <= 0;
    state_sendPkt           <= IDLE_S;
  end
  else begin
    //* count pkt in fifo_pktSend;
    if(wren_pktSend == 1'b1 && din_pktSend[133:132] == 2'b10)
      if(data_out_valid == 1'b1 && data_out[133:132] == 2'b01)
        cnt_pkt             <= cnt_pkt;
      else
        cnt_pkt             <= cnt_pkt + 8'd1;
    else if(data_out_valid == 1'b1 && data_out[133:132] == 2'b01)
      cnt_pkt               <= cnt_pkt - 8'd1;
    else
      cnt_pkt               <= cnt_pkt;
    
    //* send pkt;
    case(state_sendPkt)
      IDLE_S: begin
        data_out_valid      <= 1'b0;
        if(cnt_pkt != 8'd0) begin
          rden_pktSend      <= 1'b1;
          state_sendPkt     <= WAIT_TAIL_S;
        end
      end
      WAIT_TAIL_S: begin
        data_out_valid      <= 1'b1;
        data_out            <= dout_pktSend;
        if(dout_pktSend[133:132] == 2'b10) begin
          rden_pktSend      <= 1'b0;
          state_sendPkt     <= IDLE_S;
        end
      end
      default: begin
        state_sendPkt       <= IDLE_S;
      end
    endcase
  end
end

/** fifo used to buffer recv/send pkt*/
fifo_134b_512 fifo_pktRecv (
  .clk(clk),              // input wire clk
  .srst(!rst_n),          // input wire srst
  .din(din_pktRecv),      // input wire [133 : 0] din
  .wr_en(wren_pktRecv),   // input wire wr_en
  .rd_en(rden_pktRecv),   // input wire rd_en
  .dout(dout_pktRecv),    // output wire [133 : 0] dout
  .full(),                // output wire full
  .empty(empty_pktRecv),  // output wire empty
  .data_count(usedw_pktRecv)
);

fifo_134b_512 fifo_pktSend (
  .clk(clk),              // input wire clk
  .srst(!rst_n),          // input wire srst
  .din(din_pktSend),      // input wire [133 : 0] din
  .wr_en(wren_pktSend),   // input wire wr_en
  .rd_en(rden_pktSend),   // input wire rd_en
  .dout(dout_pktSend),    // output wire [133 : 0] dout
  .full(),                // output wire full
  .empty(empty_pktSend)   // output wire empty
);



reg   [3:0]   temp_rden_pkt_sw;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // reset
    memPkt_rdata            <= 32'b0;   //* mem interface (output);
    memPkt_ready            <= 1'b0;
    addr_pkt_sw             <= 0;
    wren_pkt_sw             <= 4'b0;
    din_pkt_sw              <= 32'b0;
    temp_rden_pkt_sw        <= 4'b0;

  end
  else begin
    memPkt_ready            <= 1'b0;
    //* read/write sram;
    temp_rden_pkt_sw      <= {temp_rden_pkt_sw[2:0], memPkt_rden};
    wren_pkt_sw           <= {4{memPkt_wren}}&memPkt_wstrb;
    addr_pkt_sw           <= {memPkt_addr[15],memPkt_addr[10:2]};
    din_pkt_sw            <= memPkt_wdata;
    //* output memPkt_ready;
    memPkt_ready          <= memPkt_wren;
    if(temp_rden_pkt_sw[3:2] == 2'd1) begin
      memPkt_ready          <= 1'b1;
      memPkt_rdata          <= dout_pkt_sw;
    end
  end
end

genvar i_ram;
  generate
    for (i_ram = 0; i_ram < 4; i_ram = i_ram+1) begin: ram_mem
      ram_8_1024 sram_for_pkt(
        .clka(clk),
        .wea(wren_pkt_hw[i_ram]),
        .addra(addr_pkt_hw),
        .dina(din_pkt_hw[(3-i_ram)*8+7:(3-i_ram)*8]),
        .douta(dout_pkt_hw[(3-i_ram)*8+7:(3-i_ram)*8]),
        .clkb(clk),
        .web(wren_pkt_sw[i_ram]),
        .addrb(addr_pkt_sw),
        .dinb(din_pkt_sw[i_ram*8+7:i_ram*8]),
        .doutb(dout_pkt_sw[i_ram*8+7:i_ram*8])
      );
  end
  endgenerate


endmodule

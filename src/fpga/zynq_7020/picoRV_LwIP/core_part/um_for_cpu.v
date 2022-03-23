/*
 *  picoSoC_hardware -- SoC Hardware for RISCV-32I core.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last updated date: 2022.03.22
 *  Description: This module is used to connect pico_top with configuration,
 *    and uart.
 */

module um_for_cpu(
  input               clk,
  input               rst_n,
    
  input               data_in_valid,
  input       [133:0] data_in,  // 2'b01 is head, 2'b00 is body, and 2'b10 is tail;
  output reg          data_out_valid,
  output reg  [133:0] data_out,

  input               uart_rx,
  output wire         uart_tx,
  input               uart_cts_i,
  
  output reg          led_out,

  //* left for packet process;
  output wire         mem_wren,
  output wire         mem_rden,
  output wire [31:0]  mem_addr,
  output wire [31:0]  mem_wdata,
  input       [31:0]  mem_rdata,
  output wire         cpu_ready
);

  /** TODO:*/

  (* mark_debug = "true"*)wire          conf_rden, conf_wren;
  (* mark_debug = "true"*)wire [31:0]   conf_addr, conf_wdata, conf_rdata;
  (* mark_debug = "true"*)wire          conf_sel;
  (* mark_debug = "true"*)wire          peri_rden, peri_wren;
  (* mark_debug = "true"*)wire [31:0]   peri_addr, peri_wdata;
  (* mark_debug = "true"*)wire [3:0]    peri_wstrb;
  (* mark_debug = "true"*)wire [31:0]   peri_rdata;
  (* mark_debug = "true"*)wire          peri_ready;
  reg   [31:0]    irq_bitmap;

  wire            data_out_valid_mem, data_out_valid_memPkt;
  wire  [133:0]   data_out_mem, data_out_memPkt;

  //* fifo interface for uart;
  (* mark_debug = "true"*)reg           rden_uart;
  (* mark_debug = "true"*)wire [7:0]    dout_uart_8b;
  (* mark_debug = "true"*)wire          empty_uart;
  
  //* left for packet process;
  assign cpu_ready  = 1'b1;
  assign mem_wren   = 1'b0;
  assign mem_rden   = 1'b0;
  assign mem_addr   = 32'b0;
  assign mem_wdata  = 32'b0;

  pico_top picoTop(
    .clk(clk),
    .resetn(rst_n),

    .conf_rden(conf_rden),
    .conf_wren(conf_wren),
    .conf_addr(conf_addr),
    .conf_wdata(conf_wdata),
    .conf_rdata(conf_rdata),
    .conf_sel(conf_sel),

    .peri_rden(peri_rden),
    .peri_wren(peri_wren),
    .peri_addr(peri_addr),
    .peri_wdata(peri_wdata),
    .peri_wstrb(peri_wstrb),
    .peri_rdata(peri_rdata),
    .peri_ready(peri_ready),
    .irq_bitmap(32'b0)
  );

  conf_mem confMem(
    .clk(clk),
    .resetn(rst_n),

    .data_in_valid(data_in_valid),
    .data_in(data_in),
    .data_out_valid(data_out_valid_mem),
    .data_out(data_out_mem),

    .conf_rden(conf_rden),
    .conf_wren(conf_wren),
    .conf_addr(conf_addr),
    .conf_wdata(conf_wdata),
    .conf_rdata(conf_rdata),
    .conf_sel(conf_sel)
  );

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

//***************************************uart***********************************//
  //* uart;
  //* output print info by wrting 32'h10000000;
  reg           print_valid, pre_men_wren;
  reg   [7:0]   print_value;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      print_value     <= 8'b0;
      print_valid     <= 1'b0;
      pre_men_wren    <= 1'b0;
    end
    else begin
      pre_men_wren    <= peri_wren;
      if(peri_wren == 1'b1 && peri_addr == 32'h10000000 && pre_men_wren == 1'b0) begin
        print_valid   <= 1'b1;
        print_value   <= peri_wdata[7:0];
        $write("%c", peri_wdata[7:0]);
        $fflush();
      end
      else begin
        print_valid   <= 1'b0;
      end
    end
  end

  //* value wait to output by uart;
  fifo_8b_512 data_uart(
    .clk(clk),
    .srst(!rst_n),
    .din(print_value),
    .wr_en(print_valid),
    .rd_en(rden_uart),
    .dout(dout_uart_8b),
    .full(),
    .empty(empty_uart),
    .data_count()
  );

  //* connect uart with uart controller;
  (* mark_debug = "true"*)reg   [31:0]  addr_32b_i;
  (* mark_debug = "true"*)reg           wren_i;
  (* mark_debug = "true"*)reg   [31:0]  din_32b_i;

  uart uart_inst(
    .clk_i(clk),
    .rst_n_i(rst_n),
    .uart_tx_o(uart_tx),
    .uart_rx_i(uart_rx),
    .addr_32b_i(addr_32b_i),
    .wren_i(wren_i),
    .rden_i(1'b0),
    .din_32b_i(din_32b_i),
    .dout_32b_o(),
    .dout_32b_valid_o(), //* finish reading;
    .interrupt_o()
  );

  //* uart controller
  reg [3:0]   cnt_wait_clk;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset
      rden_uart       <= 1'b0;
      wren_i          <= 1'b0;
      din_32b_i       <= 32'b0;
      addr_32b_i      <= 32'b0;
      cnt_wait_clk    <= 4'b0;
    end
    else begin
      rden_uart       <= 1'b0;
      wren_i          <= 1'b0;
      cnt_wait_clk    <= 4'b1 + cnt_wait_clk;
      
      //* write uart;
      if(empty_uart == 1'b0 && cnt_wait_clk == 4'b0) begin
        rden_uart     <= 1'b1;
        wren_i        <= 1'b1;
        addr_32b_i    <= 32'h4;
        din_32b_i     <= {24'b0,dout_uart_8b};
      end
    end
  end

//***************************************uart***********************************//

//***************************************led***********************************//
  //* TODO, flip after recving or sending a pkt;
  reg   pre_data_out_valid, pre_data_in_valid;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      led_out             <= 1'b0;
      pre_data_out_valid  <= 1'b0;
      pre_data_in_valid   <= 1'b0;
    end
    else begin
      pre_data_out_valid  <= data_out_valid;
      pre_data_in_valid   <= data_in_valid;
      led_out             <= (pre_data_out_valid == 1'b0 && 
                              data_out_valid == 1'b1)? ~led_out: led_out;
    end
  end
  
//***************************************led***********************************//

//***************************************mem_pkt***********************************//
  wire          peri_ready_pkt;
  wire  [31:0]  peri_rdata_pkt;
  memPkt memPkt_inst(
    .clk(clk),
    .rst_n(rst_n),

    .data_in_valid(data_in_valid),
    .data_in(data_in),
    .data_out_valid(data_out_valid_memPkt),
    .data_out(data_out_memPkt),

    .memPkt_rden(peri_rden),
    .memPkt_wren(peri_wren),
    .memPkt_addr(peri_addr),
    .memPkt_wdata(peri_wdata),
    .memPkt_wstrb(peri_wstrb),
    .memPkt_rdata(peri_rdata_pkt),
    .memPkt_ready(peri_ready_pkt)
  );
  
//***************************************mem_pkt***********************************//

  assign peri_ready = print_valid | peri_ready_pkt;
  assign peri_rdata = peri_rdata_pkt;

endmodule    

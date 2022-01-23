/*
 *  picoSoC_hardware -- SoC Hardware for RISCV-32I core.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Lasted update date: 2022.01.19
 *  Description: This module is used to connect pico_top with configuration,
 *    and uart.
 */

`define BASE_ADDR_UART 16'h1001
`define BASE_ADDR_GPIO 16'h1002
`define BASE_ADDR_CAN 16'h1003

// `define GPIO_KEY //* GPIO for key is open;
`define CAN   //* CAN is open;
`define LCD   //& lcd is open;

module um_for_cpu(
  input               clk,
  input               rst_n,
    
  input               data_in_valid,
  input       [133:0] data_in,  // 2'b01 is head, 2'b00 is body, and 2'b10 is tail;
  output wire         data_out_valid,
  output wire [133:0] data_out,

  input               uart_rx,
  output wire         uart_tx,
  input               uart_cts_i,
  
  output reg          led_out,

  inout       [7:0]   can_ad,
  output wire         can_cs_n,
  output wire         can_ale,
  output wire         can_wr_n,
  output wire         can_rd_n,
  input               can_int_n,
  output reg          can_rst_n,
  output wire         can_mode,

  output reg  [7:0]   core_dis_data,
  output reg          core_dis_data_wr,

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
  (* mark_debug = "true"*)wire [31:0]   peri_rdata;
  (* mark_debug = "true"*)wire          peri_ready;
  reg   [31:0]    irq_bitmap;

  //* fifo interface for uart;
  reg           rden_uart;
  wire [7:0]    dout_uart_8b;
  wire          empty_uart;
  
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
    .peri_rdata(peri_rdata),
    .peri_ready(peri_ready),
    .irq_bitmap(irq_bitmap)
  );

  conf_mem confMem(
    .clk(clk),
    .resetn(rst_n),

    .data_in_valid(data_in_valid),
    .data_in(data_in),
    .data_out_valid(data_out_valid),
    .data_out(data_out),

    .conf_rden(conf_rden),
    .conf_wren(conf_wren),
    .conf_addr(conf_addr),
    .conf_wdata(conf_wdata),
    .conf_rdata(conf_rdata),
    .conf_sel(conf_sel)
  );

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
  (* mark_debug = "true"*)wire  [31:0]  addr_32b_i;
  (* mark_debug = "true"*)reg   [31:0]  addr_32b_wr;
  (* mark_debug = "true"*)reg           wren_i;
  (* mark_debug = "true"*)wire          rden_i;
  (* mark_debug = "true"*)reg   [31:0]  din_32b_i;
  (* mark_debug = "true"*)wire  [31:0]  dout_32b_o;
  (* mark_debug = "true"*)wire          dout_32b_valid_o; // is 1 after wr/rd uart;
  (* mark_debug = "true"*)wire          interrupt_o;

  uart uart_inst(
    .clk_i(clk),
    .rst_n_i(rst_n),
    .uart_tx_o(uart_tx),
    .uart_rx_i(uart_rx),
    .addr_32b_i(addr_32b_i),
    .wren_i(wren_i),
    .rden_i(rden_i),
    .din_32b_i(din_32b_i),
    .dout_32b_o(dout_32b_o),
    .dout_32b_valid_o(dout_32b_valid_o), //* finish reading;
    .interrupt_o(interrupt_o)
  );

  //* uart controller
  reg [3:0]   cnt_wait_clk;
  reg         tag_has_gen_irq_uart;
  (* mark_debug = "true"*)reg         uart_ready;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset
      rden_uart       <= 1'b0;
      wren_i          <= 1'b0;
      din_32b_i       <= 32'b0;
      addr_32b_wr     <= 32'b0;
      cnt_wait_clk    <= 4'b0;
      irq_bitmap[4]   <= 1'b0;
      {irq_bitmap[31:6],irq_bitmap[2:0]}  <= 29'b0;
      tag_has_gen_irq_uart <= 1'b0;
      uart_ready      <= 1'b0;
    end
    else begin
      irq_bitmap[4]   <= 1'b0;
      rden_uart       <= 1'b0;
      wren_i          <= 1'b0;
      uart_ready      <= 1'b0;
      cnt_wait_clk    <= 4'b1 + cnt_wait_clk;
      
      //* write uart;
      if(empty_uart == 1'b0 && cnt_wait_clk == 4'b0) begin
        rden_uart     <= 1'b1;
        wren_i        <= 1'b1;
        addr_32b_wr   <= {`BASE_ADDR_UART,16'h0004};
        din_32b_i     <= {24'b0,dout_uart_8b};
      end
      //* uart write controlled by host (write just once);
      else if(peri_addr[31:16] == `BASE_ADDR_UART && peri_wren == 1'b1 && uart_ready == 1'b0) begin 
        uart_ready    <= 1'b1;
        wren_i        <= 1'b1;
      end
      //* irq[4];
      if(interrupt_o == 1'b1 && tag_has_gen_irq_uart == 1'b0) begin
        irq_bitmap[4] <= 1'b1;
        tag_has_gen_irq_uart  <= 1'b1;
      end
      else if(dout_32b_valid_o == 1'b1) begin
        tag_has_gen_irq_uart  <= 1'b0;
      end
    end
  end

  //* uart read (read just once);
  assign rden_i = (peri_addr[31:16] == `BASE_ADDR_UART && wren_i == 1'b0 && dout_32b_valid_o == 1'b0)? peri_rden: 1'b0;
  assign addr_32b_i = (rden_uart == 1'b1)? addr_32b_wr:{`BASE_ADDR_UART,peri_addr[15:0]};
//***************************************uart***********************************//

//***************************************gpio***********************************//
  (* mark_debug = "true"*)reg         mem_ready_gpio;
  //* gpio_led;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      led_out                   <= 1'b0;
      mem_ready_gpio            <= 1'b0;
    end
    else begin
      if(peri_wren == 1'b1 && peri_addr == {`BASE_ADDR_GPIO,16'h0008} && pre_men_wren == 1'b0) begin
          led_out               <= ~led_out;
      end
      mem_ready_gpio <= ((peri_addr[31:16] == `BASE_ADDR_GPIO) && 
        mem_ready_gpio == 1'b0)? (peri_wren|peri_rden): 1'b0; //* printf, gpio;
      //* Noted: mem_ready_gpio is valid after reading/writing gpio;
    end
  end
  //* gpio_key;
  `ifdef GPIO_KEY
    //* peripheral
    //* GPIO (key), irq_bitmap[3];
    //* key_status is four keys' status, read address is 32'h10000004;
    (* mark_debug = "true"*)reg [3:0]   key_status, pre_key[3:0];
    (* mark_debug = "true"*)reg [31:0]  mem_rdata_gpio;
    reg [7:0]   cnt_irq;
    reg       tag_has_gen_irq_gpio; //* used to gen one clk interrupt;
    integer i;
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        irq_bitmap[3]           <= 1'b0;
        key_status              <= 4'b0;
        for(i=0; i<4; i=i+1)
          pre_key[i]            <= 4'b0;
        mem_rdata_gpio          <= 32'b0;
        tag_has_gen_irq_gpio    <= 1'b0;
        cnt_irq                 <= 8'b0;
      end
      else begin
        for(i=0; i<4; i=i+1)
          pre_key[i]            <= {pre_key[i][2:0],key_in[i]};
        irq_bitmap[3]           <= 1'b0;
        //* update key_status;
        for(i=0; i<4; i=i+1)
          if(pre_key[i] == 4'b1100)
            key_status[i]       <= 1'b1;
        if(mem_ready_gpio == 1'b1) begin
          key_status            <= 4'b0;
          tag_has_gen_irq_gpio  <= 1'b0;
        end
        //* gen interrupt;
        else if(key_status != 4'b0 && tag_has_gen_irq_gpio == 1'b0) begin
          irq_bitmap[3]         <= 1'b1;
          tag_has_gen_irq_gpio  <= 1'b1;
          cnt_irq               <= 8'd1 + cnt_irq;
        end

        //* read key_status after generating interrupt;
        if(peri_rden == 1'b1 && peri_addr == {`BASE_ADDR_GPIO,16'h0004} && mem_ready_gpio == 1'b0) begin
          mem_rdata_gpio        <= {16'b0,cnt_irq,4'b0,key_status};
        end
      end
    end
  `endif
//***************************************gpio***********************************//
  
//***************************************can************************************//
  `ifdef CAN
    reg   [31:0]  addr_32b_can;
    reg           wren_can,rden_can;
    reg   [31:0]  din_32b_can;
    wire  [31:0]  dout_32b_can;
    wire          dout_32b_valid_can; //* dout_32b_valid_can is valid just after
                                      //*   finishing reading/writing data;

    //* irq_bitmap[5];
    can can_inst(
      .sys_clk(clk),
      .rst_n(rst_n),
      
      .addr_32b_i(addr_32b_can),
      .wren_i(wren_can),
      .rden_i(rden_can),
      .din_32b_i(din_32b_can),
      .dout_32b_o(dout_32b_can),
      .dout_32b_valid_o(dout_32b_valid_can), //* finish rd/wr;

      .can_ad(can_ad),
      .can_cs_n(can_cs_n),
      .can_ale(can_ale),
      .can_wr_n(can_wr_n),
      .can_rd_n(can_rd_n),
      .can_int_n(can_int_n),
      .can_rst_n(),
      .can_mode(can_mode)
    );

    //* can controller
    (* mark_debug = "true"*)reg           tag_rd_wr_can;
    (* mark_debug = "true"*)reg           tag_has_gen_irq_can, temp_can_intr_n;
    (* mark_debug = "true"*)reg   [10:0]  cnt_to_release;
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        addr_32b_can        <= 32'b0;
        wren_can            <= 1'b0;
        rden_can            <= 1'b0;
        din_32b_can         <= 32'b0;
        tag_rd_wr_can       <= 1'b0;
        tag_has_gen_irq_can <= 1'b0;
        irq_bitmap[5]       <= 1'b0;
        temp_can_intr_n     <= 1'b1;
        cnt_to_release      <= 11'b0;
      end
      else begin
        temp_can_intr_n     <= can_int_n;

        irq_bitmap[5]       <= 1'b0;
        wren_can            <= 1'b0;
        rden_can            <= 1'b0;
        addr_32b_can        <= peri_addr;
        din_32b_can         <= peri_wdata;
        if(peri_addr[31:16] == `BASE_ADDR_CAN && tag_rd_wr_can == 1'b0 && (peri_wren|peri_rden)) begin
          wren_can          <= peri_wren;
          rden_can          <= peri_rden;
          tag_rd_wr_can     <= 1'b1;
        end
        else if(dout_32b_valid_can == 1'b1)
          tag_rd_wr_can     <= 1'b0;

        //* gen interrupt for can;
        cnt_to_release      <= 11'd1 + cnt_to_release;
        if(tag_has_gen_irq_can == 1'b0 && can_int_n == 1'b0) begin
          tag_has_gen_irq_can <= 1'b1;
          irq_bitmap[5]       <= 1'b1;
          cnt_to_release      <= 11'b0;
        end
        // else if(can_int_n == 1'b1) begin
        else if(can_int_n == 1'b1 || cnt_to_release[10] == 1'b1) begin
          tag_has_gen_irq_can <= 1'b0;
        end
      end
    end
  `endif
//***************************************can************************************//

//***************************************lcd************************************//
  `ifdef LCD
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        core_dis_data_wr      <= 1'b0;
        core_dis_data         <= 8'b0;
      end
      else begin
        core_dis_data_wr      <= 1'b0;
        //* write distance data, ready signal is shared with mem_ready_gpio;
        if(peri_wren == 1'b1 && peri_addr == {`BASE_ADDR_GPIO,16'h000C} && mem_ready_gpio == 1'b0) begin
          core_dis_data_wr    <= 1'b1;
          core_dis_data       <= peri_wdata[7:0];
        end
      end
    end
  `endif
//***************************************lcd************************************//

  //* dmux;
  // always @(posedge clk or negedge rst_n) begin
  //   if (!rst_n) begin
  //     peri_ready                <= 1'b0;
  //     peri_rdata                <= 32'b0;
  //   end
  //   else begin
  //     peri_ready                <= dout_32b_valid_o|mem_ready_gpio;
  //     peri_rdata                <= (dout_32b_valid_o == 1'b1)? dout_32b_o: mem_rdata_gpio;
  //   end
  // end

  //* dmux between uart and gpio_key;
  `ifdef GPIO_KEY
    `ifdef CAN  //* GPIO_KEY + CAN + UART
      assign peri_ready = (peri_addr[31:16] == 16'h1000)? (peri_wren|peri_rden): dout_32b_valid_o|uart_ready|mem_ready_gpio|dout_32b_valid_can;
      assign peri_rdata = (dout_32b_valid_o == 1'b1)? dout_32b_o: 
                          (dout_32b_valid_can == 1'b1)? dout_32b_can: mem_rdata_gpio;
    `else       //* GPIO_KEY + UART
      assign peri_ready = (peri_addr[31:16] == 16'h1000)? (peri_wren|peri_rden): dout_32b_valid_o|uart_ready|mem_ready_gpio;
      assign peri_rdata = (dout_32b_valid_o == 1'b1)? dout_32b_o: mem_rdata_gpio;
    `endif
  `else
    `ifdef CAN  //* CAN + UART
      assign peri_ready = (peri_addr[31:16] == 16'h1000)? (peri_wren|peri_rden): dout_32b_valid_o|uart_ready|dout_32b_valid_can|mem_ready_gpio;
      assign peri_rdata = (dout_32b_valid_o == 1'b1)? dout_32b_o: dout_32b_can;
    `else       //* just UART
      //* assign with uart's rdata;
      assign peri_ready = (peri_addr[31:16] == 16'h1000)? (peri_wren|peri_rden): dout_32b_valid_o|uart_ready|mem_ready_gpio;
      assign peri_rdata = dout_32b_o;
    `endif
  `endif

endmodule    

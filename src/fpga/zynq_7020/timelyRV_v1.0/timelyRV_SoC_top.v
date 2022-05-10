/*
 *  Project:            timelyRV_v1.0 -- a RISCV-32IMC SoC.
 *  Module name:        timelyRV_SoC_top.
 *  Description:        Top Module of timelyRV_SoC_hardware.
 *  Last updated date:  2022.05.06.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Noted:
 *    1) rgmii2gmii & gmii_rx2rgmii are processed by language templates;
 *    2) rgmii_rx is constrained by set_input_delay "-2.0 ~ -0.7";
 *    3) 134b pkt data definition: 
 *      [133:132] head tag, 2'b01 is head, 2'b10 is tail;
 *      [131:128] valid tag, 4'b1111 means sixteen 8b data is valid;
 *      [127:0]   pkt data, invalid part is padded with 0;
 *    4) the riscv-32imc core is a modified cv32e40p;
 *
 */

`timescale 1ns / 1ps

module timelyRV_SoC_top(
  //* system input, clk;
   input               sys_clk
  ,input               rst_n
  //* rgmii port;
  ,output  wire        mdio_mdc
  ,inout               mdio_mdio_io
  ,output  wire        phy_reset_n
  ,input         [3:0] rgmii_rd
  ,input               rgmii_rx_ctl
  ,input               rgmii_rxc
  ,output  wire  [3:0] rgmii_td
  ,output  wire        rgmii_tx_ctl
  ,output  wire        rgmii_txc
  //* key & led;
  ,output  wire        led

  //* uart rx/tx from/to host;
  ,input               uart_rx    //* fpga receive data from host;
  ,output  wire        uart_tx    //* fpga send data to host;
  ,input               uart_cts
  ,output  wire        uart_rts

`ifdef CAN
  //* can
  ,inout         [7:0] can_ad
  ,output  wire        can_cs_n
  ,output  wire        can_ale
  ,output  wire        can_wr_n
  ,output  wire        can_rd_n
  ,input               can_int_n
  ,output  wire        can_rst_n
  ,output  wire        can_mode
  ,output  wire        can_dir
  ,output  wire        can_oe_n
`endif

`ifdef LCD
  //* lcd
  ,output  wire        lcd_dclk   //* lcd clock;
  ,output  wire        lcd_hs     //* lcd horizontal synchronization;
  ,output  wire        lcd_vs     //* lcd vertical synchronization;  
  ,output  wire        lcd_de     //* lcd data valid;
  ,output  wire  [7:0] lcd_r      //* lcd red;
  ,output  wire  [7:0] lcd_g      //* lcd green;
  ,output  wire  [7:0] lcd_b       //* lcd blue;
`endif

`ifdef RS485_0
  //* rs485
  ,input               rs485_rx_0
  ,output wire         rs485_tx_0
  ,output wire         rs485_de_0
`endif

`ifdef RS485_1
  //* rs485
  ,input               rs485_rx_1
  ,output wire         rs485_tx_1
  ,output wire         rs485_de_1
`endif

`ifdef PWM
  //* PWM
  ,output wire         pwm_0
  ,output wire         pwm_1
`endif
);

  assign uart_rts   = 1'b0;       //* host can send to fpga anytime;
  `ifdef CAN
    assign can_oe_n = 1'b0;       //* enable module of voltage conversion;
    assign can_dir  = ~can_rd_n;  //* direction of voltage conversion;
    assign can_rst_n= rst_n;      //* can reset_n;
  `endif

  //* clock & locker;
  wire  clk_125m, clk_9m;         //* 9M clk for LCD;
  wire  locked;   // locked =1 means generating 125M clock successfully;
  `ifdef LCD
    assign lcd_dclk = ~clk_9m;
  `endif

  //* system reset signal, low is active;
  wire sys_rst_n;
  assign sys_rst_n = rst_n & locked;

  //* connected wire (TODO,...)
  //* speed_mode, clock_speed, mdio (gmii_to_rgmii IP)
  wire  [1:0]   speed_mode, clock_speed;
  wire          mdio_gem_mdc, mdio_gem_o, mdio_gem_t;
  wire          mdio_gem_i;
  
  //* assign phy_reset_n = 1, haven't been used;
  assign phy_reset_n = rst_n;

  //* assign mdio_mdc = 0, haven't been used;
  assign mdio_mdc = 1'b0;

  //* gen 125M clock;
  clk_wiz_0 clk_to_125m(
    //* Clock out ports
    .clk_out1(clk_125m),        //* output 125m;
    .clk_out2(clk_9m),          //* output 9m;
    //* Status and control signals
    .reset(!rst_n),             //* input reset
    .locked(locked),            //* output locked
    // Clock in ports
    .clk_in1(sys_clk)
    // .clk_in1_p(sys_clk_p),  //* input clk_in1_p
    // .clk_in1_n(sys_clk_n)   //* input clk_in1_n
  );
  
  (* mark_debug = "true"*)wire  [133:0] pktData_gmii, pktData_um;
  (* mark_debug = "true"*)wire          pktData_valid_gmii, pktData_valid_um;

  soc_runtime runtime(
    .clk_125m     (clk_125m           ),
    .sys_rst_n    (sys_rst_n          ),
    //* rgmii;
    .rgmii_rd     (rgmii_rd           ),  //* input
    .rgmii_rx_ctl (rgmii_rx_ctl       ),  //* input
    .rgmii_rxc    (rgmii_rxc          ),  //* input

    .rgmii_txc    (rgmii_txc          ),  //* output
    .rgmii_td     (rgmii_td           ),  //* output
    .rgmii_tx_ctl (rgmii_tx_ctl       ),  //* output

    //* um;
    .pktData_valid_gmii(pktData_valid_gmii),
    .pktData_gmii (pktData_gmii       ),
    .pktData_valid_um(pktData_valid_um),
    .pktData_um   (pktData_um         )
  );

  um_for_cpu UMforCPU(
    .clk          (clk_125m           ),
    .rst_n        (sys_rst_n          ),
    .data_in_valid(pktData_valid_gmii ),
    .data_in      (pktData_gmii       ),
    .data_out_valid(pktData_valid_um  ),
    .data_out     (pktData_um         ),

    //* led;
    .led_out      (led                ),

    `ifdef CAN
      //* can interface;
      .can_ad     (can_ad             ),
      .can_cs_n   (can_cs_n           ),
      .can_ale    (can_ale            ),
      .can_wr_n   (can_wr_n           ),
      .can_rd_n   (can_rd_n           ),
      .can_int_n  (can_int_n          ),
      .can_rst_n  (                   ),
      .can_mode   (can_mode           ),
    `endif

    `ifdef LCD
      //* lcd interface;
      .lcd_clk    (~clk_9m            ),
      .lcd_rst    (~rst_n             ),
      .lcd_hs     (lcd_hs             ),
      .lcd_vs     (lcd_vs             ),
      .lcd_de     (lcd_de             ),
      .lcd_r      (lcd_r              ),
      .lcd_g      (lcd_g              ),
      .lcd_b      (lcd_b              ),
    `endif

    `ifdef RS485_0
      .rs485_rx_0 (rs485_rx_0         ),
      .rs485_tx_0 (rs485_tx_0         ),
      .rs485_de_0 (rs485_de_0         ),
    `endif

    `ifdef RS485_1
      .rs485_rx_1 (rs485_rx_1         ),
      .rs485_tx_1 (rs485_tx_1         ),
      .rs485_de_1 (rs485_de_1         ),
    `endif

    `ifdef PWM
      .pwm_0      (pwm_0              ),
      .pwm_1      (pwm_1              ),
    `endif

    //* uart;
    .uart_rx      (uart_rx            ),
    .uart_tx      (uart_tx            ),
    .uart_cts_i   (uart_cts           )
  );

endmodule

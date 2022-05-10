########################################################
#port 0
set_property PACKAGE_PIN N17 [get_ports {rgmii_td[0]}]
set_property PACKAGE_PIN N18 [get_ports {rgmii_td[1]}]
set_property PACKAGE_PIN N19 [get_ports {rgmii_td[2]}]
set_property PACKAGE_PIN N20 [get_ports {rgmii_td[3]}]
set_property PACKAGE_PIN J17 [get_ports mdio_mdc]
set_property PACKAGE_PIN J16 [get_ports mdio_mdio_io]
set_property PACKAGE_PIN L19 [get_ports phy_reset_n]
set_property PACKAGE_PIN K19 [get_ports rgmii_rxc]
set_property PACKAGE_PIN K20 [get_ports rgmii_rx_ctl]
set_property PACKAGE_PIN J18 [get_ports {rgmii_rd[0]}]
set_property PACKAGE_PIN K18 [get_ports {rgmii_rd[1]}]
set_property PACKAGE_PIN J15 [get_ports {rgmii_rd[2]}]
set_property PACKAGE_PIN K15 [get_ports {rgmii_rd[3]}]
set_property PACKAGE_PIN R21 [get_ports rgmii_txc]
set_property PACKAGE_PIN R20 [get_ports rgmii_tx_ctl]

set_property IOSTANDARD LVCMOS33 [get_ports mdio_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports mdio_mdio_io]
set_property IOSTANDARD LVCMOS33 [get_ports phy_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_rx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_txc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_tx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[3]}]


set_property SLEW FAST [get_ports rgmii_tx_ctl]
set_property SLEW FAST [get_ports rgmii_txc]
set_property SLEW FAST [get_ports {rgmii_td[3]}]
set_property SLEW FAST [get_ports {rgmii_td[2]}]
set_property SLEW FAST [get_ports {rgmii_td[1]}]
set_property SLEW FAST [get_ports {rgmii_td[0]}]
set_property SLEW SLOW [get_ports phy_reset_n]


############## clock and reset define##################
set_property PACKAGE_PIN A17 [get_ports rst_n]
set_property PACKAGE_PIN Y9 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property UNAVAILABLE_DURING_CALIBRATION true [get_ports mdio_mdio_io]

create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]
create_clock -period 8.000 -name RGMII_RXC_0 -waveform {0.000 4.000} [get_ports rgmii_rxc]
create_clock -period 8.000 -name RGMII_TXC_0 -waveform {0.000 4.000} [get_ports rgmii_txc]

set_input_delay -clock RGMII_RXC_0 -min -add_delay -1.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
set_input_delay -clock RGMII_RXC_0 -max -add_delay -0.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
set_input_delay -clock RGMII_RXC_0 -clock_fall -min -add_delay -1.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
set_input_delay -clock RGMII_RXC_0 -clock_fall -max -add_delay -0.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]

set_output_delay -clock RGMII_TXC_0 -min -add_delay -0.500 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
set_output_delay -clock RGMII_TXC_0 -max -add_delay 1.000 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
set_output_delay -clock RGMII_TXC_0 -clock_fall -min -add_delay -0.500 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
set_output_delay -clock RGMII_TXC_0 -clock_fall -max -add_delay 1.000 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]

############## usb uart define########################
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property PACKAGE_PIN Y20 [get_ports uart_rx]
#set_property PACKAGE_PIN V12 [get_ports uart_rx]

set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property PACKAGE_PIN AB21 [get_ports uart_tx]
#set_property PACKAGE_PIN U12 [get_ports uart_tx]

set_property IOSTANDARD LVCMOS33 [get_ports uart_cts]
set_property PACKAGE_PIN W20 [get_ports uart_cts]
#set_property PACKAGE_PIN U9 [get_ports uart_cts]

set_property IOSTANDARD LVCMOS33 [get_ports uart_rts]
set_property PACKAGE_PIN V22 [get_ports uart_rts]
#set_property PACKAGE_PIN T6 [get_ports uart_rts]


############## led ###################################
set_property PACKAGE_PIN A16 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]

############## CAN define#############################
set_property PACKAGE_PIN R18 [get_ports {can_ad[0]}]
set_property PACKAGE_PIN L17 [get_ports {can_ad[1]}]
set_property PACKAGE_PIN R16 [get_ports {can_ad[2]}]
set_property PACKAGE_PIN J20 [get_ports {can_ad[3]}]
set_property PACKAGE_PIN J22 [get_ports {can_ad[4]}]
set_property PACKAGE_PIN AA19 [get_ports {can_ad[5]}]
set_property PACKAGE_PIN V20 [get_ports {can_ad[6]}]
set_property PACKAGE_PIN U21 [get_ports {can_ad[7]}]
set_property PACKAGE_PIN P21 [get_ports can_oe_n]
set_property PACKAGE_PIN R19 [get_ports can_dir]

set_property PACKAGE_PIN K21 [get_ports can_cs_n]
set_property PACKAGE_PIN Y19 [get_ports can_wr_n]
set_property PACKAGE_PIN T21 [get_ports can_rst_n]
set_property PACKAGE_PIN P16 [get_ports can_ale]
set_property PACKAGE_PIN J21 [get_ports can_rd_n]
set_property PACKAGE_PIN U20 [get_ports can_mode]
set_property PACKAGE_PIN M17 [get_ports can_int_n]

set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {can_ad[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports can_oe_n]
set_property IOSTANDARD LVCMOS33 [get_ports can_dir]

set_property IOSTANDARD LVCMOS33 [get_ports can_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports can_ale]
set_property IOSTANDARD LVCMOS33 [get_ports can_wr_n]
set_property IOSTANDARD LVCMOS33 [get_ports can_rd_n]
set_property IOSTANDARD LVCMOS33 [get_ports can_int_n]
set_property IOSTANDARD LVCMOS33 [get_ports can_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports can_mode]

############# LCD define#############################
set_property PACKAGE_PIN V12 [get_ports {lcd_r[0]}]
set_property PACKAGE_PIN W12 [get_ports {lcd_r[1]}]
set_property PACKAGE_PIN U12 [get_ports {lcd_r[2]}]
set_property PACKAGE_PIN U11 [get_ports {lcd_r[3]}]
set_property PACKAGE_PIN U9 [get_ports {lcd_r[4]}]
set_property PACKAGE_PIN U10 [get_ports {lcd_r[5]}]
set_property PACKAGE_PIN T6 [get_ports {lcd_r[6]}]
set_property PACKAGE_PIN R6 [get_ports {lcd_r[7]}]
set_property PACKAGE_PIN U5 [get_ports {lcd_g[0]}]
set_property PACKAGE_PIN U6 [get_ports {lcd_g[1]}]
set_property PACKAGE_PIN U4 [get_ports {lcd_g[2]}]
set_property PACKAGE_PIN T4 [get_ports {lcd_g[3]}]
set_property PACKAGE_PIN W10 [get_ports {lcd_g[4]}]
set_property PACKAGE_PIN W11 [get_ports {lcd_g[5]}]
set_property PACKAGE_PIN Y10 [get_ports {lcd_g[6]}]
set_property PACKAGE_PIN Y11 [get_ports {lcd_g[7]}]
set_property PACKAGE_PIN W8 [get_ports {lcd_b[0]}]
set_property PACKAGE_PIN V8 [get_ports {lcd_b[1]}]
set_property PACKAGE_PIN AA6 [get_ports {lcd_b[2]}]
set_property PACKAGE_PIN AA7 [get_ports {lcd_b[3]}]
set_property PACKAGE_PIN AA11 [get_ports {lcd_b[4]}]
set_property PACKAGE_PIN AB11 [get_ports {lcd_b[5]}]
set_property PACKAGE_PIN AB4 [get_ports {lcd_b[6]}]
set_property PACKAGE_PIN AB5 [get_ports {lcd_b[7]}]
set_property PACKAGE_PIN AB1 [get_ports lcd_dclk]
set_property PACKAGE_PIN AB2 [get_ports lcd_hs]
set_property PACKAGE_PIN Y4 [get_ports lcd_vs]
set_property PACKAGE_PIN AA4 [get_ports lcd_de]

set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_dclk]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_hs]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_vs]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_de]

############### rs485 define########################
#set_property IOSTANDARD LVCMOS33 [get_ports rs485_rx_0]
#set_property PACKAGE_PIN U12 [get_ports rs485_rx_0]
#set_property IOSTANDARD LVCMOS33 [get_ports rs485_tx_0]
#set_property PACKAGE_PIN U9 [get_ports rs485_tx_0]
#set_property IOSTANDARD LVCMOS33 [get_ports rs485_de_0]
#set_property PACKAGE_PIN T6 [get_ports rs485_de_0]

#set_property IOSTANDARD LVCMOS33 [get_ports rs485_rx_1]
#set_property PACKAGE_PIN U5 [get_ports rs485_rx_1]
#set_property IOSTANDARD LVCMOS33 [get_ports rs485_tx_1]
#set_property PACKAGE_PIN U4 [get_ports rs485_tx_1]
#set_property IOSTANDARD LVCMOS33 [get_ports rs485_de_1]
#set_property PACKAGE_PIN W10 [get_ports rs485_de_1]

############### PWM define########################
set_property IOSTANDARD LVCMOS33 [get_ports pwm_0]
set_property PACKAGE_PIN Y21 [get_ports pwm_0]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_1]
set_property PACKAGE_PIN AA21 [get_ports pwm_1]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_to_125m/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {UMforCPU/bus/wren_o[0]} {UMforCPU/bus/wren_o[1]} {UMforCPU/bus/wren_o[2]} {UMforCPU/bus/wren_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 128 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {UMforCPU/bus/addr_32b_o[0]} {UMforCPU/bus/addr_32b_o[1]} {UMforCPU/bus/addr_32b_o[2]} {UMforCPU/bus/addr_32b_o[3]} {UMforCPU/bus/addr_32b_o[4]} {UMforCPU/bus/addr_32b_o[5]} {UMforCPU/bus/addr_32b_o[6]} {UMforCPU/bus/addr_32b_o[7]} {UMforCPU/bus/addr_32b_o[8]} {UMforCPU/bus/addr_32b_o[9]} {UMforCPU/bus/addr_32b_o[10]} {UMforCPU/bus/addr_32b_o[11]} {UMforCPU/bus/addr_32b_o[12]} {UMforCPU/bus/addr_32b_o[13]} {UMforCPU/bus/addr_32b_o[14]} {UMforCPU/bus/addr_32b_o[15]} {UMforCPU/bus/addr_32b_o[16]} {UMforCPU/bus/addr_32b_o[17]} {UMforCPU/bus/addr_32b_o[18]} {UMforCPU/bus/addr_32b_o[19]} {UMforCPU/bus/addr_32b_o[20]} {UMforCPU/bus/addr_32b_o[21]} {UMforCPU/bus/addr_32b_o[22]} {UMforCPU/bus/addr_32b_o[23]} {UMforCPU/bus/addr_32b_o[24]} {UMforCPU/bus/addr_32b_o[25]} {UMforCPU/bus/addr_32b_o[26]} {UMforCPU/bus/addr_32b_o[27]} {UMforCPU/bus/addr_32b_o[28]} {UMforCPU/bus/addr_32b_o[29]} {UMforCPU/bus/addr_32b_o[30]} {UMforCPU/bus/addr_32b_o[31]} {UMforCPU/bus/addr_32b_o[32]} {UMforCPU/bus/addr_32b_o[33]} {UMforCPU/bus/addr_32b_o[34]} {UMforCPU/bus/addr_32b_o[35]} {UMforCPU/bus/addr_32b_o[36]} {UMforCPU/bus/addr_32b_o[37]} {UMforCPU/bus/addr_32b_o[38]} {UMforCPU/bus/addr_32b_o[39]} {UMforCPU/bus/addr_32b_o[40]} {UMforCPU/bus/addr_32b_o[41]} {UMforCPU/bus/addr_32b_o[42]} {UMforCPU/bus/addr_32b_o[43]} {UMforCPU/bus/addr_32b_o[44]} {UMforCPU/bus/addr_32b_o[45]} {UMforCPU/bus/addr_32b_o[46]} {UMforCPU/bus/addr_32b_o[47]} {UMforCPU/bus/addr_32b_o[48]} {UMforCPU/bus/addr_32b_o[49]} {UMforCPU/bus/addr_32b_o[50]} {UMforCPU/bus/addr_32b_o[51]} {UMforCPU/bus/addr_32b_o[52]} {UMforCPU/bus/addr_32b_o[53]} {UMforCPU/bus/addr_32b_o[54]} {UMforCPU/bus/addr_32b_o[55]} {UMforCPU/bus/addr_32b_o[56]} {UMforCPU/bus/addr_32b_o[57]} {UMforCPU/bus/addr_32b_o[58]} {UMforCPU/bus/addr_32b_o[59]} {UMforCPU/bus/addr_32b_o[60]} {UMforCPU/bus/addr_32b_o[61]} {UMforCPU/bus/addr_32b_o[62]} {UMforCPU/bus/addr_32b_o[63]} {UMforCPU/bus/addr_32b_o[64]} {UMforCPU/bus/addr_32b_o[65]} {UMforCPU/bus/addr_32b_o[66]} {UMforCPU/bus/addr_32b_o[67]} {UMforCPU/bus/addr_32b_o[68]} {UMforCPU/bus/addr_32b_o[69]} {UMforCPU/bus/addr_32b_o[70]} {UMforCPU/bus/addr_32b_o[71]} {UMforCPU/bus/addr_32b_o[72]} {UMforCPU/bus/addr_32b_o[73]} {UMforCPU/bus/addr_32b_o[74]} {UMforCPU/bus/addr_32b_o[75]} {UMforCPU/bus/addr_32b_o[76]} {UMforCPU/bus/addr_32b_o[77]} {UMforCPU/bus/addr_32b_o[78]} {UMforCPU/bus/addr_32b_o[79]} {UMforCPU/bus/addr_32b_o[80]} {UMforCPU/bus/addr_32b_o[81]} {UMforCPU/bus/addr_32b_o[82]} {UMforCPU/bus/addr_32b_o[83]} {UMforCPU/bus/addr_32b_o[84]} {UMforCPU/bus/addr_32b_o[85]} {UMforCPU/bus/addr_32b_o[86]} {UMforCPU/bus/addr_32b_o[87]} {UMforCPU/bus/addr_32b_o[88]} {UMforCPU/bus/addr_32b_o[89]} {UMforCPU/bus/addr_32b_o[90]} {UMforCPU/bus/addr_32b_o[91]} {UMforCPU/bus/addr_32b_o[92]} {UMforCPU/bus/addr_32b_o[93]} {UMforCPU/bus/addr_32b_o[94]} {UMforCPU/bus/addr_32b_o[95]} {UMforCPU/bus/addr_32b_o[96]} {UMforCPU/bus/addr_32b_o[97]} {UMforCPU/bus/addr_32b_o[98]} {UMforCPU/bus/addr_32b_o[99]} {UMforCPU/bus/addr_32b_o[100]} {UMforCPU/bus/addr_32b_o[101]} {UMforCPU/bus/addr_32b_o[102]} {UMforCPU/bus/addr_32b_o[103]} {UMforCPU/bus/addr_32b_o[104]} {UMforCPU/bus/addr_32b_o[105]} {UMforCPU/bus/addr_32b_o[106]} {UMforCPU/bus/addr_32b_o[107]} {UMforCPU/bus/addr_32b_o[108]} {UMforCPU/bus/addr_32b_o[109]} {UMforCPU/bus/addr_32b_o[110]} {UMforCPU/bus/addr_32b_o[111]} {UMforCPU/bus/addr_32b_o[112]} {UMforCPU/bus/addr_32b_o[113]} {UMforCPU/bus/addr_32b_o[114]} {UMforCPU/bus/addr_32b_o[115]} {UMforCPU/bus/addr_32b_o[116]} {UMforCPU/bus/addr_32b_o[117]} {UMforCPU/bus/addr_32b_o[118]} {UMforCPU/bus/addr_32b_o[119]} {UMforCPU/bus/addr_32b_o[120]} {UMforCPU/bus/addr_32b_o[121]} {UMforCPU/bus/addr_32b_o[122]} {UMforCPU/bus/addr_32b_o[123]} {UMforCPU/bus/addr_32b_o[124]} {UMforCPU/bus/addr_32b_o[125]} {UMforCPU/bus/addr_32b_o[126]} {UMforCPU/bus/addr_32b_o[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {UMforCPU/bus/rden_o[0]} {UMforCPU/bus/rden_o[1]} {UMforCPU/bus/rden_o[2]} {UMforCPU/bus/rden_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/memPkt_inst/cnt_pkt[0]} {UMforCPU/memPkt_inst/cnt_pkt[1]} {UMforCPU/memPkt_inst/cnt_pkt[2]} {UMforCPU/memPkt_inst/cnt_pkt[3]} {UMforCPU/memPkt_inst/cnt_pkt[4]} {UMforCPU/memPkt_inst/cnt_pkt[5]} {UMforCPU/memPkt_inst/cnt_pkt[6]} {UMforCPU/memPkt_inst/cnt_pkt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 134 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/memPkt_inst/din_pktRecv[0]} {UMforCPU/memPkt_inst/din_pktRecv[1]} {UMforCPU/memPkt_inst/din_pktRecv[2]} {UMforCPU/memPkt_inst/din_pktRecv[3]} {UMforCPU/memPkt_inst/din_pktRecv[4]} {UMforCPU/memPkt_inst/din_pktRecv[5]} {UMforCPU/memPkt_inst/din_pktRecv[6]} {UMforCPU/memPkt_inst/din_pktRecv[7]} {UMforCPU/memPkt_inst/din_pktRecv[8]} {UMforCPU/memPkt_inst/din_pktRecv[9]} {UMforCPU/memPkt_inst/din_pktRecv[10]} {UMforCPU/memPkt_inst/din_pktRecv[11]} {UMforCPU/memPkt_inst/din_pktRecv[12]} {UMforCPU/memPkt_inst/din_pktRecv[13]} {UMforCPU/memPkt_inst/din_pktRecv[14]} {UMforCPU/memPkt_inst/din_pktRecv[15]} {UMforCPU/memPkt_inst/din_pktRecv[16]} {UMforCPU/memPkt_inst/din_pktRecv[17]} {UMforCPU/memPkt_inst/din_pktRecv[18]} {UMforCPU/memPkt_inst/din_pktRecv[19]} {UMforCPU/memPkt_inst/din_pktRecv[20]} {UMforCPU/memPkt_inst/din_pktRecv[21]} {UMforCPU/memPkt_inst/din_pktRecv[22]} {UMforCPU/memPkt_inst/din_pktRecv[23]} {UMforCPU/memPkt_inst/din_pktRecv[24]} {UMforCPU/memPkt_inst/din_pktRecv[25]} {UMforCPU/memPkt_inst/din_pktRecv[26]} {UMforCPU/memPkt_inst/din_pktRecv[27]} {UMforCPU/memPkt_inst/din_pktRecv[28]} {UMforCPU/memPkt_inst/din_pktRecv[29]} {UMforCPU/memPkt_inst/din_pktRecv[30]} {UMforCPU/memPkt_inst/din_pktRecv[31]} {UMforCPU/memPkt_inst/din_pktRecv[32]} {UMforCPU/memPkt_inst/din_pktRecv[33]} {UMforCPU/memPkt_inst/din_pktRecv[34]} {UMforCPU/memPkt_inst/din_pktRecv[35]} {UMforCPU/memPkt_inst/din_pktRecv[36]} {UMforCPU/memPkt_inst/din_pktRecv[37]} {UMforCPU/memPkt_inst/din_pktRecv[38]} {UMforCPU/memPkt_inst/din_pktRecv[39]} {UMforCPU/memPkt_inst/din_pktRecv[40]} {UMforCPU/memPkt_inst/din_pktRecv[41]} {UMforCPU/memPkt_inst/din_pktRecv[42]} {UMforCPU/memPkt_inst/din_pktRecv[43]} {UMforCPU/memPkt_inst/din_pktRecv[44]} {UMforCPU/memPkt_inst/din_pktRecv[45]} {UMforCPU/memPkt_inst/din_pktRecv[46]} {UMforCPU/memPkt_inst/din_pktRecv[47]} {UMforCPU/memPkt_inst/din_pktRecv[48]} {UMforCPU/memPkt_inst/din_pktRecv[49]} {UMforCPU/memPkt_inst/din_pktRecv[50]} {UMforCPU/memPkt_inst/din_pktRecv[51]} {UMforCPU/memPkt_inst/din_pktRecv[52]} {UMforCPU/memPkt_inst/din_pktRecv[53]} {UMforCPU/memPkt_inst/din_pktRecv[54]} {UMforCPU/memPkt_inst/din_pktRecv[55]} {UMforCPU/memPkt_inst/din_pktRecv[56]} {UMforCPU/memPkt_inst/din_pktRecv[57]} {UMforCPU/memPkt_inst/din_pktRecv[58]} {UMforCPU/memPkt_inst/din_pktRecv[59]} {UMforCPU/memPkt_inst/din_pktRecv[60]} {UMforCPU/memPkt_inst/din_pktRecv[61]} {UMforCPU/memPkt_inst/din_pktRecv[62]} {UMforCPU/memPkt_inst/din_pktRecv[63]} {UMforCPU/memPkt_inst/din_pktRecv[64]} {UMforCPU/memPkt_inst/din_pktRecv[65]} {UMforCPU/memPkt_inst/din_pktRecv[66]} {UMforCPU/memPkt_inst/din_pktRecv[67]} {UMforCPU/memPkt_inst/din_pktRecv[68]} {UMforCPU/memPkt_inst/din_pktRecv[69]} {UMforCPU/memPkt_inst/din_pktRecv[70]} {UMforCPU/memPkt_inst/din_pktRecv[71]} {UMforCPU/memPkt_inst/din_pktRecv[72]} {UMforCPU/memPkt_inst/din_pktRecv[73]} {UMforCPU/memPkt_inst/din_pktRecv[74]} {UMforCPU/memPkt_inst/din_pktRecv[75]} {UMforCPU/memPkt_inst/din_pktRecv[76]} {UMforCPU/memPkt_inst/din_pktRecv[77]} {UMforCPU/memPkt_inst/din_pktRecv[78]} {UMforCPU/memPkt_inst/din_pktRecv[79]} {UMforCPU/memPkt_inst/din_pktRecv[80]} {UMforCPU/memPkt_inst/din_pktRecv[81]} {UMforCPU/memPkt_inst/din_pktRecv[82]} {UMforCPU/memPkt_inst/din_pktRecv[83]} {UMforCPU/memPkt_inst/din_pktRecv[84]} {UMforCPU/memPkt_inst/din_pktRecv[85]} {UMforCPU/memPkt_inst/din_pktRecv[86]} {UMforCPU/memPkt_inst/din_pktRecv[87]} {UMforCPU/memPkt_inst/din_pktRecv[88]} {UMforCPU/memPkt_inst/din_pktRecv[89]} {UMforCPU/memPkt_inst/din_pktRecv[90]} {UMforCPU/memPkt_inst/din_pktRecv[91]} {UMforCPU/memPkt_inst/din_pktRecv[92]} {UMforCPU/memPkt_inst/din_pktRecv[93]} {UMforCPU/memPkt_inst/din_pktRecv[94]} {UMforCPU/memPkt_inst/din_pktRecv[95]} {UMforCPU/memPkt_inst/din_pktRecv[96]} {UMforCPU/memPkt_inst/din_pktRecv[97]} {UMforCPU/memPkt_inst/din_pktRecv[98]} {UMforCPU/memPkt_inst/din_pktRecv[99]} {UMforCPU/memPkt_inst/din_pktRecv[100]} {UMforCPU/memPkt_inst/din_pktRecv[101]} {UMforCPU/memPkt_inst/din_pktRecv[102]} {UMforCPU/memPkt_inst/din_pktRecv[103]} {UMforCPU/memPkt_inst/din_pktRecv[104]} {UMforCPU/memPkt_inst/din_pktRecv[105]} {UMforCPU/memPkt_inst/din_pktRecv[106]} {UMforCPU/memPkt_inst/din_pktRecv[107]} {UMforCPU/memPkt_inst/din_pktRecv[108]} {UMforCPU/memPkt_inst/din_pktRecv[109]} {UMforCPU/memPkt_inst/din_pktRecv[110]} {UMforCPU/memPkt_inst/din_pktRecv[111]} {UMforCPU/memPkt_inst/din_pktRecv[112]} {UMforCPU/memPkt_inst/din_pktRecv[113]} {UMforCPU/memPkt_inst/din_pktRecv[114]} {UMforCPU/memPkt_inst/din_pktRecv[115]} {UMforCPU/memPkt_inst/din_pktRecv[116]} {UMforCPU/memPkt_inst/din_pktRecv[117]} {UMforCPU/memPkt_inst/din_pktRecv[118]} {UMforCPU/memPkt_inst/din_pktRecv[119]} {UMforCPU/memPkt_inst/din_pktRecv[120]} {UMforCPU/memPkt_inst/din_pktRecv[121]} {UMforCPU/memPkt_inst/din_pktRecv[122]} {UMforCPU/memPkt_inst/din_pktRecv[123]} {UMforCPU/memPkt_inst/din_pktRecv[124]} {UMforCPU/memPkt_inst/din_pktRecv[125]} {UMforCPU/memPkt_inst/din_pktRecv[126]} {UMforCPU/memPkt_inst/din_pktRecv[127]} {UMforCPU/memPkt_inst/din_pktRecv[128]} {UMforCPU/memPkt_inst/din_pktRecv[129]} {UMforCPU/memPkt_inst/din_pktRecv[130]} {UMforCPU/memPkt_inst/din_pktRecv[131]} {UMforCPU/memPkt_inst/din_pktRecv[132]} {UMforCPU/memPkt_inst/din_pktRecv[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/memPkt_inst/din_pkt_sw[0]} {UMforCPU/memPkt_inst/din_pkt_sw[1]} {UMforCPU/memPkt_inst/din_pkt_sw[2]} {UMforCPU/memPkt_inst/din_pkt_sw[3]} {UMforCPU/memPkt_inst/din_pkt_sw[4]} {UMforCPU/memPkt_inst/din_pkt_sw[5]} {UMforCPU/memPkt_inst/din_pkt_sw[6]} {UMforCPU/memPkt_inst/din_pkt_sw[7]} {UMforCPU/memPkt_inst/din_pkt_sw[8]} {UMforCPU/memPkt_inst/din_pkt_sw[9]} {UMforCPU/memPkt_inst/din_pkt_sw[10]} {UMforCPU/memPkt_inst/din_pkt_sw[11]} {UMforCPU/memPkt_inst/din_pkt_sw[12]} {UMforCPU/memPkt_inst/din_pkt_sw[13]} {UMforCPU/memPkt_inst/din_pkt_sw[14]} {UMforCPU/memPkt_inst/din_pkt_sw[15]} {UMforCPU/memPkt_inst/din_pkt_sw[16]} {UMforCPU/memPkt_inst/din_pkt_sw[17]} {UMforCPU/memPkt_inst/din_pkt_sw[18]} {UMforCPU/memPkt_inst/din_pkt_sw[19]} {UMforCPU/memPkt_inst/din_pkt_sw[20]} {UMforCPU/memPkt_inst/din_pkt_sw[21]} {UMforCPU/memPkt_inst/din_pkt_sw[22]} {UMforCPU/memPkt_inst/din_pkt_sw[23]} {UMforCPU/memPkt_inst/din_pkt_sw[24]} {UMforCPU/memPkt_inst/din_pkt_sw[25]} {UMforCPU/memPkt_inst/din_pkt_sw[26]} {UMforCPU/memPkt_inst/din_pkt_sw[27]} {UMforCPU/memPkt_inst/din_pkt_sw[28]} {UMforCPU/memPkt_inst/din_pkt_sw[29]} {UMforCPU/memPkt_inst/din_pkt_sw[30]} {UMforCPU/memPkt_inst/din_pkt_sw[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/memPkt_inst/din_pkt_hw[0]} {UMforCPU/memPkt_inst/din_pkt_hw[1]} {UMforCPU/memPkt_inst/din_pkt_hw[2]} {UMforCPU/memPkt_inst/din_pkt_hw[3]} {UMforCPU/memPkt_inst/din_pkt_hw[4]} {UMforCPU/memPkt_inst/din_pkt_hw[5]} {UMforCPU/memPkt_inst/din_pkt_hw[6]} {UMforCPU/memPkt_inst/din_pkt_hw[7]} {UMforCPU/memPkt_inst/din_pkt_hw[8]} {UMforCPU/memPkt_inst/din_pkt_hw[9]} {UMforCPU/memPkt_inst/din_pkt_hw[10]} {UMforCPU/memPkt_inst/din_pkt_hw[11]} {UMforCPU/memPkt_inst/din_pkt_hw[12]} {UMforCPU/memPkt_inst/din_pkt_hw[13]} {UMforCPU/memPkt_inst/din_pkt_hw[14]} {UMforCPU/memPkt_inst/din_pkt_hw[15]} {UMforCPU/memPkt_inst/din_pkt_hw[16]} {UMforCPU/memPkt_inst/din_pkt_hw[17]} {UMforCPU/memPkt_inst/din_pkt_hw[18]} {UMforCPU/memPkt_inst/din_pkt_hw[19]} {UMforCPU/memPkt_inst/din_pkt_hw[20]} {UMforCPU/memPkt_inst/din_pkt_hw[21]} {UMforCPU/memPkt_inst/din_pkt_hw[22]} {UMforCPU/memPkt_inst/din_pkt_hw[23]} {UMforCPU/memPkt_inst/din_pkt_hw[24]} {UMforCPU/memPkt_inst/din_pkt_hw[25]} {UMforCPU/memPkt_inst/din_pkt_hw[26]} {UMforCPU/memPkt_inst/din_pkt_hw[27]} {UMforCPU/memPkt_inst/din_pkt_hw[28]} {UMforCPU/memPkt_inst/din_pkt_hw[29]} {UMforCPU/memPkt_inst/din_pkt_hw[30]} {UMforCPU/memPkt_inst/din_pkt_hw[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 134 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {UMforCPU/memPkt_inst/dout_pktSend[0]} {UMforCPU/memPkt_inst/dout_pktSend[1]} {UMforCPU/memPkt_inst/dout_pktSend[2]} {UMforCPU/memPkt_inst/dout_pktSend[3]} {UMforCPU/memPkt_inst/dout_pktSend[4]} {UMforCPU/memPkt_inst/dout_pktSend[5]} {UMforCPU/memPkt_inst/dout_pktSend[6]} {UMforCPU/memPkt_inst/dout_pktSend[7]} {UMforCPU/memPkt_inst/dout_pktSend[8]} {UMforCPU/memPkt_inst/dout_pktSend[9]} {UMforCPU/memPkt_inst/dout_pktSend[10]} {UMforCPU/memPkt_inst/dout_pktSend[11]} {UMforCPU/memPkt_inst/dout_pktSend[12]} {UMforCPU/memPkt_inst/dout_pktSend[13]} {UMforCPU/memPkt_inst/dout_pktSend[14]} {UMforCPU/memPkt_inst/dout_pktSend[15]} {UMforCPU/memPkt_inst/dout_pktSend[16]} {UMforCPU/memPkt_inst/dout_pktSend[17]} {UMforCPU/memPkt_inst/dout_pktSend[18]} {UMforCPU/memPkt_inst/dout_pktSend[19]} {UMforCPU/memPkt_inst/dout_pktSend[20]} {UMforCPU/memPkt_inst/dout_pktSend[21]} {UMforCPU/memPkt_inst/dout_pktSend[22]} {UMforCPU/memPkt_inst/dout_pktSend[23]} {UMforCPU/memPkt_inst/dout_pktSend[24]} {UMforCPU/memPkt_inst/dout_pktSend[25]} {UMforCPU/memPkt_inst/dout_pktSend[26]} {UMforCPU/memPkt_inst/dout_pktSend[27]} {UMforCPU/memPkt_inst/dout_pktSend[28]} {UMforCPU/memPkt_inst/dout_pktSend[29]} {UMforCPU/memPkt_inst/dout_pktSend[30]} {UMforCPU/memPkt_inst/dout_pktSend[31]} {UMforCPU/memPkt_inst/dout_pktSend[32]} {UMforCPU/memPkt_inst/dout_pktSend[33]} {UMforCPU/memPkt_inst/dout_pktSend[34]} {UMforCPU/memPkt_inst/dout_pktSend[35]} {UMforCPU/memPkt_inst/dout_pktSend[36]} {UMforCPU/memPkt_inst/dout_pktSend[37]} {UMforCPU/memPkt_inst/dout_pktSend[38]} {UMforCPU/memPkt_inst/dout_pktSend[39]} {UMforCPU/memPkt_inst/dout_pktSend[40]} {UMforCPU/memPkt_inst/dout_pktSend[41]} {UMforCPU/memPkt_inst/dout_pktSend[42]} {UMforCPU/memPkt_inst/dout_pktSend[43]} {UMforCPU/memPkt_inst/dout_pktSend[44]} {UMforCPU/memPkt_inst/dout_pktSend[45]} {UMforCPU/memPkt_inst/dout_pktSend[46]} {UMforCPU/memPkt_inst/dout_pktSend[47]} {UMforCPU/memPkt_inst/dout_pktSend[48]} {UMforCPU/memPkt_inst/dout_pktSend[49]} {UMforCPU/memPkt_inst/dout_pktSend[50]} {UMforCPU/memPkt_inst/dout_pktSend[51]} {UMforCPU/memPkt_inst/dout_pktSend[52]} {UMforCPU/memPkt_inst/dout_pktSend[53]} {UMforCPU/memPkt_inst/dout_pktSend[54]} {UMforCPU/memPkt_inst/dout_pktSend[55]} {UMforCPU/memPkt_inst/dout_pktSend[56]} {UMforCPU/memPkt_inst/dout_pktSend[57]} {UMforCPU/memPkt_inst/dout_pktSend[58]} {UMforCPU/memPkt_inst/dout_pktSend[59]} {UMforCPU/memPkt_inst/dout_pktSend[60]} {UMforCPU/memPkt_inst/dout_pktSend[61]} {UMforCPU/memPkt_inst/dout_pktSend[62]} {UMforCPU/memPkt_inst/dout_pktSend[63]} {UMforCPU/memPkt_inst/dout_pktSend[64]} {UMforCPU/memPkt_inst/dout_pktSend[65]} {UMforCPU/memPkt_inst/dout_pktSend[66]} {UMforCPU/memPkt_inst/dout_pktSend[67]} {UMforCPU/memPkt_inst/dout_pktSend[68]} {UMforCPU/memPkt_inst/dout_pktSend[69]} {UMforCPU/memPkt_inst/dout_pktSend[70]} {UMforCPU/memPkt_inst/dout_pktSend[71]} {UMforCPU/memPkt_inst/dout_pktSend[72]} {UMforCPU/memPkt_inst/dout_pktSend[73]} {UMforCPU/memPkt_inst/dout_pktSend[74]} {UMforCPU/memPkt_inst/dout_pktSend[75]} {UMforCPU/memPkt_inst/dout_pktSend[76]} {UMforCPU/memPkt_inst/dout_pktSend[77]} {UMforCPU/memPkt_inst/dout_pktSend[78]} {UMforCPU/memPkt_inst/dout_pktSend[79]} {UMforCPU/memPkt_inst/dout_pktSend[80]} {UMforCPU/memPkt_inst/dout_pktSend[81]} {UMforCPU/memPkt_inst/dout_pktSend[82]} {UMforCPU/memPkt_inst/dout_pktSend[83]} {UMforCPU/memPkt_inst/dout_pktSend[84]} {UMforCPU/memPkt_inst/dout_pktSend[85]} {UMforCPU/memPkt_inst/dout_pktSend[86]} {UMforCPU/memPkt_inst/dout_pktSend[87]} {UMforCPU/memPkt_inst/dout_pktSend[88]} {UMforCPU/memPkt_inst/dout_pktSend[89]} {UMforCPU/memPkt_inst/dout_pktSend[90]} {UMforCPU/memPkt_inst/dout_pktSend[91]} {UMforCPU/memPkt_inst/dout_pktSend[92]} {UMforCPU/memPkt_inst/dout_pktSend[93]} {UMforCPU/memPkt_inst/dout_pktSend[94]} {UMforCPU/memPkt_inst/dout_pktSend[95]} {UMforCPU/memPkt_inst/dout_pktSend[96]} {UMforCPU/memPkt_inst/dout_pktSend[97]} {UMforCPU/memPkt_inst/dout_pktSend[98]} {UMforCPU/memPkt_inst/dout_pktSend[99]} {UMforCPU/memPkt_inst/dout_pktSend[100]} {UMforCPU/memPkt_inst/dout_pktSend[101]} {UMforCPU/memPkt_inst/dout_pktSend[102]} {UMforCPU/memPkt_inst/dout_pktSend[103]} {UMforCPU/memPkt_inst/dout_pktSend[104]} {UMforCPU/memPkt_inst/dout_pktSend[105]} {UMforCPU/memPkt_inst/dout_pktSend[106]} {UMforCPU/memPkt_inst/dout_pktSend[107]} {UMforCPU/memPkt_inst/dout_pktSend[108]} {UMforCPU/memPkt_inst/dout_pktSend[109]} {UMforCPU/memPkt_inst/dout_pktSend[110]} {UMforCPU/memPkt_inst/dout_pktSend[111]} {UMforCPU/memPkt_inst/dout_pktSend[112]} {UMforCPU/memPkt_inst/dout_pktSend[113]} {UMforCPU/memPkt_inst/dout_pktSend[114]} {UMforCPU/memPkt_inst/dout_pktSend[115]} {UMforCPU/memPkt_inst/dout_pktSend[116]} {UMforCPU/memPkt_inst/dout_pktSend[117]} {UMforCPU/memPkt_inst/dout_pktSend[118]} {UMforCPU/memPkt_inst/dout_pktSend[119]} {UMforCPU/memPkt_inst/dout_pktSend[120]} {UMforCPU/memPkt_inst/dout_pktSend[121]} {UMforCPU/memPkt_inst/dout_pktSend[122]} {UMforCPU/memPkt_inst/dout_pktSend[123]} {UMforCPU/memPkt_inst/dout_pktSend[124]} {UMforCPU/memPkt_inst/dout_pktSend[125]} {UMforCPU/memPkt_inst/dout_pktSend[126]} {UMforCPU/memPkt_inst/dout_pktSend[127]} {UMforCPU/memPkt_inst/dout_pktSend[128]} {UMforCPU/memPkt_inst/dout_pktSend[129]} {UMforCPU/memPkt_inst/dout_pktSend[130]} {UMforCPU/memPkt_inst/dout_pktSend[131]} {UMforCPU/memPkt_inst/dout_pktSend[132]} {UMforCPU/memPkt_inst/dout_pktSend[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 10 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {UMforCPU/memPkt_inst/addr_pkt_sw[0]} {UMforCPU/memPkt_inst/addr_pkt_sw[1]} {UMforCPU/memPkt_inst/addr_pkt_sw[2]} {UMforCPU/memPkt_inst/addr_pkt_sw[3]} {UMforCPU/memPkt_inst/addr_pkt_sw[4]} {UMforCPU/memPkt_inst/addr_pkt_sw[5]} {UMforCPU/memPkt_inst/addr_pkt_sw[6]} {UMforCPU/memPkt_inst/addr_pkt_sw[7]} {UMforCPU/memPkt_inst/addr_pkt_sw[8]} {UMforCPU/memPkt_inst/addr_pkt_sw[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 134 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {UMforCPU/memPkt_inst/din_pktSend[0]} {UMforCPU/memPkt_inst/din_pktSend[1]} {UMforCPU/memPkt_inst/din_pktSend[2]} {UMforCPU/memPkt_inst/din_pktSend[3]} {UMforCPU/memPkt_inst/din_pktSend[4]} {UMforCPU/memPkt_inst/din_pktSend[5]} {UMforCPU/memPkt_inst/din_pktSend[6]} {UMforCPU/memPkt_inst/din_pktSend[7]} {UMforCPU/memPkt_inst/din_pktSend[8]} {UMforCPU/memPkt_inst/din_pktSend[9]} {UMforCPU/memPkt_inst/din_pktSend[10]} {UMforCPU/memPkt_inst/din_pktSend[11]} {UMforCPU/memPkt_inst/din_pktSend[12]} {UMforCPU/memPkt_inst/din_pktSend[13]} {UMforCPU/memPkt_inst/din_pktSend[14]} {UMforCPU/memPkt_inst/din_pktSend[15]} {UMforCPU/memPkt_inst/din_pktSend[16]} {UMforCPU/memPkt_inst/din_pktSend[17]} {UMforCPU/memPkt_inst/din_pktSend[18]} {UMforCPU/memPkt_inst/din_pktSend[19]} {UMforCPU/memPkt_inst/din_pktSend[20]} {UMforCPU/memPkt_inst/din_pktSend[21]} {UMforCPU/memPkt_inst/din_pktSend[22]} {UMforCPU/memPkt_inst/din_pktSend[23]} {UMforCPU/memPkt_inst/din_pktSend[24]} {UMforCPU/memPkt_inst/din_pktSend[25]} {UMforCPU/memPkt_inst/din_pktSend[26]} {UMforCPU/memPkt_inst/din_pktSend[27]} {UMforCPU/memPkt_inst/din_pktSend[28]} {UMforCPU/memPkt_inst/din_pktSend[29]} {UMforCPU/memPkt_inst/din_pktSend[30]} {UMforCPU/memPkt_inst/din_pktSend[31]} {UMforCPU/memPkt_inst/din_pktSend[32]} {UMforCPU/memPkt_inst/din_pktSend[33]} {UMforCPU/memPkt_inst/din_pktSend[34]} {UMforCPU/memPkt_inst/din_pktSend[35]} {UMforCPU/memPkt_inst/din_pktSend[36]} {UMforCPU/memPkt_inst/din_pktSend[37]} {UMforCPU/memPkt_inst/din_pktSend[38]} {UMforCPU/memPkt_inst/din_pktSend[39]} {UMforCPU/memPkt_inst/din_pktSend[40]} {UMforCPU/memPkt_inst/din_pktSend[41]} {UMforCPU/memPkt_inst/din_pktSend[42]} {UMforCPU/memPkt_inst/din_pktSend[43]} {UMforCPU/memPkt_inst/din_pktSend[44]} {UMforCPU/memPkt_inst/din_pktSend[45]} {UMforCPU/memPkt_inst/din_pktSend[46]} {UMforCPU/memPkt_inst/din_pktSend[47]} {UMforCPU/memPkt_inst/din_pktSend[48]} {UMforCPU/memPkt_inst/din_pktSend[49]} {UMforCPU/memPkt_inst/din_pktSend[50]} {UMforCPU/memPkt_inst/din_pktSend[51]} {UMforCPU/memPkt_inst/din_pktSend[52]} {UMforCPU/memPkt_inst/din_pktSend[53]} {UMforCPU/memPkt_inst/din_pktSend[54]} {UMforCPU/memPkt_inst/din_pktSend[55]} {UMforCPU/memPkt_inst/din_pktSend[56]} {UMforCPU/memPkt_inst/din_pktSend[57]} {UMforCPU/memPkt_inst/din_pktSend[58]} {UMforCPU/memPkt_inst/din_pktSend[59]} {UMforCPU/memPkt_inst/din_pktSend[60]} {UMforCPU/memPkt_inst/din_pktSend[61]} {UMforCPU/memPkt_inst/din_pktSend[62]} {UMforCPU/memPkt_inst/din_pktSend[63]} {UMforCPU/memPkt_inst/din_pktSend[64]} {UMforCPU/memPkt_inst/din_pktSend[65]} {UMforCPU/memPkt_inst/din_pktSend[66]} {UMforCPU/memPkt_inst/din_pktSend[67]} {UMforCPU/memPkt_inst/din_pktSend[68]} {UMforCPU/memPkt_inst/din_pktSend[69]} {UMforCPU/memPkt_inst/din_pktSend[70]} {UMforCPU/memPkt_inst/din_pktSend[71]} {UMforCPU/memPkt_inst/din_pktSend[72]} {UMforCPU/memPkt_inst/din_pktSend[73]} {UMforCPU/memPkt_inst/din_pktSend[74]} {UMforCPU/memPkt_inst/din_pktSend[75]} {UMforCPU/memPkt_inst/din_pktSend[76]} {UMforCPU/memPkt_inst/din_pktSend[77]} {UMforCPU/memPkt_inst/din_pktSend[78]} {UMforCPU/memPkt_inst/din_pktSend[79]} {UMforCPU/memPkt_inst/din_pktSend[80]} {UMforCPU/memPkt_inst/din_pktSend[81]} {UMforCPU/memPkt_inst/din_pktSend[82]} {UMforCPU/memPkt_inst/din_pktSend[83]} {UMforCPU/memPkt_inst/din_pktSend[84]} {UMforCPU/memPkt_inst/din_pktSend[85]} {UMforCPU/memPkt_inst/din_pktSend[86]} {UMforCPU/memPkt_inst/din_pktSend[87]} {UMforCPU/memPkt_inst/din_pktSend[88]} {UMforCPU/memPkt_inst/din_pktSend[89]} {UMforCPU/memPkt_inst/din_pktSend[90]} {UMforCPU/memPkt_inst/din_pktSend[91]} {UMforCPU/memPkt_inst/din_pktSend[92]} {UMforCPU/memPkt_inst/din_pktSend[93]} {UMforCPU/memPkt_inst/din_pktSend[94]} {UMforCPU/memPkt_inst/din_pktSend[95]} {UMforCPU/memPkt_inst/din_pktSend[96]} {UMforCPU/memPkt_inst/din_pktSend[97]} {UMforCPU/memPkt_inst/din_pktSend[98]} {UMforCPU/memPkt_inst/din_pktSend[99]} {UMforCPU/memPkt_inst/din_pktSend[100]} {UMforCPU/memPkt_inst/din_pktSend[101]} {UMforCPU/memPkt_inst/din_pktSend[102]} {UMforCPU/memPkt_inst/din_pktSend[103]} {UMforCPU/memPkt_inst/din_pktSend[104]} {UMforCPU/memPkt_inst/din_pktSend[105]} {UMforCPU/memPkt_inst/din_pktSend[106]} {UMforCPU/memPkt_inst/din_pktSend[107]} {UMforCPU/memPkt_inst/din_pktSend[108]} {UMforCPU/memPkt_inst/din_pktSend[109]} {UMforCPU/memPkt_inst/din_pktSend[110]} {UMforCPU/memPkt_inst/din_pktSend[111]} {UMforCPU/memPkt_inst/din_pktSend[112]} {UMforCPU/memPkt_inst/din_pktSend[113]} {UMforCPU/memPkt_inst/din_pktSend[114]} {UMforCPU/memPkt_inst/din_pktSend[115]} {UMforCPU/memPkt_inst/din_pktSend[116]} {UMforCPU/memPkt_inst/din_pktSend[117]} {UMforCPU/memPkt_inst/din_pktSend[118]} {UMforCPU/memPkt_inst/din_pktSend[119]} {UMforCPU/memPkt_inst/din_pktSend[120]} {UMforCPU/memPkt_inst/din_pktSend[121]} {UMforCPU/memPkt_inst/din_pktSend[122]} {UMforCPU/memPkt_inst/din_pktSend[123]} {UMforCPU/memPkt_inst/din_pktSend[124]} {UMforCPU/memPkt_inst/din_pktSend[125]} {UMforCPU/memPkt_inst/din_pktSend[126]} {UMforCPU/memPkt_inst/din_pktSend[127]} {UMforCPU/memPkt_inst/din_pktSend[128]} {UMforCPU/memPkt_inst/din_pktSend[129]} {UMforCPU/memPkt_inst/din_pktSend[130]} {UMforCPU/memPkt_inst/din_pktSend[131]} {UMforCPU/memPkt_inst/din_pktSend[132]} {UMforCPU/memPkt_inst/din_pktSend[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 10 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {UMforCPU/memPkt_inst/addr_pkt_hw[0]} {UMforCPU/memPkt_inst/addr_pkt_hw[1]} {UMforCPU/memPkt_inst/addr_pkt_hw[2]} {UMforCPU/memPkt_inst/addr_pkt_hw[3]} {UMforCPU/memPkt_inst/addr_pkt_hw[4]} {UMforCPU/memPkt_inst/addr_pkt_hw[5]} {UMforCPU/memPkt_inst/addr_pkt_hw[6]} {UMforCPU/memPkt_inst/addr_pkt_hw[7]} {UMforCPU/memPkt_inst/addr_pkt_hw[8]} {UMforCPU/memPkt_inst/addr_pkt_hw[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 134 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {UMforCPU/memPkt_inst/data_out[0]} {UMforCPU/memPkt_inst/data_out[1]} {UMforCPU/memPkt_inst/data_out[2]} {UMforCPU/memPkt_inst/data_out[3]} {UMforCPU/memPkt_inst/data_out[4]} {UMforCPU/memPkt_inst/data_out[5]} {UMforCPU/memPkt_inst/data_out[6]} {UMforCPU/memPkt_inst/data_out[7]} {UMforCPU/memPkt_inst/data_out[8]} {UMforCPU/memPkt_inst/data_out[9]} {UMforCPU/memPkt_inst/data_out[10]} {UMforCPU/memPkt_inst/data_out[11]} {UMforCPU/memPkt_inst/data_out[12]} {UMforCPU/memPkt_inst/data_out[13]} {UMforCPU/memPkt_inst/data_out[14]} {UMforCPU/memPkt_inst/data_out[15]} {UMforCPU/memPkt_inst/data_out[16]} {UMforCPU/memPkt_inst/data_out[17]} {UMforCPU/memPkt_inst/data_out[18]} {UMforCPU/memPkt_inst/data_out[19]} {UMforCPU/memPkt_inst/data_out[20]} {UMforCPU/memPkt_inst/data_out[21]} {UMforCPU/memPkt_inst/data_out[22]} {UMforCPU/memPkt_inst/data_out[23]} {UMforCPU/memPkt_inst/data_out[24]} {UMforCPU/memPkt_inst/data_out[25]} {UMforCPU/memPkt_inst/data_out[26]} {UMforCPU/memPkt_inst/data_out[27]} {UMforCPU/memPkt_inst/data_out[28]} {UMforCPU/memPkt_inst/data_out[29]} {UMforCPU/memPkt_inst/data_out[30]} {UMforCPU/memPkt_inst/data_out[31]} {UMforCPU/memPkt_inst/data_out[32]} {UMforCPU/memPkt_inst/data_out[33]} {UMforCPU/memPkt_inst/data_out[34]} {UMforCPU/memPkt_inst/data_out[35]} {UMforCPU/memPkt_inst/data_out[36]} {UMforCPU/memPkt_inst/data_out[37]} {UMforCPU/memPkt_inst/data_out[38]} {UMforCPU/memPkt_inst/data_out[39]} {UMforCPU/memPkt_inst/data_out[40]} {UMforCPU/memPkt_inst/data_out[41]} {UMforCPU/memPkt_inst/data_out[42]} {UMforCPU/memPkt_inst/data_out[43]} {UMforCPU/memPkt_inst/data_out[44]} {UMforCPU/memPkt_inst/data_out[45]} {UMforCPU/memPkt_inst/data_out[46]} {UMforCPU/memPkt_inst/data_out[47]} {UMforCPU/memPkt_inst/data_out[48]} {UMforCPU/memPkt_inst/data_out[49]} {UMforCPU/memPkt_inst/data_out[50]} {UMforCPU/memPkt_inst/data_out[51]} {UMforCPU/memPkt_inst/data_out[52]} {UMforCPU/memPkt_inst/data_out[53]} {UMforCPU/memPkt_inst/data_out[54]} {UMforCPU/memPkt_inst/data_out[55]} {UMforCPU/memPkt_inst/data_out[56]} {UMforCPU/memPkt_inst/data_out[57]} {UMforCPU/memPkt_inst/data_out[58]} {UMforCPU/memPkt_inst/data_out[59]} {UMforCPU/memPkt_inst/data_out[60]} {UMforCPU/memPkt_inst/data_out[61]} {UMforCPU/memPkt_inst/data_out[62]} {UMforCPU/memPkt_inst/data_out[63]} {UMforCPU/memPkt_inst/data_out[64]} {UMforCPU/memPkt_inst/data_out[65]} {UMforCPU/memPkt_inst/data_out[66]} {UMforCPU/memPkt_inst/data_out[67]} {UMforCPU/memPkt_inst/data_out[68]} {UMforCPU/memPkt_inst/data_out[69]} {UMforCPU/memPkt_inst/data_out[70]} {UMforCPU/memPkt_inst/data_out[71]} {UMforCPU/memPkt_inst/data_out[72]} {UMforCPU/memPkt_inst/data_out[73]} {UMforCPU/memPkt_inst/data_out[74]} {UMforCPU/memPkt_inst/data_out[75]} {UMforCPU/memPkt_inst/data_out[76]} {UMforCPU/memPkt_inst/data_out[77]} {UMforCPU/memPkt_inst/data_out[78]} {UMforCPU/memPkt_inst/data_out[79]} {UMforCPU/memPkt_inst/data_out[80]} {UMforCPU/memPkt_inst/data_out[81]} {UMforCPU/memPkt_inst/data_out[82]} {UMforCPU/memPkt_inst/data_out[83]} {UMforCPU/memPkt_inst/data_out[84]} {UMforCPU/memPkt_inst/data_out[85]} {UMforCPU/memPkt_inst/data_out[86]} {UMforCPU/memPkt_inst/data_out[87]} {UMforCPU/memPkt_inst/data_out[88]} {UMforCPU/memPkt_inst/data_out[89]} {UMforCPU/memPkt_inst/data_out[90]} {UMforCPU/memPkt_inst/data_out[91]} {UMforCPU/memPkt_inst/data_out[92]} {UMforCPU/memPkt_inst/data_out[93]} {UMforCPU/memPkt_inst/data_out[94]} {UMforCPU/memPkt_inst/data_out[95]} {UMforCPU/memPkt_inst/data_out[96]} {UMforCPU/memPkt_inst/data_out[97]} {UMforCPU/memPkt_inst/data_out[98]} {UMforCPU/memPkt_inst/data_out[99]} {UMforCPU/memPkt_inst/data_out[100]} {UMforCPU/memPkt_inst/data_out[101]} {UMforCPU/memPkt_inst/data_out[102]} {UMforCPU/memPkt_inst/data_out[103]} {UMforCPU/memPkt_inst/data_out[104]} {UMforCPU/memPkt_inst/data_out[105]} {UMforCPU/memPkt_inst/data_out[106]} {UMforCPU/memPkt_inst/data_out[107]} {UMforCPU/memPkt_inst/data_out[108]} {UMforCPU/memPkt_inst/data_out[109]} {UMforCPU/memPkt_inst/data_out[110]} {UMforCPU/memPkt_inst/data_out[111]} {UMforCPU/memPkt_inst/data_out[112]} {UMforCPU/memPkt_inst/data_out[113]} {UMforCPU/memPkt_inst/data_out[114]} {UMforCPU/memPkt_inst/data_out[115]} {UMforCPU/memPkt_inst/data_out[116]} {UMforCPU/memPkt_inst/data_out[117]} {UMforCPU/memPkt_inst/data_out[118]} {UMforCPU/memPkt_inst/data_out[119]} {UMforCPU/memPkt_inst/data_out[120]} {UMforCPU/memPkt_inst/data_out[121]} {UMforCPU/memPkt_inst/data_out[122]} {UMforCPU/memPkt_inst/data_out[123]} {UMforCPU/memPkt_inst/data_out[124]} {UMforCPU/memPkt_inst/data_out[125]} {UMforCPU/memPkt_inst/data_out[126]} {UMforCPU/memPkt_inst/data_out[127]} {UMforCPU/memPkt_inst/data_out[128]} {UMforCPU/memPkt_inst/data_out[129]} {UMforCPU/memPkt_inst/data_out[130]} {UMforCPU/memPkt_inst/data_out[131]} {UMforCPU/memPkt_inst/data_out[132]} {UMforCPU/memPkt_inst/data_out[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 134 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {UMforCPU/memPkt_inst/dout_pktRecv[0]} {UMforCPU/memPkt_inst/dout_pktRecv[1]} {UMforCPU/memPkt_inst/dout_pktRecv[2]} {UMforCPU/memPkt_inst/dout_pktRecv[3]} {UMforCPU/memPkt_inst/dout_pktRecv[4]} {UMforCPU/memPkt_inst/dout_pktRecv[5]} {UMforCPU/memPkt_inst/dout_pktRecv[6]} {UMforCPU/memPkt_inst/dout_pktRecv[7]} {UMforCPU/memPkt_inst/dout_pktRecv[8]} {UMforCPU/memPkt_inst/dout_pktRecv[9]} {UMforCPU/memPkt_inst/dout_pktRecv[10]} {UMforCPU/memPkt_inst/dout_pktRecv[11]} {UMforCPU/memPkt_inst/dout_pktRecv[12]} {UMforCPU/memPkt_inst/dout_pktRecv[13]} {UMforCPU/memPkt_inst/dout_pktRecv[14]} {UMforCPU/memPkt_inst/dout_pktRecv[15]} {UMforCPU/memPkt_inst/dout_pktRecv[16]} {UMforCPU/memPkt_inst/dout_pktRecv[17]} {UMforCPU/memPkt_inst/dout_pktRecv[18]} {UMforCPU/memPkt_inst/dout_pktRecv[19]} {UMforCPU/memPkt_inst/dout_pktRecv[20]} {UMforCPU/memPkt_inst/dout_pktRecv[21]} {UMforCPU/memPkt_inst/dout_pktRecv[22]} {UMforCPU/memPkt_inst/dout_pktRecv[23]} {UMforCPU/memPkt_inst/dout_pktRecv[24]} {UMforCPU/memPkt_inst/dout_pktRecv[25]} {UMforCPU/memPkt_inst/dout_pktRecv[26]} {UMforCPU/memPkt_inst/dout_pktRecv[27]} {UMforCPU/memPkt_inst/dout_pktRecv[28]} {UMforCPU/memPkt_inst/dout_pktRecv[29]} {UMforCPU/memPkt_inst/dout_pktRecv[30]} {UMforCPU/memPkt_inst/dout_pktRecv[31]} {UMforCPU/memPkt_inst/dout_pktRecv[32]} {UMforCPU/memPkt_inst/dout_pktRecv[33]} {UMforCPU/memPkt_inst/dout_pktRecv[34]} {UMforCPU/memPkt_inst/dout_pktRecv[35]} {UMforCPU/memPkt_inst/dout_pktRecv[36]} {UMforCPU/memPkt_inst/dout_pktRecv[37]} {UMforCPU/memPkt_inst/dout_pktRecv[38]} {UMforCPU/memPkt_inst/dout_pktRecv[39]} {UMforCPU/memPkt_inst/dout_pktRecv[40]} {UMforCPU/memPkt_inst/dout_pktRecv[41]} {UMforCPU/memPkt_inst/dout_pktRecv[42]} {UMforCPU/memPkt_inst/dout_pktRecv[43]} {UMforCPU/memPkt_inst/dout_pktRecv[44]} {UMforCPU/memPkt_inst/dout_pktRecv[45]} {UMforCPU/memPkt_inst/dout_pktRecv[46]} {UMforCPU/memPkt_inst/dout_pktRecv[47]} {UMforCPU/memPkt_inst/dout_pktRecv[48]} {UMforCPU/memPkt_inst/dout_pktRecv[49]} {UMforCPU/memPkt_inst/dout_pktRecv[50]} {UMforCPU/memPkt_inst/dout_pktRecv[51]} {UMforCPU/memPkt_inst/dout_pktRecv[52]} {UMforCPU/memPkt_inst/dout_pktRecv[53]} {UMforCPU/memPkt_inst/dout_pktRecv[54]} {UMforCPU/memPkt_inst/dout_pktRecv[55]} {UMforCPU/memPkt_inst/dout_pktRecv[56]} {UMforCPU/memPkt_inst/dout_pktRecv[57]} {UMforCPU/memPkt_inst/dout_pktRecv[58]} {UMforCPU/memPkt_inst/dout_pktRecv[59]} {UMforCPU/memPkt_inst/dout_pktRecv[60]} {UMforCPU/memPkt_inst/dout_pktRecv[61]} {UMforCPU/memPkt_inst/dout_pktRecv[62]} {UMforCPU/memPkt_inst/dout_pktRecv[63]} {UMforCPU/memPkt_inst/dout_pktRecv[64]} {UMforCPU/memPkt_inst/dout_pktRecv[65]} {UMforCPU/memPkt_inst/dout_pktRecv[66]} {UMforCPU/memPkt_inst/dout_pktRecv[67]} {UMforCPU/memPkt_inst/dout_pktRecv[68]} {UMforCPU/memPkt_inst/dout_pktRecv[69]} {UMforCPU/memPkt_inst/dout_pktRecv[70]} {UMforCPU/memPkt_inst/dout_pktRecv[71]} {UMforCPU/memPkt_inst/dout_pktRecv[72]} {UMforCPU/memPkt_inst/dout_pktRecv[73]} {UMforCPU/memPkt_inst/dout_pktRecv[74]} {UMforCPU/memPkt_inst/dout_pktRecv[75]} {UMforCPU/memPkt_inst/dout_pktRecv[76]} {UMforCPU/memPkt_inst/dout_pktRecv[77]} {UMforCPU/memPkt_inst/dout_pktRecv[78]} {UMforCPU/memPkt_inst/dout_pktRecv[79]} {UMforCPU/memPkt_inst/dout_pktRecv[80]} {UMforCPU/memPkt_inst/dout_pktRecv[81]} {UMforCPU/memPkt_inst/dout_pktRecv[82]} {UMforCPU/memPkt_inst/dout_pktRecv[83]} {UMforCPU/memPkt_inst/dout_pktRecv[84]} {UMforCPU/memPkt_inst/dout_pktRecv[85]} {UMforCPU/memPkt_inst/dout_pktRecv[86]} {UMforCPU/memPkt_inst/dout_pktRecv[87]} {UMforCPU/memPkt_inst/dout_pktRecv[88]} {UMforCPU/memPkt_inst/dout_pktRecv[89]} {UMforCPU/memPkt_inst/dout_pktRecv[90]} {UMforCPU/memPkt_inst/dout_pktRecv[91]} {UMforCPU/memPkt_inst/dout_pktRecv[92]} {UMforCPU/memPkt_inst/dout_pktRecv[93]} {UMforCPU/memPkt_inst/dout_pktRecv[94]} {UMforCPU/memPkt_inst/dout_pktRecv[95]} {UMforCPU/memPkt_inst/dout_pktRecv[96]} {UMforCPU/memPkt_inst/dout_pktRecv[97]} {UMforCPU/memPkt_inst/dout_pktRecv[98]} {UMforCPU/memPkt_inst/dout_pktRecv[99]} {UMforCPU/memPkt_inst/dout_pktRecv[100]} {UMforCPU/memPkt_inst/dout_pktRecv[101]} {UMforCPU/memPkt_inst/dout_pktRecv[102]} {UMforCPU/memPkt_inst/dout_pktRecv[103]} {UMforCPU/memPkt_inst/dout_pktRecv[104]} {UMforCPU/memPkt_inst/dout_pktRecv[105]} {UMforCPU/memPkt_inst/dout_pktRecv[106]} {UMforCPU/memPkt_inst/dout_pktRecv[107]} {UMforCPU/memPkt_inst/dout_pktRecv[108]} {UMforCPU/memPkt_inst/dout_pktRecv[109]} {UMforCPU/memPkt_inst/dout_pktRecv[110]} {UMforCPU/memPkt_inst/dout_pktRecv[111]} {UMforCPU/memPkt_inst/dout_pktRecv[112]} {UMforCPU/memPkt_inst/dout_pktRecv[113]} {UMforCPU/memPkt_inst/dout_pktRecv[114]} {UMforCPU/memPkt_inst/dout_pktRecv[115]} {UMforCPU/memPkt_inst/dout_pktRecv[116]} {UMforCPU/memPkt_inst/dout_pktRecv[117]} {UMforCPU/memPkt_inst/dout_pktRecv[118]} {UMforCPU/memPkt_inst/dout_pktRecv[119]} {UMforCPU/memPkt_inst/dout_pktRecv[120]} {UMforCPU/memPkt_inst/dout_pktRecv[121]} {UMforCPU/memPkt_inst/dout_pktRecv[122]} {UMforCPU/memPkt_inst/dout_pktRecv[123]} {UMforCPU/memPkt_inst/dout_pktRecv[124]} {UMforCPU/memPkt_inst/dout_pktRecv[125]} {UMforCPU/memPkt_inst/dout_pktRecv[126]} {UMforCPU/memPkt_inst/dout_pktRecv[127]} {UMforCPU/memPkt_inst/dout_pktRecv[128]} {UMforCPU/memPkt_inst/dout_pktRecv[129]} {UMforCPU/memPkt_inst/dout_pktRecv[130]} {UMforCPU/memPkt_inst/dout_pktRecv[131]} {UMforCPU/memPkt_inst/dout_pktRecv[132]} {UMforCPU/memPkt_inst/dout_pktRecv[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {UMforCPU/memPkt_inst/dout_pkt_hw[0]} {UMforCPU/memPkt_inst/dout_pkt_hw[1]} {UMforCPU/memPkt_inst/dout_pkt_hw[2]} {UMforCPU/memPkt_inst/dout_pkt_hw[3]} {UMforCPU/memPkt_inst/dout_pkt_hw[4]} {UMforCPU/memPkt_inst/dout_pkt_hw[5]} {UMforCPU/memPkt_inst/dout_pkt_hw[6]} {UMforCPU/memPkt_inst/dout_pkt_hw[7]} {UMforCPU/memPkt_inst/dout_pkt_hw[8]} {UMforCPU/memPkt_inst/dout_pkt_hw[9]} {UMforCPU/memPkt_inst/dout_pkt_hw[10]} {UMforCPU/memPkt_inst/dout_pkt_hw[11]} {UMforCPU/memPkt_inst/dout_pkt_hw[12]} {UMforCPU/memPkt_inst/dout_pkt_hw[13]} {UMforCPU/memPkt_inst/dout_pkt_hw[14]} {UMforCPU/memPkt_inst/dout_pkt_hw[15]} {UMforCPU/memPkt_inst/dout_pkt_hw[16]} {UMforCPU/memPkt_inst/dout_pkt_hw[17]} {UMforCPU/memPkt_inst/dout_pkt_hw[18]} {UMforCPU/memPkt_inst/dout_pkt_hw[19]} {UMforCPU/memPkt_inst/dout_pkt_hw[20]} {UMforCPU/memPkt_inst/dout_pkt_hw[21]} {UMforCPU/memPkt_inst/dout_pkt_hw[22]} {UMforCPU/memPkt_inst/dout_pkt_hw[23]} {UMforCPU/memPkt_inst/dout_pkt_hw[24]} {UMforCPU/memPkt_inst/dout_pkt_hw[25]} {UMforCPU/memPkt_inst/dout_pkt_hw[26]} {UMforCPU/memPkt_inst/dout_pkt_hw[27]} {UMforCPU/memPkt_inst/dout_pkt_hw[28]} {UMforCPU/memPkt_inst/dout_pkt_hw[29]} {UMforCPU/memPkt_inst/dout_pkt_hw[30]} {UMforCPU/memPkt_inst/dout_pkt_hw[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 16 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {UMforCPU/memPkt_inst/send_length[0]} {UMforCPU/memPkt_inst/send_length[1]} {UMforCPU/memPkt_inst/send_length[2]} {UMforCPU/memPkt_inst/send_length[3]} {UMforCPU/memPkt_inst/send_length[4]} {UMforCPU/memPkt_inst/send_length[5]} {UMforCPU/memPkt_inst/send_length[6]} {UMforCPU/memPkt_inst/send_length[7]} {UMforCPU/memPkt_inst/send_length[8]} {UMforCPU/memPkt_inst/send_length[9]} {UMforCPU/memPkt_inst/send_length[10]} {UMforCPU/memPkt_inst/send_length[11]} {UMforCPU/memPkt_inst/send_length[12]} {UMforCPU/memPkt_inst/send_length[13]} {UMforCPU/memPkt_inst/send_length[14]} {UMforCPU/memPkt_inst/send_length[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 4 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {UMforCPU/memPkt_inst/state_sendPkt[0]} {UMforCPU/memPkt_inst/state_sendPkt[1]} {UMforCPU/memPkt_inst/state_sendPkt[2]} {UMforCPU/memPkt_inst/state_sendPkt[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 4 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {UMforCPU/memPkt_inst/wren_pkt_sw[0]} {UMforCPU/memPkt_inst/wren_pkt_sw[1]} {UMforCPU/memPkt_inst/wren_pkt_sw[2]} {UMforCPU/memPkt_inst/wren_pkt_sw[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 4 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {UMforCPU/memPkt_inst/wren_pkt_hw[0]} {UMforCPU/memPkt_inst/wren_pkt_hw[1]} {UMforCPU/memPkt_inst/wren_pkt_hw[2]} {UMforCPU/memPkt_inst/wren_pkt_hw[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 9 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {UMforCPU/pwm_inst/cnt_enable[0]} {UMforCPU/pwm_inst/cnt_enable[1]} {UMforCPU/pwm_inst/cnt_enable[2]} {UMforCPU/pwm_inst/cnt_enable[3]} {UMforCPU/pwm_inst/cnt_enable[4]} {UMforCPU/pwm_inst/cnt_enable[5]} {UMforCPU/pwm_inst/cnt_enable[6]} {UMforCPU/pwm_inst/cnt_enable[7]} {UMforCPU/pwm_inst/cnt_enable[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 9 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {UMforCPU/pwm_inst/cnt_target[0]} {UMforCPU/pwm_inst/cnt_target[1]} {UMforCPU/pwm_inst/cnt_target[2]} {UMforCPU/pwm_inst/cnt_target[3]} {UMforCPU/pwm_inst/cnt_target[4]} {UMforCPU/pwm_inst/cnt_target[5]} {UMforCPU/pwm_inst/cnt_target[6]} {UMforCPU/pwm_inst/cnt_target[7]} {UMforCPU/pwm_inst/cnt_target[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 13 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {UMforCPU/memPkt_inst/recv_length_reg[3]} {UMforCPU/memPkt_inst/recv_length_reg[4]} {UMforCPU/memPkt_inst/recv_length_reg[5]} {UMforCPU/memPkt_inst/recv_length_reg[6]} {UMforCPU/memPkt_inst/recv_length_reg[7]} {UMforCPU/memPkt_inst/recv_length_reg[8]} {UMforCPU/memPkt_inst/recv_length_reg[9]} {UMforCPU/memPkt_inst/recv_length_reg[10]} {UMforCPU/memPkt_inst/recv_length_reg[11]} {UMforCPU/memPkt_inst/recv_length_reg[12]} {UMforCPU/memPkt_inst/recv_length_reg[13]} {UMforCPU/memPkt_inst/recv_length_reg[14]} {UMforCPU/memPkt_inst/recv_length_reg[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 4 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {UMforCPU/memPkt_inst/state_checkPkt[0]} {UMforCPU/memPkt_inst/state_checkPkt[1]} {UMforCPU/memPkt_inst/state_checkPkt[2]} {UMforCPU/memPkt_inst/state_checkPkt[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 32 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {UMforCPU/memPkt_inst/dout_pkt_sw_orig[0]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[1]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[2]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[3]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[4]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[5]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[6]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[7]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[8]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[9]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[10]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[11]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[12]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[13]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[14]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[15]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[16]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[17]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[18]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[19]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[20]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[21]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[22]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[23]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[24]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[25]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[26]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[27]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[28]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[29]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[30]} {UMforCPU/memPkt_inst/dout_pkt_sw_orig[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 32 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {UMforCPU/timelyRV_top/mem_rdata_mem[0]} {UMforCPU/timelyRV_top/mem_rdata_mem[1]} {UMforCPU/timelyRV_top/mem_rdata_mem[2]} {UMforCPU/timelyRV_top/mem_rdata_mem[3]} {UMforCPU/timelyRV_top/mem_rdata_mem[4]} {UMforCPU/timelyRV_top/mem_rdata_mem[5]} {UMforCPU/timelyRV_top/mem_rdata_mem[6]} {UMforCPU/timelyRV_top/mem_rdata_mem[7]} {UMforCPU/timelyRV_top/mem_rdata_mem[8]} {UMforCPU/timelyRV_top/mem_rdata_mem[9]} {UMforCPU/timelyRV_top/mem_rdata_mem[10]} {UMforCPU/timelyRV_top/mem_rdata_mem[11]} {UMforCPU/timelyRV_top/mem_rdata_mem[12]} {UMforCPU/timelyRV_top/mem_rdata_mem[13]} {UMforCPU/timelyRV_top/mem_rdata_mem[14]} {UMforCPU/timelyRV_top/mem_rdata_mem[15]} {UMforCPU/timelyRV_top/mem_rdata_mem[16]} {UMforCPU/timelyRV_top/mem_rdata_mem[17]} {UMforCPU/timelyRV_top/mem_rdata_mem[18]} {UMforCPU/timelyRV_top/mem_rdata_mem[19]} {UMforCPU/timelyRV_top/mem_rdata_mem[20]} {UMforCPU/timelyRV_top/mem_rdata_mem[21]} {UMforCPU/timelyRV_top/mem_rdata_mem[22]} {UMforCPU/timelyRV_top/mem_rdata_mem[23]} {UMforCPU/timelyRV_top/mem_rdata_mem[24]} {UMforCPU/timelyRV_top/mem_rdata_mem[25]} {UMforCPU/timelyRV_top/mem_rdata_mem[26]} {UMforCPU/timelyRV_top/mem_rdata_mem[27]} {UMforCPU/timelyRV_top/mem_rdata_mem[28]} {UMforCPU/timelyRV_top/mem_rdata_mem[29]} {UMforCPU/timelyRV_top/mem_rdata_mem[30]} {UMforCPU/timelyRV_top/mem_rdata_mem[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 32 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {UMforCPU/timelyRV_top/mem_rdata[0]} {UMforCPU/timelyRV_top/mem_rdata[1]} {UMforCPU/timelyRV_top/mem_rdata[2]} {UMforCPU/timelyRV_top/mem_rdata[3]} {UMforCPU/timelyRV_top/mem_rdata[4]} {UMforCPU/timelyRV_top/mem_rdata[5]} {UMforCPU/timelyRV_top/mem_rdata[6]} {UMforCPU/timelyRV_top/mem_rdata[7]} {UMforCPU/timelyRV_top/mem_rdata[8]} {UMforCPU/timelyRV_top/mem_rdata[9]} {UMforCPU/timelyRV_top/mem_rdata[10]} {UMforCPU/timelyRV_top/mem_rdata[11]} {UMforCPU/timelyRV_top/mem_rdata[12]} {UMforCPU/timelyRV_top/mem_rdata[13]} {UMforCPU/timelyRV_top/mem_rdata[14]} {UMforCPU/timelyRV_top/mem_rdata[15]} {UMforCPU/timelyRV_top/mem_rdata[16]} {UMforCPU/timelyRV_top/mem_rdata[17]} {UMforCPU/timelyRV_top/mem_rdata[18]} {UMforCPU/timelyRV_top/mem_rdata[19]} {UMforCPU/timelyRV_top/mem_rdata[20]} {UMforCPU/timelyRV_top/mem_rdata[21]} {UMforCPU/timelyRV_top/mem_rdata[22]} {UMforCPU/timelyRV_top/mem_rdata[23]} {UMforCPU/timelyRV_top/mem_rdata[24]} {UMforCPU/timelyRV_top/mem_rdata[25]} {UMforCPU/timelyRV_top/mem_rdata[26]} {UMforCPU/timelyRV_top/mem_rdata[27]} {UMforCPU/timelyRV_top/mem_rdata[28]} {UMforCPU/timelyRV_top/mem_rdata[29]} {UMforCPU/timelyRV_top/mem_rdata[30]} {UMforCPU/timelyRV_top/mem_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 32 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {UMforCPU/timelyRV_top/mem_wdata[0]} {UMforCPU/timelyRV_top/mem_wdata[1]} {UMforCPU/timelyRV_top/mem_wdata[2]} {UMforCPU/timelyRV_top/mem_wdata[3]} {UMforCPU/timelyRV_top/mem_wdata[4]} {UMforCPU/timelyRV_top/mem_wdata[5]} {UMforCPU/timelyRV_top/mem_wdata[6]} {UMforCPU/timelyRV_top/mem_wdata[7]} {UMforCPU/timelyRV_top/mem_wdata[8]} {UMforCPU/timelyRV_top/mem_wdata[9]} {UMforCPU/timelyRV_top/mem_wdata[10]} {UMforCPU/timelyRV_top/mem_wdata[11]} {UMforCPU/timelyRV_top/mem_wdata[12]} {UMforCPU/timelyRV_top/mem_wdata[13]} {UMforCPU/timelyRV_top/mem_wdata[14]} {UMforCPU/timelyRV_top/mem_wdata[15]} {UMforCPU/timelyRV_top/mem_wdata[16]} {UMforCPU/timelyRV_top/mem_wdata[17]} {UMforCPU/timelyRV_top/mem_wdata[18]} {UMforCPU/timelyRV_top/mem_wdata[19]} {UMforCPU/timelyRV_top/mem_wdata[20]} {UMforCPU/timelyRV_top/mem_wdata[21]} {UMforCPU/timelyRV_top/mem_wdata[22]} {UMforCPU/timelyRV_top/mem_wdata[23]} {UMforCPU/timelyRV_top/mem_wdata[24]} {UMforCPU/timelyRV_top/mem_wdata[25]} {UMforCPU/timelyRV_top/mem_wdata[26]} {UMforCPU/timelyRV_top/mem_wdata[27]} {UMforCPU/timelyRV_top/mem_wdata[28]} {UMforCPU/timelyRV_top/mem_wdata[29]} {UMforCPU/timelyRV_top/mem_wdata[30]} {UMforCPU/timelyRV_top/mem_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 4 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {UMforCPU/dout_32b_valid_p[0]} {UMforCPU/dout_32b_valid_p[1]} {UMforCPU/dout_32b_valid_p[2]} {UMforCPU/dout_32b_valid_p[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 4 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {UMforCPU/interrupt_p[0]} {UMforCPU/interrupt_p[1]} {UMforCPU/interrupt_p[2]} {UMforCPU/interrupt_p[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 32 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {UMforCPU/peri_rdata[0]} {UMforCPU/peri_rdata[1]} {UMforCPU/peri_rdata[2]} {UMforCPU/peri_rdata[3]} {UMforCPU/peri_rdata[4]} {UMforCPU/peri_rdata[5]} {UMforCPU/peri_rdata[6]} {UMforCPU/peri_rdata[7]} {UMforCPU/peri_rdata[8]} {UMforCPU/peri_rdata[9]} {UMforCPU/peri_rdata[10]} {UMforCPU/peri_rdata[11]} {UMforCPU/peri_rdata[12]} {UMforCPU/peri_rdata[13]} {UMforCPU/peri_rdata[14]} {UMforCPU/peri_rdata[15]} {UMforCPU/peri_rdata[16]} {UMforCPU/peri_rdata[17]} {UMforCPU/peri_rdata[18]} {UMforCPU/peri_rdata[19]} {UMforCPU/peri_rdata[20]} {UMforCPU/peri_rdata[21]} {UMforCPU/peri_rdata[22]} {UMforCPU/peri_rdata[23]} {UMforCPU/peri_rdata[24]} {UMforCPU/peri_rdata[25]} {UMforCPU/peri_rdata[26]} {UMforCPU/peri_rdata[27]} {UMforCPU/peri_rdata[28]} {UMforCPU/peri_rdata[29]} {UMforCPU/peri_rdata[30]} {UMforCPU/peri_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 4 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {UMforCPU/timelyRV_top/mem_wstrb[0]} {UMforCPU/timelyRV_top/mem_wstrb[1]} {UMforCPU/timelyRV_top/mem_wstrb[2]} {UMforCPU/timelyRV_top/mem_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 134 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {pktData_gmii[0]} {pktData_gmii[1]} {pktData_gmii[2]} {pktData_gmii[3]} {pktData_gmii[4]} {pktData_gmii[5]} {pktData_gmii[6]} {pktData_gmii[7]} {pktData_gmii[8]} {pktData_gmii[9]} {pktData_gmii[10]} {pktData_gmii[11]} {pktData_gmii[12]} {pktData_gmii[13]} {pktData_gmii[14]} {pktData_gmii[15]} {pktData_gmii[16]} {pktData_gmii[17]} {pktData_gmii[18]} {pktData_gmii[19]} {pktData_gmii[20]} {pktData_gmii[21]} {pktData_gmii[22]} {pktData_gmii[23]} {pktData_gmii[24]} {pktData_gmii[25]} {pktData_gmii[26]} {pktData_gmii[27]} {pktData_gmii[28]} {pktData_gmii[29]} {pktData_gmii[30]} {pktData_gmii[31]} {pktData_gmii[32]} {pktData_gmii[33]} {pktData_gmii[34]} {pktData_gmii[35]} {pktData_gmii[36]} {pktData_gmii[37]} {pktData_gmii[38]} {pktData_gmii[39]} {pktData_gmii[40]} {pktData_gmii[41]} {pktData_gmii[42]} {pktData_gmii[43]} {pktData_gmii[44]} {pktData_gmii[45]} {pktData_gmii[46]} {pktData_gmii[47]} {pktData_gmii[48]} {pktData_gmii[49]} {pktData_gmii[50]} {pktData_gmii[51]} {pktData_gmii[52]} {pktData_gmii[53]} {pktData_gmii[54]} {pktData_gmii[55]} {pktData_gmii[56]} {pktData_gmii[57]} {pktData_gmii[58]} {pktData_gmii[59]} {pktData_gmii[60]} {pktData_gmii[61]} {pktData_gmii[62]} {pktData_gmii[63]} {pktData_gmii[64]} {pktData_gmii[65]} {pktData_gmii[66]} {pktData_gmii[67]} {pktData_gmii[68]} {pktData_gmii[69]} {pktData_gmii[70]} {pktData_gmii[71]} {pktData_gmii[72]} {pktData_gmii[73]} {pktData_gmii[74]} {pktData_gmii[75]} {pktData_gmii[76]} {pktData_gmii[77]} {pktData_gmii[78]} {pktData_gmii[79]} {pktData_gmii[80]} {pktData_gmii[81]} {pktData_gmii[82]} {pktData_gmii[83]} {pktData_gmii[84]} {pktData_gmii[85]} {pktData_gmii[86]} {pktData_gmii[87]} {pktData_gmii[88]} {pktData_gmii[89]} {pktData_gmii[90]} {pktData_gmii[91]} {pktData_gmii[92]} {pktData_gmii[93]} {pktData_gmii[94]} {pktData_gmii[95]} {pktData_gmii[96]} {pktData_gmii[97]} {pktData_gmii[98]} {pktData_gmii[99]} {pktData_gmii[100]} {pktData_gmii[101]} {pktData_gmii[102]} {pktData_gmii[103]} {pktData_gmii[104]} {pktData_gmii[105]} {pktData_gmii[106]} {pktData_gmii[107]} {pktData_gmii[108]} {pktData_gmii[109]} {pktData_gmii[110]} {pktData_gmii[111]} {pktData_gmii[112]} {pktData_gmii[113]} {pktData_gmii[114]} {pktData_gmii[115]} {pktData_gmii[116]} {pktData_gmii[117]} {pktData_gmii[118]} {pktData_gmii[119]} {pktData_gmii[120]} {pktData_gmii[121]} {pktData_gmii[122]} {pktData_gmii[123]} {pktData_gmii[124]} {pktData_gmii[125]} {pktData_gmii[126]} {pktData_gmii[127]} {pktData_gmii[128]} {pktData_gmii[129]} {pktData_gmii[130]} {pktData_gmii[131]} {pktData_gmii[132]} {pktData_gmii[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 134 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {pktData_um[0]} {pktData_um[1]} {pktData_um[2]} {pktData_um[3]} {pktData_um[4]} {pktData_um[5]} {pktData_um[6]} {pktData_um[7]} {pktData_um[8]} {pktData_um[9]} {pktData_um[10]} {pktData_um[11]} {pktData_um[12]} {pktData_um[13]} {pktData_um[14]} {pktData_um[15]} {pktData_um[16]} {pktData_um[17]} {pktData_um[18]} {pktData_um[19]} {pktData_um[20]} {pktData_um[21]} {pktData_um[22]} {pktData_um[23]} {pktData_um[24]} {pktData_um[25]} {pktData_um[26]} {pktData_um[27]} {pktData_um[28]} {pktData_um[29]} {pktData_um[30]} {pktData_um[31]} {pktData_um[32]} {pktData_um[33]} {pktData_um[34]} {pktData_um[35]} {pktData_um[36]} {pktData_um[37]} {pktData_um[38]} {pktData_um[39]} {pktData_um[40]} {pktData_um[41]} {pktData_um[42]} {pktData_um[43]} {pktData_um[44]} {pktData_um[45]} {pktData_um[46]} {pktData_um[47]} {pktData_um[48]} {pktData_um[49]} {pktData_um[50]} {pktData_um[51]} {pktData_um[52]} {pktData_um[53]} {pktData_um[54]} {pktData_um[55]} {pktData_um[56]} {pktData_um[57]} {pktData_um[58]} {pktData_um[59]} {pktData_um[60]} {pktData_um[61]} {pktData_um[62]} {pktData_um[63]} {pktData_um[64]} {pktData_um[65]} {pktData_um[66]} {pktData_um[67]} {pktData_um[68]} {pktData_um[69]} {pktData_um[70]} {pktData_um[71]} {pktData_um[72]} {pktData_um[73]} {pktData_um[74]} {pktData_um[75]} {pktData_um[76]} {pktData_um[77]} {pktData_um[78]} {pktData_um[79]} {pktData_um[80]} {pktData_um[81]} {pktData_um[82]} {pktData_um[83]} {pktData_um[84]} {pktData_um[85]} {pktData_um[86]} {pktData_um[87]} {pktData_um[88]} {pktData_um[89]} {pktData_um[90]} {pktData_um[91]} {pktData_um[92]} {pktData_um[93]} {pktData_um[94]} {pktData_um[95]} {pktData_um[96]} {pktData_um[97]} {pktData_um[98]} {pktData_um[99]} {pktData_um[100]} {pktData_um[101]} {pktData_um[102]} {pktData_um[103]} {pktData_um[104]} {pktData_um[105]} {pktData_um[106]} {pktData_um[107]} {pktData_um[108]} {pktData_um[109]} {pktData_um[110]} {pktData_um[111]} {pktData_um[112]} {pktData_um[113]} {pktData_um[114]} {pktData_um[115]} {pktData_um[116]} {pktData_um[117]} {pktData_um[118]} {pktData_um[119]} {pktData_um[120]} {pktData_um[121]} {pktData_um[122]} {pktData_um[123]} {pktData_um[124]} {pktData_um[125]} {pktData_um[126]} {pktData_um[127]} {pktData_um[128]} {pktData_um[129]} {pktData_um[130]} {pktData_um[131]} {pktData_um[132]} {pktData_um[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/data_int_n]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list UMforCPU/memPkt_inst/data_out_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list UMforCPU/memPkt_inst/empty_pktRecv]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list UMforCPU/memPkt_inst/empty_pktSend]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list UMforCPU/timelyRV_top/mem_instr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list UMforCPU/timelyRV_top/mem_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list UMforCPU/timelyRV_top/mem_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list UMforCPU/timelyRV_top/mem_ready_mem]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list UMforCPU/timelyRV_top/mem_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list UMforCPU/timelyRV_top/mem_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list UMforCPU/peri_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list UMforCPU/peri_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list UMforCPU/peri_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list pktData_valid_gmii]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list pktData_valid_um]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list UMforCPU/memPkt_inst/rden_pktRecv]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list UMforCPU/memPkt_inst/rden_pktSend]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list UMforCPU/timelyRV_top/trap]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list UMforCPU/memPkt_inst/wren_pktRecv]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 1 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list UMforCPU/memPkt_inst/wren_pktSend]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_125m]

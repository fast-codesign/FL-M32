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

############## LCD define#############################
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

connect_debug_port u_ila_0/probe0 [get_nets [list {pkt2gmii/head_tag[0]} {pkt2gmii/head_tag[1]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {pkt2gmii/dout_pkt[0]} {pkt2gmii/dout_pkt[1]} {pkt2gmii/dout_pkt[2]} {pkt2gmii/dout_pkt[3]} {pkt2gmii/dout_pkt[4]} {pkt2gmii/dout_pkt[5]} {pkt2gmii/dout_pkt[6]} {pkt2gmii/dout_pkt[7]} {pkt2gmii/dout_pkt[8]} {pkt2gmii/dout_pkt[9]} {pkt2gmii/dout_pkt[10]} {pkt2gmii/dout_pkt[11]} {pkt2gmii/dout_pkt[12]} {pkt2gmii/dout_pkt[13]} {pkt2gmii/dout_pkt[14]} {pkt2gmii/dout_pkt[15]} {pkt2gmii/dout_pkt[16]} {pkt2gmii/dout_pkt[17]} {pkt2gmii/dout_pkt[18]} {pkt2gmii/dout_pkt[19]} {pkt2gmii/dout_pkt[20]} {pkt2gmii/dout_pkt[21]} {pkt2gmii/dout_pkt[22]} {pkt2gmii/dout_pkt[23]} {pkt2gmii/dout_pkt[24]} {pkt2gmii/dout_pkt[25]} {pkt2gmii/dout_pkt[26]} {pkt2gmii/dout_pkt[27]} {pkt2gmii/dout_pkt[28]} {pkt2gmii/dout_pkt[29]} {pkt2gmii/dout_pkt[30]} {pkt2gmii/dout_pkt[31]} {pkt2gmii/dout_pkt[32]} {pkt2gmii/dout_pkt[33]} {pkt2gmii/dout_pkt[34]} {pkt2gmii/dout_pkt[35]} {pkt2gmii/dout_pkt[36]} {pkt2gmii/dout_pkt[37]} {pkt2gmii/dout_pkt[38]} {pkt2gmii/dout_pkt[39]} {pkt2gmii/dout_pkt[40]} {pkt2gmii/dout_pkt[41]} {pkt2gmii/dout_pkt[42]} {pkt2gmii/dout_pkt[43]} {pkt2gmii/dout_pkt[44]} {pkt2gmii/dout_pkt[45]} {pkt2gmii/dout_pkt[46]} {pkt2gmii/dout_pkt[47]} {pkt2gmii/dout_pkt[48]} {pkt2gmii/dout_pkt[49]} {pkt2gmii/dout_pkt[50]} {pkt2gmii/dout_pkt[51]} {pkt2gmii/dout_pkt[52]} {pkt2gmii/dout_pkt[53]} {pkt2gmii/dout_pkt[54]} {pkt2gmii/dout_pkt[55]} {pkt2gmii/dout_pkt[56]} {pkt2gmii/dout_pkt[57]} {pkt2gmii/dout_pkt[58]} {pkt2gmii/dout_pkt[59]} {pkt2gmii/dout_pkt[60]} {pkt2gmii/dout_pkt[61]} {pkt2gmii/dout_pkt[62]} {pkt2gmii/dout_pkt[63]} {pkt2gmii/dout_pkt[64]} {pkt2gmii/dout_pkt[65]} {pkt2gmii/dout_pkt[66]} {pkt2gmii/dout_pkt[67]} {pkt2gmii/dout_pkt[68]} {pkt2gmii/dout_pkt[69]} {pkt2gmii/dout_pkt[70]} {pkt2gmii/dout_pkt[71]} {pkt2gmii/dout_pkt[72]} {pkt2gmii/dout_pkt[73]} {pkt2gmii/dout_pkt[74]} {pkt2gmii/dout_pkt[75]} {pkt2gmii/dout_pkt[76]} {pkt2gmii/dout_pkt[77]} {pkt2gmii/dout_pkt[78]} {pkt2gmii/dout_pkt[79]} {pkt2gmii/dout_pkt[80]} {pkt2gmii/dout_pkt[81]} {pkt2gmii/dout_pkt[82]} {pkt2gmii/dout_pkt[83]} {pkt2gmii/dout_pkt[84]} {pkt2gmii/dout_pkt[85]} {pkt2gmii/dout_pkt[86]} {pkt2gmii/dout_pkt[87]} {pkt2gmii/dout_pkt[88]} {pkt2gmii/dout_pkt[89]} {pkt2gmii/dout_pkt[90]} {pkt2gmii/dout_pkt[91]} {pkt2gmii/dout_pkt[92]} {pkt2gmii/dout_pkt[93]} {pkt2gmii/dout_pkt[94]} {pkt2gmii/dout_pkt[95]} {pkt2gmii/dout_pkt[96]} {pkt2gmii/dout_pkt[97]} {pkt2gmii/dout_pkt[98]} {pkt2gmii/dout_pkt[99]} {pkt2gmii/dout_pkt[100]} {pkt2gmii/dout_pkt[101]} {pkt2gmii/dout_pkt[102]} {pkt2gmii/dout_pkt[103]} {pkt2gmii/dout_pkt[104]} {pkt2gmii/dout_pkt[105]} {pkt2gmii/dout_pkt[106]} {pkt2gmii/dout_pkt[107]} {pkt2gmii/dout_pkt[108]} {pkt2gmii/dout_pkt[109]} {pkt2gmii/dout_pkt[110]} {pkt2gmii/dout_pkt[111]} {pkt2gmii/dout_pkt[112]} {pkt2gmii/dout_pkt[113]} {pkt2gmii/dout_pkt[114]} {pkt2gmii/dout_pkt[115]} {pkt2gmii/dout_pkt[116]} {pkt2gmii/dout_pkt[117]} {pkt2gmii/dout_pkt[118]} {pkt2gmii/dout_pkt[119]} {pkt2gmii/dout_pkt[120]} {pkt2gmii/dout_pkt[121]} {pkt2gmii/dout_pkt[122]} {pkt2gmii/dout_pkt[123]} {pkt2gmii/dout_pkt[124]} {pkt2gmii/dout_pkt[125]} {pkt2gmii/dout_pkt[126]} {pkt2gmii/dout_pkt[127]} {pkt2gmii/dout_pkt[128]} {pkt2gmii/dout_pkt[129]} {pkt2gmii/dout_pkt[130]} {pkt2gmii/dout_pkt[131]} {pkt2gmii/dout_pkt[132]} {pkt2gmii/dout_pkt[133]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {pkt2gmii/state_div[0]} {pkt2gmii/state_div[1]} {pkt2gmii/state_div[2]} {pkt2gmii/state_div[3]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/tm/picorv32/cpu_state[0]} {UMforCPU/tm/picorv32/cpu_state[1]} {UMforCPU/tm/picorv32/cpu_state[2]} {UMforCPU/tm/picorv32/cpu_state[3]} {UMforCPU/tm/picorv32/cpu_state[4]} {UMforCPU/tm/picorv32/cpu_state[5]} {UMforCPU/tm/picorv32/cpu_state[6]} {UMforCPU/tm/picorv32/cpu_state[7]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/tm/mem_rdata[0]} {UMforCPU/tm/mem_rdata[1]} {UMforCPU/tm/mem_rdata[2]} {UMforCPU/tm/mem_rdata[3]} {UMforCPU/tm/mem_rdata[4]} {UMforCPU/tm/mem_rdata[5]} {UMforCPU/tm/mem_rdata[6]} {UMforCPU/tm/mem_rdata[7]} {UMforCPU/tm/mem_rdata[8]} {UMforCPU/tm/mem_rdata[9]} {UMforCPU/tm/mem_rdata[10]} {UMforCPU/tm/mem_rdata[11]} {UMforCPU/tm/mem_rdata[12]} {UMforCPU/tm/mem_rdata[13]} {UMforCPU/tm/mem_rdata[14]} {UMforCPU/tm/mem_rdata[15]} {UMforCPU/tm/mem_rdata[16]} {UMforCPU/tm/mem_rdata[17]} {UMforCPU/tm/mem_rdata[18]} {UMforCPU/tm/mem_rdata[19]} {UMforCPU/tm/mem_rdata[20]} {UMforCPU/tm/mem_rdata[21]} {UMforCPU/tm/mem_rdata[22]} {UMforCPU/tm/mem_rdata[23]} {UMforCPU/tm/mem_rdata[24]} {UMforCPU/tm/mem_rdata[25]} {UMforCPU/tm/mem_rdata[26]} {UMforCPU/tm/mem_rdata[27]} {UMforCPU/tm/mem_rdata[28]} {UMforCPU/tm/mem_rdata[29]} {UMforCPU/tm/mem_rdata[30]} {UMforCPU/tm/mem_rdata[31]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/tm/mem_wdata[0]} {UMforCPU/tm/mem_wdata[1]} {UMforCPU/tm/mem_wdata[2]} {UMforCPU/tm/mem_wdata[3]} {UMforCPU/tm/mem_wdata[4]} {UMforCPU/tm/mem_wdata[5]} {UMforCPU/tm/mem_wdata[6]} {UMforCPU/tm/mem_wdata[7]} {UMforCPU/tm/mem_wdata[8]} {UMforCPU/tm/mem_wdata[9]} {UMforCPU/tm/mem_wdata[10]} {UMforCPU/tm/mem_wdata[11]} {UMforCPU/tm/mem_wdata[12]} {UMforCPU/tm/mem_wdata[13]} {UMforCPU/tm/mem_wdata[14]} {UMforCPU/tm/mem_wdata[15]} {UMforCPU/tm/mem_wdata[16]} {UMforCPU/tm/mem_wdata[17]} {UMforCPU/tm/mem_wdata[18]} {UMforCPU/tm/mem_wdata[19]} {UMforCPU/tm/mem_wdata[20]} {UMforCPU/tm/mem_wdata[21]} {UMforCPU/tm/mem_wdata[22]} {UMforCPU/tm/mem_wdata[23]} {UMforCPU/tm/mem_wdata[24]} {UMforCPU/tm/mem_wdata[25]} {UMforCPU/tm/mem_wdata[26]} {UMforCPU/tm/mem_wdata[27]} {UMforCPU/tm/mem_wdata[28]} {UMforCPU/tm/mem_wdata[29]} {UMforCPU/tm/mem_wdata[30]} {UMforCPU/tm/mem_wdata[31]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/tm/mem_wstrb[0]} {UMforCPU/tm/mem_wstrb[1]} {UMforCPU/tm/mem_wstrb[2]} {UMforCPU/tm/mem_wstrb[3]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list {UMforCPU/tm/mem_addr[0]} {UMforCPU/tm/mem_addr[1]} {UMforCPU/tm/mem_addr[2]} {UMforCPU/tm/mem_addr[3]} {UMforCPU/tm/mem_addr[4]} {UMforCPU/tm/mem_addr[5]} {UMforCPU/tm/mem_addr[6]} {UMforCPU/tm/mem_addr[7]} {UMforCPU/tm/mem_addr[8]} {UMforCPU/tm/mem_addr[9]} {UMforCPU/tm/mem_addr[10]} {UMforCPU/tm/mem_addr[11]} {UMforCPU/tm/mem_addr[12]} {UMforCPU/tm/mem_addr[13]} {UMforCPU/tm/mem_addr[14]} {UMforCPU/tm/mem_addr[15]} {UMforCPU/tm/mem_addr[16]} {UMforCPU/tm/mem_addr[17]} {UMforCPU/tm/mem_addr[18]} {UMforCPU/tm/mem_addr[19]} {UMforCPU/tm/mem_addr[20]} {UMforCPU/tm/mem_addr[21]} {UMforCPU/tm/mem_addr[22]} {UMforCPU/tm/mem_addr[23]} {UMforCPU/tm/mem_addr[24]} {UMforCPU/tm/mem_addr[25]} {UMforCPU/tm/mem_addr[26]} {UMforCPU/tm/mem_addr[27]} {UMforCPU/tm/mem_addr[28]} {UMforCPU/tm/mem_addr[29]} {UMforCPU/tm/mem_addr[30]} {UMforCPU/tm/mem_addr[31]}]]
connect_debug_port u_ila_0/probe8 [get_nets [list {cntPkt_gmii2pkt[0]} {cntPkt_gmii2pkt[1]} {cntPkt_gmii2pkt[2]} {cntPkt_gmii2pkt[3]} {cntPkt_gmii2pkt[4]} {cntPkt_gmii2pkt[5]} {cntPkt_gmii2pkt[6]} {cntPkt_gmii2pkt[7]} {cntPkt_gmii2pkt[8]} {cntPkt_gmii2pkt[9]} {cntPkt_gmii2pkt[10]} {cntPkt_gmii2pkt[11]} {cntPkt_gmii2pkt[12]} {cntPkt_gmii2pkt[13]} {cntPkt_gmii2pkt[14]} {cntPkt_gmii2pkt[15]} {cntPkt_gmii2pkt[16]} {cntPkt_gmii2pkt[17]} {cntPkt_gmii2pkt[18]} {cntPkt_gmii2pkt[19]} {cntPkt_gmii2pkt[20]} {cntPkt_gmii2pkt[21]} {cntPkt_gmii2pkt[22]} {cntPkt_gmii2pkt[23]} {cntPkt_gmii2pkt[24]} {cntPkt_gmii2pkt[25]} {cntPkt_gmii2pkt[26]} {cntPkt_gmii2pkt[27]} {cntPkt_gmii2pkt[28]} {cntPkt_gmii2pkt[29]} {cntPkt_gmii2pkt[30]} {cntPkt_gmii2pkt[31]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {gmiiTxd_calCRC[0]} {gmiiTxd_calCRC[1]} {gmiiTxd_calCRC[2]} {gmiiTxd_calCRC[3]} {gmiiTxd_calCRC[4]} {gmiiTxd_calCRC[5]} {gmiiTxd_calCRC[6]} {gmiiTxd_calCRC[7]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list {cnt_calcCRC[0]} {cnt_calcCRC[1]} {cnt_calcCRC[2]} {cnt_calcCRC[3]} {cnt_calcCRC[4]} {cnt_calcCRC[5]} {cnt_calcCRC[6]} {cnt_calcCRC[7]} {cnt_calcCRC[8]} {cnt_calcCRC[9]} {cnt_calcCRC[10]} {cnt_calcCRC[11]} {cnt_calcCRC[12]} {cnt_calcCRC[13]} {cnt_calcCRC[14]} {cnt_calcCRC[15]} {cnt_calcCRC[16]} {cnt_calcCRC[17]} {cnt_calcCRC[18]} {cnt_calcCRC[19]} {cnt_calcCRC[20]} {cnt_calcCRC[21]} {cnt_calcCRC[22]} {cnt_calcCRC[23]} {cnt_calcCRC[24]} {cnt_calcCRC[25]} {cnt_calcCRC[26]} {cnt_calcCRC[27]} {cnt_calcCRC[28]} {cnt_calcCRC[29]} {cnt_calcCRC[30]} {cnt_calcCRC[31]}]]
connect_debug_port u_ila_0/probe13 [get_nets [list {cntPkt_asynRecvPkt[0]} {cntPkt_asynRecvPkt[1]} {cntPkt_asynRecvPkt[2]} {cntPkt_asynRecvPkt[3]} {cntPkt_asynRecvPkt[4]} {cntPkt_asynRecvPkt[5]} {cntPkt_asynRecvPkt[6]} {cntPkt_asynRecvPkt[7]} {cntPkt_asynRecvPkt[8]} {cntPkt_asynRecvPkt[9]} {cntPkt_asynRecvPkt[10]} {cntPkt_asynRecvPkt[11]} {cntPkt_asynRecvPkt[12]} {cntPkt_asynRecvPkt[13]} {cntPkt_asynRecvPkt[14]} {cntPkt_asynRecvPkt[15]} {cntPkt_asynRecvPkt[16]} {cntPkt_asynRecvPkt[17]} {cntPkt_asynRecvPkt[18]} {cntPkt_asynRecvPkt[19]} {cntPkt_asynRecvPkt[20]} {cntPkt_asynRecvPkt[21]} {cntPkt_asynRecvPkt[22]} {cntPkt_asynRecvPkt[23]} {cntPkt_asynRecvPkt[24]} {cntPkt_asynRecvPkt[25]} {cntPkt_asynRecvPkt[26]} {cntPkt_asynRecvPkt[27]} {cntPkt_asynRecvPkt[28]} {cntPkt_asynRecvPkt[29]} {cntPkt_asynRecvPkt[30]} {cntPkt_asynRecvPkt[31]}]]
connect_debug_port u_ila_0/probe14 [get_nets [list {gmiiRxd_asfifo[0]} {gmiiRxd_asfifo[1]} {gmiiRxd_asfifo[2]} {gmiiRxd_asfifo[3]} {gmiiRxd_asfifo[4]} {gmiiRxd_asfifo[5]} {gmiiRxd_asfifo[6]} {gmiiRxd_asfifo[7]}]]
connect_debug_port u_ila_0/probe15 [get_nets [list {cntPkt_pkt2gmii[0]} {cntPkt_pkt2gmii[1]} {cntPkt_pkt2gmii[2]} {cntPkt_pkt2gmii[3]} {cntPkt_pkt2gmii[4]} {cntPkt_pkt2gmii[5]} {cntPkt_pkt2gmii[6]} {cntPkt_pkt2gmii[7]} {cntPkt_pkt2gmii[8]} {cntPkt_pkt2gmii[9]} {cntPkt_pkt2gmii[10]} {cntPkt_pkt2gmii[11]} {cntPkt_pkt2gmii[12]} {cntPkt_pkt2gmii[13]} {cntPkt_pkt2gmii[14]} {cntPkt_pkt2gmii[15]} {cntPkt_pkt2gmii[16]} {cntPkt_pkt2gmii[17]} {cntPkt_pkt2gmii[18]} {cntPkt_pkt2gmii[19]} {cntPkt_pkt2gmii[20]} {cntPkt_pkt2gmii[21]} {cntPkt_pkt2gmii[22]} {cntPkt_pkt2gmii[23]} {cntPkt_pkt2gmii[24]} {cntPkt_pkt2gmii[25]} {cntPkt_pkt2gmii[26]} {cntPkt_pkt2gmii[27]} {cntPkt_pkt2gmii[28]} {cntPkt_pkt2gmii[29]} {cntPkt_pkt2gmii[30]} {cntPkt_pkt2gmii[31]}]]
connect_debug_port u_ila_0/probe16 [get_nets [list {gmiiTxd_modifyPKT[0]} {gmiiTxd_modifyPKT[1]} {gmiiTxd_modifyPKT[2]} {gmiiTxd_modifyPKT[3]} {gmiiTxd_modifyPKT[4]} {gmiiTxd_modifyPKT[5]} {gmiiTxd_modifyPKT[6]} {gmiiTxd_modifyPKT[7]}]]
connect_debug_port u_ila_0/probe20 [get_nets [list {UMforCPU/data_confMem[0]} {UMforCPU/data_confMem[1]} {UMforCPU/data_confMem[2]} {UMforCPU/data_confMem[3]} {UMforCPU/data_confMem[4]} {UMforCPU/data_confMem[5]} {UMforCPU/data_confMem[6]} {UMforCPU/data_confMem[7]} {UMforCPU/data_confMem[8]} {UMforCPU/data_confMem[9]} {UMforCPU/data_confMem[10]} {UMforCPU/data_confMem[11]} {UMforCPU/data_confMem[12]} {UMforCPU/data_confMem[13]} {UMforCPU/data_confMem[14]} {UMforCPU/data_confMem[15]} {UMforCPU/data_confMem[16]} {UMforCPU/data_confMem[17]} {UMforCPU/data_confMem[18]} {UMforCPU/data_confMem[19]} {UMforCPU/data_confMem[20]} {UMforCPU/data_confMem[21]} {UMforCPU/data_confMem[22]} {UMforCPU/data_confMem[23]} {UMforCPU/data_confMem[24]} {UMforCPU/data_confMem[25]} {UMforCPU/data_confMem[26]} {UMforCPU/data_confMem[27]} {UMforCPU/data_confMem[28]} {UMforCPU/data_confMem[29]} {UMforCPU/data_confMem[30]} {UMforCPU/data_confMem[31]} {UMforCPU/data_confMem[32]} {UMforCPU/data_confMem[33]} {UMforCPU/data_confMem[34]} {UMforCPU/data_confMem[35]} {UMforCPU/data_confMem[36]} {UMforCPU/data_confMem[37]} {UMforCPU/data_confMem[38]} {UMforCPU/data_confMem[39]} {UMforCPU/data_confMem[40]} {UMforCPU/data_confMem[41]} {UMforCPU/data_confMem[42]} {UMforCPU/data_confMem[43]} {UMforCPU/data_confMem[44]} {UMforCPU/data_confMem[45]} {UMforCPU/data_confMem[46]} {UMforCPU/data_confMem[47]} {UMforCPU/data_confMem[48]} {UMforCPU/data_confMem[49]} {UMforCPU/data_confMem[50]} {UMforCPU/data_confMem[51]} {UMforCPU/data_confMem[52]} {UMforCPU/data_confMem[53]} {UMforCPU/data_confMem[54]} {UMforCPU/data_confMem[55]} {UMforCPU/data_confMem[56]} {UMforCPU/data_confMem[57]} {UMforCPU/data_confMem[58]} {UMforCPU/data_confMem[59]} {UMforCPU/data_confMem[60]} {UMforCPU/data_confMem[61]} {UMforCPU/data_confMem[62]} {UMforCPU/data_confMem[63]} {UMforCPU/data_confMem[64]} {UMforCPU/data_confMem[65]} {UMforCPU/data_confMem[66]} {UMforCPU/data_confMem[67]} {UMforCPU/data_confMem[68]} {UMforCPU/data_confMem[69]} {UMforCPU/data_confMem[70]} {UMforCPU/data_confMem[71]} {UMforCPU/data_confMem[72]} {UMforCPU/data_confMem[73]} {UMforCPU/data_confMem[74]} {UMforCPU/data_confMem[75]} {UMforCPU/data_confMem[76]} {UMforCPU/data_confMem[77]} {UMforCPU/data_confMem[78]} {UMforCPU/data_confMem[79]} {UMforCPU/data_confMem[80]} {UMforCPU/data_confMem[81]} {UMforCPU/data_confMem[82]} {UMforCPU/data_confMem[83]} {UMforCPU/data_confMem[84]} {UMforCPU/data_confMem[85]} {UMforCPU/data_confMem[86]} {UMforCPU/data_confMem[87]} {UMforCPU/data_confMem[88]} {UMforCPU/data_confMem[89]} {UMforCPU/data_confMem[90]} {UMforCPU/data_confMem[91]} {UMforCPU/data_confMem[92]} {UMforCPU/data_confMem[93]} {UMforCPU/data_confMem[94]} {UMforCPU/data_confMem[95]} {UMforCPU/data_confMem[96]} {UMforCPU/data_confMem[97]} {UMforCPU/data_confMem[98]} {UMforCPU/data_confMem[99]} {UMforCPU/data_confMem[100]} {UMforCPU/data_confMem[101]} {UMforCPU/data_confMem[102]} {UMforCPU/data_confMem[103]} {UMforCPU/data_confMem[104]} {UMforCPU/data_confMem[105]} {UMforCPU/data_confMem[106]} {UMforCPU/data_confMem[107]} {UMforCPU/data_confMem[108]} {UMforCPU/data_confMem[109]} {UMforCPU/data_confMem[110]} {UMforCPU/data_confMem[111]} {UMforCPU/data_confMem[112]} {UMforCPU/data_confMem[113]} {UMforCPU/data_confMem[114]} {UMforCPU/data_confMem[115]} {UMforCPU/data_confMem[116]} {UMforCPU/data_confMem[117]} {UMforCPU/data_confMem[118]} {UMforCPU/data_confMem[119]} {UMforCPU/data_confMem[120]} {UMforCPU/data_confMem[121]} {UMforCPU/data_confMem[122]} {UMforCPU/data_confMem[123]} {UMforCPU/data_confMem[124]} {UMforCPU/data_confMem[125]} {UMforCPU/data_confMem[126]} {UMforCPU/data_confMem[127]} {UMforCPU/data_confMem[128]} {UMforCPU/data_confMem[129]} {UMforCPU/data_confMem[130]} {UMforCPU/data_confMem[131]} {UMforCPU/data_confMem[132]} {UMforCPU/data_confMem[133]}]]
connect_debug_port u_ila_0/probe24 [get_nets [list UMforCPU/data_valid_confMem]]
connect_debug_port u_ila_0/probe25 [get_nets [list pkt2gmii/empty_pkt]]
connect_debug_port u_ila_0/probe26 [get_nets [list gmiiEn_asfifo]]
connect_debug_port u_ila_0/probe27 [get_nets [list gmiiEn_calCRC]]
connect_debug_port u_ila_0/probe28 [get_nets [list gmiiEn_checkCRC]]
connect_debug_port u_ila_0/probe29 [get_nets [list gmiiEn_modifyPKT]]
connect_debug_port u_ila_0/probe30 [get_nets [list UMforCPU/tm/mem_instr]]
connect_debug_port u_ila_0/probe31 [get_nets [list UMforCPU/tm/mem_rden]]
connect_debug_port u_ila_0/probe32 [get_nets [list UMforCPU/tm/mem_ready]]
connect_debug_port u_ila_0/probe33 [get_nets [list UMforCPU/tm/mem_valid]]
connect_debug_port u_ila_0/probe34 [get_nets [list UMforCPU/tm/mem_wren]]
connect_debug_port u_ila_0/probe37 [get_nets [list pkt2gmii/rden_pkt]]
connect_debug_port u_ila_0/probe38 [get_nets [list UMforCPU/tm/trap]]








connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/picoTop/picorv32/cpu_state[0]} {UMforCPU/picoTop/picorv32/cpu_state[1]} {UMforCPU/picoTop/picorv32/cpu_state[2]} {UMforCPU/picoTop/picorv32/cpu_state[3]} {UMforCPU/picoTop/picorv32/cpu_state[4]} {UMforCPU/picoTop/picorv32/cpu_state[5]} {UMforCPU/picoTop/picorv32/cpu_state[6]} {UMforCPU/picoTop/picorv32/cpu_state[7]}]]


connect_debug_port u_ila_0/probe15 [get_nets [list {UMforCPU/cnt_to_release[0]} {UMforCPU/cnt_to_release[1]} {UMforCPU/cnt_to_release[2]} {UMforCPU/cnt_to_release[3]} {UMforCPU/cnt_to_release[4]} {UMforCPU/cnt_to_release[5]} {UMforCPU/cnt_to_release[6]} {UMforCPU/cnt_to_release[7]} {UMforCPU/cnt_to_release[8]} {UMforCPU/cnt_to_release[9]} {UMforCPU/cnt_to_release[10]}]]




connect_debug_port u_ila_0/probe0 [get_nets [list {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[0]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[1]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[2]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[3]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[4]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[5]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[6]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_i[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {UMforCPU/can_inst/rd_wr_can_inst/data_rd[0]} {UMforCPU/can_inst/rd_wr_can_inst/data_rd[1]} {UMforCPU/can_inst/rd_wr_can_inst/data_rd[2]} {UMforCPU/can_inst/rd_wr_can_inst/data_rd[3]} {UMforCPU/can_inst/rd_wr_can_inst/data_rd[4]} {UMforCPU/can_inst/rd_wr_can_inst/data_rd[5]} {UMforCPU/can_inst/rd_wr_can_inst/data_rd[6]} {UMforCPU/can_inst/rd_wr_can_inst/data_rd[7]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {UMforCPU/can_inst/rd_wr_can_inst/state_can[0]} {UMforCPU/can_inst/rd_wr_can_inst/state_can[1]} {UMforCPU/can_inst/rd_wr_can_inst/state_can[2]} {UMforCPU/can_inst/rd_wr_can_inst/state_can[3]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[0]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[1]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[2]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[3]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[4]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[5]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[6]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[7]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[8]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[9]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[10]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[11]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[12]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[13]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[14]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[15]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[16]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[17]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[18]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[19]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[20]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[21]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[22]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[23]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[24]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[25]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[26]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[27]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[28]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[29]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[30]} {UMforCPU/can_inst/rd_wr_can_inst/dout_32b_o[31]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/can_inst/can_ad_i[0]} {UMforCPU/can_inst/can_ad_i[1]} {UMforCPU/can_inst/can_ad_i[2]} {UMforCPU/can_inst/can_ad_i[3]} {UMforCPU/can_inst/can_ad_i[4]} {UMforCPU/can_inst/can_ad_i[5]} {UMforCPU/can_inst/can_ad_i[6]} {UMforCPU/can_inst/can_ad_i[7]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/can_inst/can_ad_o[0]} {UMforCPU/can_inst/can_ad_o[1]} {UMforCPU/can_inst/can_ad_o[2]} {UMforCPU/can_inst/can_ad_o[3]} {UMforCPU/can_inst/can_ad_o[4]} {UMforCPU/can_inst/can_ad_o[5]} {UMforCPU/can_inst/can_ad_o[6]} {UMforCPU/can_inst/can_ad_o[7]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[0]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[1]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[2]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[3]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[4]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[5]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[6]} {UMforCPU/can_inst/rd_wr_can_inst/can_ad_o[7]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list {UMforCPU/picoTop/mem_wdata[0]} {UMforCPU/picoTop/mem_wdata[1]} {UMforCPU/picoTop/mem_wdata[2]} {UMforCPU/picoTop/mem_wdata[3]} {UMforCPU/picoTop/mem_wdata[4]} {UMforCPU/picoTop/mem_wdata[5]} {UMforCPU/picoTop/mem_wdata[6]} {UMforCPU/picoTop/mem_wdata[7]} {UMforCPU/picoTop/mem_wdata[8]} {UMforCPU/picoTop/mem_wdata[9]} {UMforCPU/picoTop/mem_wdata[10]} {UMforCPU/picoTop/mem_wdata[11]} {UMforCPU/picoTop/mem_wdata[12]} {UMforCPU/picoTop/mem_wdata[13]} {UMforCPU/picoTop/mem_wdata[14]} {UMforCPU/picoTop/mem_wdata[15]} {UMforCPU/picoTop/mem_wdata[16]} {UMforCPU/picoTop/mem_wdata[17]} {UMforCPU/picoTop/mem_wdata[18]} {UMforCPU/picoTop/mem_wdata[19]} {UMforCPU/picoTop/mem_wdata[20]} {UMforCPU/picoTop/mem_wdata[21]} {UMforCPU/picoTop/mem_wdata[22]} {UMforCPU/picoTop/mem_wdata[23]} {UMforCPU/picoTop/mem_wdata[24]} {UMforCPU/picoTop/mem_wdata[25]} {UMforCPU/picoTop/mem_wdata[26]} {UMforCPU/picoTop/mem_wdata[27]} {UMforCPU/picoTop/mem_wdata[28]} {UMforCPU/picoTop/mem_wdata[29]} {UMforCPU/picoTop/mem_wdata[30]} {UMforCPU/picoTop/mem_wdata[31]}]]
connect_debug_port u_ila_0/probe11 [get_nets [list {UMforCPU/picoTop/mem_addr[0]} {UMforCPU/picoTop/mem_addr[1]} {UMforCPU/picoTop/mem_addr[2]} {UMforCPU/picoTop/mem_addr[3]} {UMforCPU/picoTop/mem_addr[4]} {UMforCPU/picoTop/mem_addr[5]} {UMforCPU/picoTop/mem_addr[6]} {UMforCPU/picoTop/mem_addr[7]} {UMforCPU/picoTop/mem_addr[8]} {UMforCPU/picoTop/mem_addr[9]} {UMforCPU/picoTop/mem_addr[10]} {UMforCPU/picoTop/mem_addr[11]} {UMforCPU/picoTop/mem_addr[12]} {UMforCPU/picoTop/mem_addr[13]} {UMforCPU/picoTop/mem_addr[14]} {UMforCPU/picoTop/mem_addr[15]} {UMforCPU/picoTop/mem_addr[16]} {UMforCPU/picoTop/mem_addr[17]} {UMforCPU/picoTop/mem_addr[18]} {UMforCPU/picoTop/mem_addr[19]} {UMforCPU/picoTop/mem_addr[20]} {UMforCPU/picoTop/mem_addr[21]} {UMforCPU/picoTop/mem_addr[22]} {UMforCPU/picoTop/mem_addr[23]} {UMforCPU/picoTop/mem_addr[24]} {UMforCPU/picoTop/mem_addr[25]} {UMforCPU/picoTop/mem_addr[26]} {UMforCPU/picoTop/mem_addr[27]} {UMforCPU/picoTop/mem_addr[28]} {UMforCPU/picoTop/mem_addr[29]} {UMforCPU/picoTop/mem_addr[30]} {UMforCPU/picoTop/mem_addr[31]}]]
connect_debug_port u_ila_0/probe12 [get_nets [list {UMforCPU/picoTop/mem_rdata[0]} {UMforCPU/picoTop/mem_rdata[1]} {UMforCPU/picoTop/mem_rdata[2]} {UMforCPU/picoTop/mem_rdata[3]} {UMforCPU/picoTop/mem_rdata[4]} {UMforCPU/picoTop/mem_rdata[5]} {UMforCPU/picoTop/mem_rdata[6]} {UMforCPU/picoTop/mem_rdata[7]} {UMforCPU/picoTop/mem_rdata[8]} {UMforCPU/picoTop/mem_rdata[9]} {UMforCPU/picoTop/mem_rdata[10]} {UMforCPU/picoTop/mem_rdata[11]} {UMforCPU/picoTop/mem_rdata[12]} {UMforCPU/picoTop/mem_rdata[13]} {UMforCPU/picoTop/mem_rdata[14]} {UMforCPU/picoTop/mem_rdata[15]} {UMforCPU/picoTop/mem_rdata[16]} {UMforCPU/picoTop/mem_rdata[17]} {UMforCPU/picoTop/mem_rdata[18]} {UMforCPU/picoTop/mem_rdata[19]} {UMforCPU/picoTop/mem_rdata[20]} {UMforCPU/picoTop/mem_rdata[21]} {UMforCPU/picoTop/mem_rdata[22]} {UMforCPU/picoTop/mem_rdata[23]} {UMforCPU/picoTop/mem_rdata[24]} {UMforCPU/picoTop/mem_rdata[25]} {UMforCPU/picoTop/mem_rdata[26]} {UMforCPU/picoTop/mem_rdata[27]} {UMforCPU/picoTop/mem_rdata[28]} {UMforCPU/picoTop/mem_rdata[29]} {UMforCPU/picoTop/mem_rdata[30]} {UMforCPU/picoTop/mem_rdata[31]}]]
connect_debug_port u_ila_0/probe13 [get_nets [list {UMforCPU/picoTop/mem_rdata_mem[0]} {UMforCPU/picoTop/mem_rdata_mem[1]} {UMforCPU/picoTop/mem_rdata_mem[2]} {UMforCPU/picoTop/mem_rdata_mem[3]} {UMforCPU/picoTop/mem_rdata_mem[4]} {UMforCPU/picoTop/mem_rdata_mem[5]} {UMforCPU/picoTop/mem_rdata_mem[6]} {UMforCPU/picoTop/mem_rdata_mem[7]} {UMforCPU/picoTop/mem_rdata_mem[8]} {UMforCPU/picoTop/mem_rdata_mem[9]} {UMforCPU/picoTop/mem_rdata_mem[10]} {UMforCPU/picoTop/mem_rdata_mem[11]} {UMforCPU/picoTop/mem_rdata_mem[12]} {UMforCPU/picoTop/mem_rdata_mem[13]} {UMforCPU/picoTop/mem_rdata_mem[14]} {UMforCPU/picoTop/mem_rdata_mem[15]} {UMforCPU/picoTop/mem_rdata_mem[16]} {UMforCPU/picoTop/mem_rdata_mem[17]} {UMforCPU/picoTop/mem_rdata_mem[18]} {UMforCPU/picoTop/mem_rdata_mem[19]} {UMforCPU/picoTop/mem_rdata_mem[20]} {UMforCPU/picoTop/mem_rdata_mem[21]} {UMforCPU/picoTop/mem_rdata_mem[22]} {UMforCPU/picoTop/mem_rdata_mem[23]} {UMforCPU/picoTop/mem_rdata_mem[24]} {UMforCPU/picoTop/mem_rdata_mem[25]} {UMforCPU/picoTop/mem_rdata_mem[26]} {UMforCPU/picoTop/mem_rdata_mem[27]} {UMforCPU/picoTop/mem_rdata_mem[28]} {UMforCPU/picoTop/mem_rdata_mem[29]} {UMforCPU/picoTop/mem_rdata_mem[30]} {UMforCPU/picoTop/mem_rdata_mem[31]}]]
connect_debug_port u_ila_0/probe14 [get_nets [list {UMforCPU/picoTop/mem_wstrb[0]} {UMforCPU/picoTop/mem_wstrb[1]} {UMforCPU/picoTop/mem_wstrb[2]} {UMforCPU/picoTop/mem_wstrb[3]}]]
connect_debug_port u_ila_0/probe16 [get_nets [list {UMforCPU/print_value[0]} {UMforCPU/print_value[1]} {UMforCPU/print_value[2]} {UMforCPU/print_value[3]} {UMforCPU/print_value[4]} {UMforCPU/print_value[5]} {UMforCPU/print_value[6]} {UMforCPU/print_value[7]}]]
connect_debug_port u_ila_0/probe17 [get_nets [list {UMforCPU/addr_32b_i[0]} {UMforCPU/addr_32b_i[1]} {UMforCPU/addr_32b_i[2]} {UMforCPU/addr_32b_i[3]} {UMforCPU/addr_32b_i[4]} {UMforCPU/addr_32b_i[5]} {UMforCPU/addr_32b_i[6]} {UMforCPU/addr_32b_i[7]} {UMforCPU/addr_32b_i[8]} {UMforCPU/addr_32b_i[9]} {UMforCPU/addr_32b_i[10]} {UMforCPU/addr_32b_i[11]} {UMforCPU/addr_32b_i[12]} {UMforCPU/addr_32b_i[13]} {UMforCPU/addr_32b_i[14]} {UMforCPU/addr_32b_i[15]} {UMforCPU/addr_32b_i[16]} {UMforCPU/addr_32b_i[17]} {UMforCPU/addr_32b_i[18]} {UMforCPU/addr_32b_i[19]} {UMforCPU/addr_32b_i[20]} {UMforCPU/addr_32b_i[21]} {UMforCPU/addr_32b_i[22]} {UMforCPU/addr_32b_i[23]} {UMforCPU/addr_32b_i[24]} {UMforCPU/addr_32b_i[25]} {UMforCPU/addr_32b_i[26]} {UMforCPU/addr_32b_i[27]} {UMforCPU/addr_32b_i[28]} {UMforCPU/addr_32b_i[29]} {UMforCPU/addr_32b_i[30]} {UMforCPU/addr_32b_i[31]}]]
connect_debug_port u_ila_0/probe19 [get_nets [list {UMforCPU/dout_32b_o[0]} {UMforCPU/dout_32b_o[1]} {UMforCPU/dout_32b_o[2]} {UMforCPU/dout_32b_o[3]} {UMforCPU/dout_32b_o[4]} {UMforCPU/dout_32b_o[5]} {UMforCPU/dout_32b_o[6]} {UMforCPU/dout_32b_o[7]} {UMforCPU/dout_32b_o[8]} {UMforCPU/dout_32b_o[9]} {UMforCPU/dout_32b_o[10]} {UMforCPU/dout_32b_o[11]} {UMforCPU/dout_32b_o[12]} {UMforCPU/dout_32b_o[13]} {UMforCPU/dout_32b_o[14]} {UMforCPU/dout_32b_o[15]} {UMforCPU/dout_32b_o[16]} {UMforCPU/dout_32b_o[17]} {UMforCPU/dout_32b_o[18]} {UMforCPU/dout_32b_o[19]} {UMforCPU/dout_32b_o[20]} {UMforCPU/dout_32b_o[21]} {UMforCPU/dout_32b_o[22]} {UMforCPU/dout_32b_o[23]} {UMforCPU/dout_32b_o[24]} {UMforCPU/dout_32b_o[25]} {UMforCPU/dout_32b_o[26]} {UMforCPU/dout_32b_o[27]} {UMforCPU/dout_32b_o[28]} {UMforCPU/dout_32b_o[29]} {UMforCPU/dout_32b_o[30]} {UMforCPU/dout_32b_o[31]}]]
connect_debug_port u_ila_0/probe20 [get_nets [list {UMforCPU/din_32b_i[0]} {UMforCPU/din_32b_i[1]} {UMforCPU/din_32b_i[2]} {UMforCPU/din_32b_i[3]} {UMforCPU/din_32b_i[4]} {UMforCPU/din_32b_i[5]} {UMforCPU/din_32b_i[6]} {UMforCPU/din_32b_i[7]} {UMforCPU/din_32b_i[8]} {UMforCPU/din_32b_i[9]} {UMforCPU/din_32b_i[10]} {UMforCPU/din_32b_i[11]} {UMforCPU/din_32b_i[12]} {UMforCPU/din_32b_i[13]} {UMforCPU/din_32b_i[14]} {UMforCPU/din_32b_i[15]} {UMforCPU/din_32b_i[16]} {UMforCPU/din_32b_i[17]} {UMforCPU/din_32b_i[18]} {UMforCPU/din_32b_i[19]} {UMforCPU/din_32b_i[20]} {UMforCPU/din_32b_i[21]} {UMforCPU/din_32b_i[22]} {UMforCPU/din_32b_i[23]} {UMforCPU/din_32b_i[24]} {UMforCPU/din_32b_i[25]} {UMforCPU/din_32b_i[26]} {UMforCPU/din_32b_i[27]} {UMforCPU/din_32b_i[28]} {UMforCPU/din_32b_i[29]} {UMforCPU/din_32b_i[30]} {UMforCPU/din_32b_i[31]}]]
connect_debug_port u_ila_0/probe21 [get_nets [list {UMforCPU/irq_bitmap[4]} {UMforCPU/irq_bitmap[5]}]]
connect_debug_port u_ila_0/probe23 [get_nets [list {UMforCPU/addr_32b_wr[0]} {UMforCPU/addr_32b_wr[1]} {UMforCPU/addr_32b_wr[2]} {UMforCPU/addr_32b_wr[3]} {UMforCPU/addr_32b_wr[4]} {UMforCPU/addr_32b_wr[5]} {UMforCPU/addr_32b_wr[6]} {UMforCPU/addr_32b_wr[7]} {UMforCPU/addr_32b_wr[8]} {UMforCPU/addr_32b_wr[9]} {UMforCPU/addr_32b_wr[10]} {UMforCPU/addr_32b_wr[11]} {UMforCPU/addr_32b_wr[12]} {UMforCPU/addr_32b_wr[13]} {UMforCPU/addr_32b_wr[14]} {UMforCPU/addr_32b_wr[15]} {UMforCPU/addr_32b_wr[16]} {UMforCPU/addr_32b_wr[17]} {UMforCPU/addr_32b_wr[18]} {UMforCPU/addr_32b_wr[19]} {UMforCPU/addr_32b_wr[20]} {UMforCPU/addr_32b_wr[21]} {UMforCPU/addr_32b_wr[22]} {UMforCPU/addr_32b_wr[23]} {UMforCPU/addr_32b_wr[24]} {UMforCPU/addr_32b_wr[25]} {UMforCPU/addr_32b_wr[26]} {UMforCPU/addr_32b_wr[27]} {UMforCPU/addr_32b_wr[28]} {UMforCPU/addr_32b_wr[29]} {UMforCPU/addr_32b_wr[30]} {UMforCPU/addr_32b_wr[31]}]]
connect_debug_port u_ila_0/probe24 [get_nets [list {UMforCPU/cnt_to_release[0]} {UMforCPU/cnt_to_release[1]} {UMforCPU/cnt_to_release[2]} {UMforCPU/cnt_to_release[3]} {UMforCPU/cnt_to_release[4]} {UMforCPU/cnt_to_release[5]} {UMforCPU/cnt_to_release[6]} {UMforCPU/cnt_to_release[7]} {UMforCPU/cnt_to_release[8]} {UMforCPU/cnt_to_release[9]} {UMforCPU/cnt_to_release[10]}]]
connect_debug_port u_ila_0/probe27 [get_nets [list UMforCPU/can_inst/can_ad_sel]]
connect_debug_port u_ila_0/probe28 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/can_ad_sel]]
connect_debug_port u_ila_0/probe29 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/can_ale]]
connect_debug_port u_ila_0/probe30 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/can_cs_n]]
connect_debug_port u_ila_0/probe31 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/can_rd_n]]
connect_debug_port u_ila_0/probe32 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/can_rst_n]]
connect_debug_port u_ila_0/probe33 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/can_wr_n]]
connect_debug_port u_ila_0/probe37 [get_nets [list UMforCPU/can_inst/rd_wr_can_inst/dout_32b_valid_o]]
connect_debug_port u_ila_0/probe38 [get_nets [list UMforCPU/dout_32b_valid_o]]
connect_debug_port u_ila_0/probe39 [get_nets [list UMforCPU/interrupt_o]]
connect_debug_port u_ila_0/probe40 [get_nets [list UMforCPU/picoTop/mem_instr]]
connect_debug_port u_ila_0/probe41 [get_nets [list UMforCPU/picoTop/mem_rden]]
connect_debug_port u_ila_0/probe42 [get_nets [list UMforCPU/picoTop/mem_ready]]
connect_debug_port u_ila_0/probe43 [get_nets [list UMforCPU/picoTop/mem_ready_mem]]
connect_debug_port u_ila_0/probe44 [get_nets [list UMforCPU/picoTop/mem_valid]]
connect_debug_port u_ila_0/probe45 [get_nets [list UMforCPU/picoTop/mem_wren]]
connect_debug_port u_ila_0/probe50 [get_nets [list UMforCPU/print_valid]]
connect_debug_port u_ila_0/probe51 [get_nets [list UMforCPU/rden_can]]
connect_debug_port u_ila_0/probe52 [get_nets [list UMforCPU/rden_i]]
connect_debug_port u_ila_0/probe53 [get_nets [list UMforCPU/tag_has_gen_irq_can]]
connect_debug_port u_ila_0/probe54 [get_nets [list UMforCPU/tag_rd_wr_can]]
connect_debug_port u_ila_0/probe55 [get_nets [list UMforCPU/temp_can_intr_n]]
connect_debug_port u_ila_0/probe56 [get_nets [list UMforCPU/picoTop/trap]]
connect_debug_port u_ila_0/probe57 [get_nets [list UMforCPU/wren_can]]
connect_debug_port u_ila_0/probe58 [get_nets [list UMforCPU/wren_i]]
connect_debug_port u_ila_1/probe0 [get_nets [list {lcd_inst/distance[0]} {lcd_inst/distance[1]} {lcd_inst/distance[2]} {lcd_inst/distance[3]} {lcd_inst/distance[4]} {lcd_inst/distance[5]} {lcd_inst/distance[6]} {lcd_inst/distance[7]} {lcd_inst/distance[8]} {lcd_inst/distance[9]} {lcd_inst/distance[10]} {lcd_inst/distance[11]} {lcd_inst/distance[12]} {lcd_inst/distance[13]} {lcd_inst/distance[14]} {lcd_inst/distance[15]}]]
connect_debug_port u_ila_1/probe1 [get_nets [list {lcd_inst/distance_bcd[0]} {lcd_inst/distance_bcd[1]} {lcd_inst/distance_bcd[2]} {lcd_inst/distance_bcd[3]} {lcd_inst/distance_bcd[4]} {lcd_inst/distance_bcd[5]} {lcd_inst/distance_bcd[6]} {lcd_inst/distance_bcd[7]} {lcd_inst/distance_bcd[8]} {lcd_inst/distance_bcd[9]} {lcd_inst/distance_bcd[10]} {lcd_inst/distance_bcd[11]} {lcd_inst/distance_bcd[12]} {lcd_inst/distance_bcd[13]} {lcd_inst/distance_bcd[14]} {lcd_inst/distance_bcd[15]}]]
connect_debug_port u_ila_1/probe2 [get_nets [list {lcd_inst/dout_dis_data[0]} {lcd_inst/dout_dis_data[1]} {lcd_inst/dout_dis_data[2]} {lcd_inst/dout_dis_data[3]} {lcd_inst/dout_dis_data[4]} {lcd_inst/dout_dis_data[5]} {lcd_inst/dout_dis_data[6]} {lcd_inst/dout_dis_data[7]}]]
connect_debug_port u_ila_1/probe3 [get_nets [list lcd_inst/b_to_bcd_ready]]
connect_debug_port u_ila_1/probe4 [get_nets [list lcd_inst/distance_valid]]
connect_debug_port u_ila_1/probe5 [get_nets [list lcd_inst/distance_valid_bcd]]
connect_debug_port u_ila_1/probe6 [get_nets [list lcd_inst/empty_dis_data]]
connect_debug_port u_ila_1/probe7 [get_nets [list lcd_inst/rden_dis_data]]
connect_debug_port dbg_hub/clk [get_nets clk_9m]







connect_debug_port u_ila_0/probe28 [get_nets [list UMforCPU/bus/already_wr_rd]]

connect_debug_port u_ila_0/probe29 [get_nets [list UMforCPU/dout_32b_valid_p]]
connect_debug_port u_ila_0/probe33 [get_nets [list UMforCPU/interrupt_p]]
connect_debug_port u_ila_0/probe45 [get_nets [list UMforCPU/bus/pre_wr_rd]]
connect_debug_port u_ila_0/probe46 [get_nets [list UMforCPU/rden_p]]
connect_debug_port u_ila_0/probe56 [get_nets [list UMforCPU/wren_p]]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_to_125m/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 30 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {UMforCPU/timelyRV_top/mem_addr_test[0]} {UMforCPU/timelyRV_top/mem_addr_test[1]} {UMforCPU/timelyRV_top/mem_addr_test[2]} {UMforCPU/timelyRV_top/mem_addr_test[3]} {UMforCPU/timelyRV_top/mem_addr_test[4]} {UMforCPU/timelyRV_top/mem_addr_test[5]} {UMforCPU/timelyRV_top/mem_addr_test[6]} {UMforCPU/timelyRV_top/mem_addr_test[7]} {UMforCPU/timelyRV_top/mem_addr_test[8]} {UMforCPU/timelyRV_top/mem_addr_test[9]} {UMforCPU/timelyRV_top/mem_addr_test[10]} {UMforCPU/timelyRV_top/mem_addr_test[11]} {UMforCPU/timelyRV_top/mem_addr_test[12]} {UMforCPU/timelyRV_top/mem_addr_test[13]} {UMforCPU/timelyRV_top/mem_addr_test[14]} {UMforCPU/timelyRV_top/mem_addr_test[15]} {UMforCPU/timelyRV_top/mem_addr_test[16]} {UMforCPU/timelyRV_top/mem_addr_test[17]} {UMforCPU/timelyRV_top/mem_addr_test[18]} {UMforCPU/timelyRV_top/mem_addr_test[19]} {UMforCPU/timelyRV_top/mem_addr_test[20]} {UMforCPU/timelyRV_top/mem_addr_test[21]} {UMforCPU/timelyRV_top/mem_addr_test[22]} {UMforCPU/timelyRV_top/mem_addr_test[23]} {UMforCPU/timelyRV_top/mem_addr_test[24]} {UMforCPU/timelyRV_top/mem_addr_test[25]} {UMforCPU/timelyRV_top/mem_addr_test[26]} {UMforCPU/timelyRV_top/mem_addr_test[27]} {UMforCPU/timelyRV_top/mem_addr_test[28]} {UMforCPU/timelyRV_top/mem_addr_test[29]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {UMforCPU/timelyRV_top/mem_rdata_mem[0]} {UMforCPU/timelyRV_top/mem_rdata_mem[1]} {UMforCPU/timelyRV_top/mem_rdata_mem[2]} {UMforCPU/timelyRV_top/mem_rdata_mem[3]} {UMforCPU/timelyRV_top/mem_rdata_mem[4]} {UMforCPU/timelyRV_top/mem_rdata_mem[5]} {UMforCPU/timelyRV_top/mem_rdata_mem[6]} {UMforCPU/timelyRV_top/mem_rdata_mem[7]} {UMforCPU/timelyRV_top/mem_rdata_mem[8]} {UMforCPU/timelyRV_top/mem_rdata_mem[9]} {UMforCPU/timelyRV_top/mem_rdata_mem[10]} {UMforCPU/timelyRV_top/mem_rdata_mem[11]} {UMforCPU/timelyRV_top/mem_rdata_mem[12]} {UMforCPU/timelyRV_top/mem_rdata_mem[13]} {UMforCPU/timelyRV_top/mem_rdata_mem[14]} {UMforCPU/timelyRV_top/mem_rdata_mem[15]} {UMforCPU/timelyRV_top/mem_rdata_mem[16]} {UMforCPU/timelyRV_top/mem_rdata_mem[17]} {UMforCPU/timelyRV_top/mem_rdata_mem[18]} {UMforCPU/timelyRV_top/mem_rdata_mem[19]} {UMforCPU/timelyRV_top/mem_rdata_mem[20]} {UMforCPU/timelyRV_top/mem_rdata_mem[21]} {UMforCPU/timelyRV_top/mem_rdata_mem[22]} {UMforCPU/timelyRV_top/mem_rdata_mem[23]} {UMforCPU/timelyRV_top/mem_rdata_mem[24]} {UMforCPU/timelyRV_top/mem_rdata_mem[25]} {UMforCPU/timelyRV_top/mem_rdata_mem[26]} {UMforCPU/timelyRV_top/mem_rdata_mem[27]} {UMforCPU/timelyRV_top/mem_rdata_mem[28]} {UMforCPU/timelyRV_top/mem_rdata_mem[29]} {UMforCPU/timelyRV_top/mem_rdata_mem[30]} {UMforCPU/timelyRV_top/mem_rdata_mem[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {UMforCPU/timelyRV_top/mem_wstrb[0]} {UMforCPU/timelyRV_top/mem_wstrb[1]} {UMforCPU/timelyRV_top/mem_wstrb[2]} {UMforCPU/timelyRV_top/mem_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/timelyRV_top/mem_wdata[0]} {UMforCPU/timelyRV_top/mem_wdata[1]} {UMforCPU/timelyRV_top/mem_wdata[2]} {UMforCPU/timelyRV_top/mem_wdata[3]} {UMforCPU/timelyRV_top/mem_wdata[4]} {UMforCPU/timelyRV_top/mem_wdata[5]} {UMforCPU/timelyRV_top/mem_wdata[6]} {UMforCPU/timelyRV_top/mem_wdata[7]} {UMforCPU/timelyRV_top/mem_wdata[8]} {UMforCPU/timelyRV_top/mem_wdata[9]} {UMforCPU/timelyRV_top/mem_wdata[10]} {UMforCPU/timelyRV_top/mem_wdata[11]} {UMforCPU/timelyRV_top/mem_wdata[12]} {UMforCPU/timelyRV_top/mem_wdata[13]} {UMforCPU/timelyRV_top/mem_wdata[14]} {UMforCPU/timelyRV_top/mem_wdata[15]} {UMforCPU/timelyRV_top/mem_wdata[16]} {UMforCPU/timelyRV_top/mem_wdata[17]} {UMforCPU/timelyRV_top/mem_wdata[18]} {UMforCPU/timelyRV_top/mem_wdata[19]} {UMforCPU/timelyRV_top/mem_wdata[20]} {UMforCPU/timelyRV_top/mem_wdata[21]} {UMforCPU/timelyRV_top/mem_wdata[22]} {UMforCPU/timelyRV_top/mem_wdata[23]} {UMforCPU/timelyRV_top/mem_wdata[24]} {UMforCPU/timelyRV_top/mem_wdata[25]} {UMforCPU/timelyRV_top/mem_wdata[26]} {UMforCPU/timelyRV_top/mem_wdata[27]} {UMforCPU/timelyRV_top/mem_wdata[28]} {UMforCPU/timelyRV_top/mem_wdata[29]} {UMforCPU/timelyRV_top/mem_wdata[30]} {UMforCPU/timelyRV_top/mem_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/uart_inst/uart_ctl/din_tx[0]} {UMforCPU/uart_inst/uart_ctl/din_tx[1]} {UMforCPU/uart_inst/uart_ctl/din_tx[2]} {UMforCPU/uart_inst/uart_ctl/din_tx[3]} {UMforCPU/uart_inst/uart_ctl/din_tx[4]} {UMforCPU/uart_inst/uart_ctl/din_tx[5]} {UMforCPU/uart_inst/uart_ctl/din_tx[6]} {UMforCPU/uart_inst/uart_ctl/din_tx[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/timelyRV_top/mem_rdata[0]} {UMforCPU/timelyRV_top/mem_rdata[1]} {UMforCPU/timelyRV_top/mem_rdata[2]} {UMforCPU/timelyRV_top/mem_rdata[3]} {UMforCPU/timelyRV_top/mem_rdata[4]} {UMforCPU/timelyRV_top/mem_rdata[5]} {UMforCPU/timelyRV_top/mem_rdata[6]} {UMforCPU/timelyRV_top/mem_rdata[7]} {UMforCPU/timelyRV_top/mem_rdata[8]} {UMforCPU/timelyRV_top/mem_rdata[9]} {UMforCPU/timelyRV_top/mem_rdata[10]} {UMforCPU/timelyRV_top/mem_rdata[11]} {UMforCPU/timelyRV_top/mem_rdata[12]} {UMforCPU/timelyRV_top/mem_rdata[13]} {UMforCPU/timelyRV_top/mem_rdata[14]} {UMforCPU/timelyRV_top/mem_rdata[15]} {UMforCPU/timelyRV_top/mem_rdata[16]} {UMforCPU/timelyRV_top/mem_rdata[17]} {UMforCPU/timelyRV_top/mem_rdata[18]} {UMforCPU/timelyRV_top/mem_rdata[19]} {UMforCPU/timelyRV_top/mem_rdata[20]} {UMforCPU/timelyRV_top/mem_rdata[21]} {UMforCPU/timelyRV_top/mem_rdata[22]} {UMforCPU/timelyRV_top/mem_rdata[23]} {UMforCPU/timelyRV_top/mem_rdata[24]} {UMforCPU/timelyRV_top/mem_rdata[25]} {UMforCPU/timelyRV_top/mem_rdata[26]} {UMforCPU/timelyRV_top/mem_rdata[27]} {UMforCPU/timelyRV_top/mem_rdata[28]} {UMforCPU/timelyRV_top/mem_rdata[29]} {UMforCPU/timelyRV_top/mem_rdata[30]} {UMforCPU/timelyRV_top/mem_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/uart_inst/uart_ctl/dout_rx[0]} {UMforCPU/uart_inst/uart_ctl/dout_rx[1]} {UMforCPU/uart_inst/uart_ctl/dout_rx[2]} {UMforCPU/uart_inst/uart_ctl/dout_rx[3]} {UMforCPU/uart_inst/uart_ctl/dout_rx[4]} {UMforCPU/uart_inst/uart_ctl/dout_rx[5]} {UMforCPU/uart_inst/uart_ctl/dout_rx[6]} {UMforCPU/uart_inst/uart_ctl/dout_rx[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {UMforCPU/uart_inst/uart_ctl/dout_tx[0]} {UMforCPU/uart_inst/uart_ctl/dout_tx[1]} {UMforCPU/uart_inst/uart_ctl/dout_tx[2]} {UMforCPU/uart_inst/uart_ctl/dout_tx[3]} {UMforCPU/uart_inst/uart_ctl/dout_tx[4]} {UMforCPU/uart_inst/uart_ctl/dout_tx[5]} {UMforCPU/uart_inst/uart_ctl/dout_tx[6]} {UMforCPU/uart_inst/uart_ctl/dout_tx[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {UMforCPU/peri_rdata[0]} {UMforCPU/peri_rdata[1]} {UMforCPU/peri_rdata[2]} {UMforCPU/peri_rdata[3]} {UMforCPU/peri_rdata[4]} {UMforCPU/peri_rdata[5]} {UMforCPU/peri_rdata[6]} {UMforCPU/peri_rdata[7]} {UMforCPU/peri_rdata[8]} {UMforCPU/peri_rdata[9]} {UMforCPU/peri_rdata[10]} {UMforCPU/peri_rdata[11]} {UMforCPU/peri_rdata[12]} {UMforCPU/peri_rdata[13]} {UMforCPU/peri_rdata[14]} {UMforCPU/peri_rdata[15]} {UMforCPU/peri_rdata[16]} {UMforCPU/peri_rdata[17]} {UMforCPU/peri_rdata[18]} {UMforCPU/peri_rdata[19]} {UMforCPU/peri_rdata[20]} {UMforCPU/peri_rdata[21]} {UMforCPU/peri_rdata[22]} {UMforCPU/peri_rdata[23]} {UMforCPU/peri_rdata[24]} {UMforCPU/peri_rdata[25]} {UMforCPU/peri_rdata[26]} {UMforCPU/peri_rdata[27]} {UMforCPU/peri_rdata[28]} {UMforCPU/peri_rdata[29]} {UMforCPU/peri_rdata[30]} {UMforCPU/peri_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 134 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {pktData_um[0]} {pktData_um[1]} {pktData_um[2]} {pktData_um[3]} {pktData_um[4]} {pktData_um[5]} {pktData_um[6]} {pktData_um[7]} {pktData_um[8]} {pktData_um[9]} {pktData_um[10]} {pktData_um[11]} {pktData_um[12]} {pktData_um[13]} {pktData_um[14]} {pktData_um[15]} {pktData_um[16]} {pktData_um[17]} {pktData_um[18]} {pktData_um[19]} {pktData_um[20]} {pktData_um[21]} {pktData_um[22]} {pktData_um[23]} {pktData_um[24]} {pktData_um[25]} {pktData_um[26]} {pktData_um[27]} {pktData_um[28]} {pktData_um[29]} {pktData_um[30]} {pktData_um[31]} {pktData_um[32]} {pktData_um[33]} {pktData_um[34]} {pktData_um[35]} {pktData_um[36]} {pktData_um[37]} {pktData_um[38]} {pktData_um[39]} {pktData_um[40]} {pktData_um[41]} {pktData_um[42]} {pktData_um[43]} {pktData_um[44]} {pktData_um[45]} {pktData_um[46]} {pktData_um[47]} {pktData_um[48]} {pktData_um[49]} {pktData_um[50]} {pktData_um[51]} {pktData_um[52]} {pktData_um[53]} {pktData_um[54]} {pktData_um[55]} {pktData_um[56]} {pktData_um[57]} {pktData_um[58]} {pktData_um[59]} {pktData_um[60]} {pktData_um[61]} {pktData_um[62]} {pktData_um[63]} {pktData_um[64]} {pktData_um[65]} {pktData_um[66]} {pktData_um[67]} {pktData_um[68]} {pktData_um[69]} {pktData_um[70]} {pktData_um[71]} {pktData_um[72]} {pktData_um[73]} {pktData_um[74]} {pktData_um[75]} {pktData_um[76]} {pktData_um[77]} {pktData_um[78]} {pktData_um[79]} {pktData_um[80]} {pktData_um[81]} {pktData_um[82]} {pktData_um[83]} {pktData_um[84]} {pktData_um[85]} {pktData_um[86]} {pktData_um[87]} {pktData_um[88]} {pktData_um[89]} {pktData_um[90]} {pktData_um[91]} {pktData_um[92]} {pktData_um[93]} {pktData_um[94]} {pktData_um[95]} {pktData_um[96]} {pktData_um[97]} {pktData_um[98]} {pktData_um[99]} {pktData_um[100]} {pktData_um[101]} {pktData_um[102]} {pktData_um[103]} {pktData_um[104]} {pktData_um[105]} {pktData_um[106]} {pktData_um[107]} {pktData_um[108]} {pktData_um[109]} {pktData_um[110]} {pktData_um[111]} {pktData_um[112]} {pktData_um[113]} {pktData_um[114]} {pktData_um[115]} {pktData_um[116]} {pktData_um[117]} {pktData_um[118]} {pktData_um[119]} {pktData_um[120]} {pktData_um[121]} {pktData_um[122]} {pktData_um[123]} {pktData_um[124]} {pktData_um[125]} {pktData_um[126]} {pktData_um[127]} {pktData_um[128]} {pktData_um[129]} {pktData_um[130]} {pktData_um[131]} {pktData_um[132]} {pktData_um[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {UMforCPU/uart_inst/uart_dataTx[0]} {UMforCPU/uart_inst/uart_dataTx[1]} {UMforCPU/uart_inst/uart_dataTx[2]} {UMforCPU/uart_inst/uart_dataTx[3]} {UMforCPU/uart_inst/uart_dataTx[4]} {UMforCPU/uart_inst/uart_dataTx[5]} {UMforCPU/uart_inst/uart_dataTx[6]} {UMforCPU/uart_inst/uart_dataTx[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {UMforCPU/peri_wdata[0]} {UMforCPU/peri_wdata[1]} {UMforCPU/peri_wdata[2]} {UMforCPU/peri_wdata[3]} {UMforCPU/peri_wdata[4]} {UMforCPU/peri_wdata[5]} {UMforCPU/peri_wdata[6]} {UMforCPU/peri_wdata[7]} {UMforCPU/peri_wdata[8]} {UMforCPU/peri_wdata[9]} {UMforCPU/peri_wdata[10]} {UMforCPU/peri_wdata[11]} {UMforCPU/peri_wdata[12]} {UMforCPU/peri_wdata[13]} {UMforCPU/peri_wdata[14]} {UMforCPU/peri_wdata[15]} {UMforCPU/peri_wdata[16]} {UMforCPU/peri_wdata[17]} {UMforCPU/peri_wdata[18]} {UMforCPU/peri_wdata[19]} {UMforCPU/peri_wdata[20]} {UMforCPU/peri_wdata[21]} {UMforCPU/peri_wdata[22]} {UMforCPU/peri_wdata[23]} {UMforCPU/peri_wdata[24]} {UMforCPU/peri_wdata[25]} {UMforCPU/peri_wdata[26]} {UMforCPU/peri_wdata[27]} {UMforCPU/peri_wdata[28]} {UMforCPU/peri_wdata[29]} {UMforCPU/peri_wdata[30]} {UMforCPU/peri_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 134 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {pktData_gmii[0]} {pktData_gmii[1]} {pktData_gmii[2]} {pktData_gmii[3]} {pktData_gmii[4]} {pktData_gmii[5]} {pktData_gmii[6]} {pktData_gmii[7]} {pktData_gmii[8]} {pktData_gmii[9]} {pktData_gmii[10]} {pktData_gmii[11]} {pktData_gmii[12]} {pktData_gmii[13]} {pktData_gmii[14]} {pktData_gmii[15]} {pktData_gmii[16]} {pktData_gmii[17]} {pktData_gmii[18]} {pktData_gmii[19]} {pktData_gmii[20]} {pktData_gmii[21]} {pktData_gmii[22]} {pktData_gmii[23]} {pktData_gmii[24]} {pktData_gmii[25]} {pktData_gmii[26]} {pktData_gmii[27]} {pktData_gmii[28]} {pktData_gmii[29]} {pktData_gmii[30]} {pktData_gmii[31]} {pktData_gmii[32]} {pktData_gmii[33]} {pktData_gmii[34]} {pktData_gmii[35]} {pktData_gmii[36]} {pktData_gmii[37]} {pktData_gmii[38]} {pktData_gmii[39]} {pktData_gmii[40]} {pktData_gmii[41]} {pktData_gmii[42]} {pktData_gmii[43]} {pktData_gmii[44]} {pktData_gmii[45]} {pktData_gmii[46]} {pktData_gmii[47]} {pktData_gmii[48]} {pktData_gmii[49]} {pktData_gmii[50]} {pktData_gmii[51]} {pktData_gmii[52]} {pktData_gmii[53]} {pktData_gmii[54]} {pktData_gmii[55]} {pktData_gmii[56]} {pktData_gmii[57]} {pktData_gmii[58]} {pktData_gmii[59]} {pktData_gmii[60]} {pktData_gmii[61]} {pktData_gmii[62]} {pktData_gmii[63]} {pktData_gmii[64]} {pktData_gmii[65]} {pktData_gmii[66]} {pktData_gmii[67]} {pktData_gmii[68]} {pktData_gmii[69]} {pktData_gmii[70]} {pktData_gmii[71]} {pktData_gmii[72]} {pktData_gmii[73]} {pktData_gmii[74]} {pktData_gmii[75]} {pktData_gmii[76]} {pktData_gmii[77]} {pktData_gmii[78]} {pktData_gmii[79]} {pktData_gmii[80]} {pktData_gmii[81]} {pktData_gmii[82]} {pktData_gmii[83]} {pktData_gmii[84]} {pktData_gmii[85]} {pktData_gmii[86]} {pktData_gmii[87]} {pktData_gmii[88]} {pktData_gmii[89]} {pktData_gmii[90]} {pktData_gmii[91]} {pktData_gmii[92]} {pktData_gmii[93]} {pktData_gmii[94]} {pktData_gmii[95]} {pktData_gmii[96]} {pktData_gmii[97]} {pktData_gmii[98]} {pktData_gmii[99]} {pktData_gmii[100]} {pktData_gmii[101]} {pktData_gmii[102]} {pktData_gmii[103]} {pktData_gmii[104]} {pktData_gmii[105]} {pktData_gmii[106]} {pktData_gmii[107]} {pktData_gmii[108]} {pktData_gmii[109]} {pktData_gmii[110]} {pktData_gmii[111]} {pktData_gmii[112]} {pktData_gmii[113]} {pktData_gmii[114]} {pktData_gmii[115]} {pktData_gmii[116]} {pktData_gmii[117]} {pktData_gmii[118]} {pktData_gmii[119]} {pktData_gmii[120]} {pktData_gmii[121]} {pktData_gmii[122]} {pktData_gmii[123]} {pktData_gmii[124]} {pktData_gmii[125]} {pktData_gmii[126]} {pktData_gmii[127]} {pktData_gmii[128]} {pktData_gmii[129]} {pktData_gmii[130]} {pktData_gmii[131]} {pktData_gmii[132]} {pktData_gmii[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {UMforCPU/uart_inst/uart_dataRx[0]} {UMforCPU/uart_inst/uart_dataRx[1]} {UMforCPU/uart_inst/uart_dataRx[2]} {UMforCPU/uart_inst/uart_dataRx[3]} {UMforCPU/uart_inst/uart_dataRx[4]} {UMforCPU/uart_inst/uart_dataRx[5]} {UMforCPU/uart_inst/uart_dataRx[6]} {UMforCPU/uart_inst/uart_dataRx[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 134 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {runtime/pkt2gmii/dout_pkt[0]} {runtime/pkt2gmii/dout_pkt[1]} {runtime/pkt2gmii/dout_pkt[2]} {runtime/pkt2gmii/dout_pkt[3]} {runtime/pkt2gmii/dout_pkt[4]} {runtime/pkt2gmii/dout_pkt[5]} {runtime/pkt2gmii/dout_pkt[6]} {runtime/pkt2gmii/dout_pkt[7]} {runtime/pkt2gmii/dout_pkt[8]} {runtime/pkt2gmii/dout_pkt[9]} {runtime/pkt2gmii/dout_pkt[10]} {runtime/pkt2gmii/dout_pkt[11]} {runtime/pkt2gmii/dout_pkt[12]} {runtime/pkt2gmii/dout_pkt[13]} {runtime/pkt2gmii/dout_pkt[14]} {runtime/pkt2gmii/dout_pkt[15]} {runtime/pkt2gmii/dout_pkt[16]} {runtime/pkt2gmii/dout_pkt[17]} {runtime/pkt2gmii/dout_pkt[18]} {runtime/pkt2gmii/dout_pkt[19]} {runtime/pkt2gmii/dout_pkt[20]} {runtime/pkt2gmii/dout_pkt[21]} {runtime/pkt2gmii/dout_pkt[22]} {runtime/pkt2gmii/dout_pkt[23]} {runtime/pkt2gmii/dout_pkt[24]} {runtime/pkt2gmii/dout_pkt[25]} {runtime/pkt2gmii/dout_pkt[26]} {runtime/pkt2gmii/dout_pkt[27]} {runtime/pkt2gmii/dout_pkt[28]} {runtime/pkt2gmii/dout_pkt[29]} {runtime/pkt2gmii/dout_pkt[30]} {runtime/pkt2gmii/dout_pkt[31]} {runtime/pkt2gmii/dout_pkt[32]} {runtime/pkt2gmii/dout_pkt[33]} {runtime/pkt2gmii/dout_pkt[34]} {runtime/pkt2gmii/dout_pkt[35]} {runtime/pkt2gmii/dout_pkt[36]} {runtime/pkt2gmii/dout_pkt[37]} {runtime/pkt2gmii/dout_pkt[38]} {runtime/pkt2gmii/dout_pkt[39]} {runtime/pkt2gmii/dout_pkt[40]} {runtime/pkt2gmii/dout_pkt[41]} {runtime/pkt2gmii/dout_pkt[42]} {runtime/pkt2gmii/dout_pkt[43]} {runtime/pkt2gmii/dout_pkt[44]} {runtime/pkt2gmii/dout_pkt[45]} {runtime/pkt2gmii/dout_pkt[46]} {runtime/pkt2gmii/dout_pkt[47]} {runtime/pkt2gmii/dout_pkt[48]} {runtime/pkt2gmii/dout_pkt[49]} {runtime/pkt2gmii/dout_pkt[50]} {runtime/pkt2gmii/dout_pkt[51]} {runtime/pkt2gmii/dout_pkt[52]} {runtime/pkt2gmii/dout_pkt[53]} {runtime/pkt2gmii/dout_pkt[54]} {runtime/pkt2gmii/dout_pkt[55]} {runtime/pkt2gmii/dout_pkt[56]} {runtime/pkt2gmii/dout_pkt[57]} {runtime/pkt2gmii/dout_pkt[58]} {runtime/pkt2gmii/dout_pkt[59]} {runtime/pkt2gmii/dout_pkt[60]} {runtime/pkt2gmii/dout_pkt[61]} {runtime/pkt2gmii/dout_pkt[62]} {runtime/pkt2gmii/dout_pkt[63]} {runtime/pkt2gmii/dout_pkt[64]} {runtime/pkt2gmii/dout_pkt[65]} {runtime/pkt2gmii/dout_pkt[66]} {runtime/pkt2gmii/dout_pkt[67]} {runtime/pkt2gmii/dout_pkt[68]} {runtime/pkt2gmii/dout_pkt[69]} {runtime/pkt2gmii/dout_pkt[70]} {runtime/pkt2gmii/dout_pkt[71]} {runtime/pkt2gmii/dout_pkt[72]} {runtime/pkt2gmii/dout_pkt[73]} {runtime/pkt2gmii/dout_pkt[74]} {runtime/pkt2gmii/dout_pkt[75]} {runtime/pkt2gmii/dout_pkt[76]} {runtime/pkt2gmii/dout_pkt[77]} {runtime/pkt2gmii/dout_pkt[78]} {runtime/pkt2gmii/dout_pkt[79]} {runtime/pkt2gmii/dout_pkt[80]} {runtime/pkt2gmii/dout_pkt[81]} {runtime/pkt2gmii/dout_pkt[82]} {runtime/pkt2gmii/dout_pkt[83]} {runtime/pkt2gmii/dout_pkt[84]} {runtime/pkt2gmii/dout_pkt[85]} {runtime/pkt2gmii/dout_pkt[86]} {runtime/pkt2gmii/dout_pkt[87]} {runtime/pkt2gmii/dout_pkt[88]} {runtime/pkt2gmii/dout_pkt[89]} {runtime/pkt2gmii/dout_pkt[90]} {runtime/pkt2gmii/dout_pkt[91]} {runtime/pkt2gmii/dout_pkt[92]} {runtime/pkt2gmii/dout_pkt[93]} {runtime/pkt2gmii/dout_pkt[94]} {runtime/pkt2gmii/dout_pkt[95]} {runtime/pkt2gmii/dout_pkt[96]} {runtime/pkt2gmii/dout_pkt[97]} {runtime/pkt2gmii/dout_pkt[98]} {runtime/pkt2gmii/dout_pkt[99]} {runtime/pkt2gmii/dout_pkt[100]} {runtime/pkt2gmii/dout_pkt[101]} {runtime/pkt2gmii/dout_pkt[102]} {runtime/pkt2gmii/dout_pkt[103]} {runtime/pkt2gmii/dout_pkt[104]} {runtime/pkt2gmii/dout_pkt[105]} {runtime/pkt2gmii/dout_pkt[106]} {runtime/pkt2gmii/dout_pkt[107]} {runtime/pkt2gmii/dout_pkt[108]} {runtime/pkt2gmii/dout_pkt[109]} {runtime/pkt2gmii/dout_pkt[110]} {runtime/pkt2gmii/dout_pkt[111]} {runtime/pkt2gmii/dout_pkt[112]} {runtime/pkt2gmii/dout_pkt[113]} {runtime/pkt2gmii/dout_pkt[114]} {runtime/pkt2gmii/dout_pkt[115]} {runtime/pkt2gmii/dout_pkt[116]} {runtime/pkt2gmii/dout_pkt[117]} {runtime/pkt2gmii/dout_pkt[118]} {runtime/pkt2gmii/dout_pkt[119]} {runtime/pkt2gmii/dout_pkt[120]} {runtime/pkt2gmii/dout_pkt[121]} {runtime/pkt2gmii/dout_pkt[122]} {runtime/pkt2gmii/dout_pkt[123]} {runtime/pkt2gmii/dout_pkt[124]} {runtime/pkt2gmii/dout_pkt[125]} {runtime/pkt2gmii/dout_pkt[126]} {runtime/pkt2gmii/dout_pkt[127]} {runtime/pkt2gmii/dout_pkt[128]} {runtime/pkt2gmii/dout_pkt[129]} {runtime/pkt2gmii/dout_pkt[130]} {runtime/pkt2gmii/dout_pkt[131]} {runtime/pkt2gmii/dout_pkt[132]} {runtime/pkt2gmii/dout_pkt[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {runtime/cntPkt_asynRecvPkt[0]} {runtime/cntPkt_asynRecvPkt[1]} {runtime/cntPkt_asynRecvPkt[2]} {runtime/cntPkt_asynRecvPkt[3]} {runtime/cntPkt_asynRecvPkt[4]} {runtime/cntPkt_asynRecvPkt[5]} {runtime/cntPkt_asynRecvPkt[6]} {runtime/cntPkt_asynRecvPkt[7]} {runtime/cntPkt_asynRecvPkt[8]} {runtime/cntPkt_asynRecvPkt[9]} {runtime/cntPkt_asynRecvPkt[10]} {runtime/cntPkt_asynRecvPkt[11]} {runtime/cntPkt_asynRecvPkt[12]} {runtime/cntPkt_asynRecvPkt[13]} {runtime/cntPkt_asynRecvPkt[14]} {runtime/cntPkt_asynRecvPkt[15]} {runtime/cntPkt_asynRecvPkt[16]} {runtime/cntPkt_asynRecvPkt[17]} {runtime/cntPkt_asynRecvPkt[18]} {runtime/cntPkt_asynRecvPkt[19]} {runtime/cntPkt_asynRecvPkt[20]} {runtime/cntPkt_asynRecvPkt[21]} {runtime/cntPkt_asynRecvPkt[22]} {runtime/cntPkt_asynRecvPkt[23]} {runtime/cntPkt_asynRecvPkt[24]} {runtime/cntPkt_asynRecvPkt[25]} {runtime/cntPkt_asynRecvPkt[26]} {runtime/cntPkt_asynRecvPkt[27]} {runtime/cntPkt_asynRecvPkt[28]} {runtime/cntPkt_asynRecvPkt[29]} {runtime/cntPkt_asynRecvPkt[30]} {runtime/cntPkt_asynRecvPkt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 32 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {runtime/cntPkt_pkt2gmii[0]} {runtime/cntPkt_pkt2gmii[1]} {runtime/cntPkt_pkt2gmii[2]} {runtime/cntPkt_pkt2gmii[3]} {runtime/cntPkt_pkt2gmii[4]} {runtime/cntPkt_pkt2gmii[5]} {runtime/cntPkt_pkt2gmii[6]} {runtime/cntPkt_pkt2gmii[7]} {runtime/cntPkt_pkt2gmii[8]} {runtime/cntPkt_pkt2gmii[9]} {runtime/cntPkt_pkt2gmii[10]} {runtime/cntPkt_pkt2gmii[11]} {runtime/cntPkt_pkt2gmii[12]} {runtime/cntPkt_pkt2gmii[13]} {runtime/cntPkt_pkt2gmii[14]} {runtime/cntPkt_pkt2gmii[15]} {runtime/cntPkt_pkt2gmii[16]} {runtime/cntPkt_pkt2gmii[17]} {runtime/cntPkt_pkt2gmii[18]} {runtime/cntPkt_pkt2gmii[19]} {runtime/cntPkt_pkt2gmii[20]} {runtime/cntPkt_pkt2gmii[21]} {runtime/cntPkt_pkt2gmii[22]} {runtime/cntPkt_pkt2gmii[23]} {runtime/cntPkt_pkt2gmii[24]} {runtime/cntPkt_pkt2gmii[25]} {runtime/cntPkt_pkt2gmii[26]} {runtime/cntPkt_pkt2gmii[27]} {runtime/cntPkt_pkt2gmii[28]} {runtime/cntPkt_pkt2gmii[29]} {runtime/cntPkt_pkt2gmii[30]} {runtime/cntPkt_pkt2gmii[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 2 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {runtime/pkt2gmii/head_tag[0]} {runtime/pkt2gmii/head_tag[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 32 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {runtime/cntPkt_gmii2pkt[0]} {runtime/cntPkt_gmii2pkt[1]} {runtime/cntPkt_gmii2pkt[2]} {runtime/cntPkt_gmii2pkt[3]} {runtime/cntPkt_gmii2pkt[4]} {runtime/cntPkt_gmii2pkt[5]} {runtime/cntPkt_gmii2pkt[6]} {runtime/cntPkt_gmii2pkt[7]} {runtime/cntPkt_gmii2pkt[8]} {runtime/cntPkt_gmii2pkt[9]} {runtime/cntPkt_gmii2pkt[10]} {runtime/cntPkt_gmii2pkt[11]} {runtime/cntPkt_gmii2pkt[12]} {runtime/cntPkt_gmii2pkt[13]} {runtime/cntPkt_gmii2pkt[14]} {runtime/cntPkt_gmii2pkt[15]} {runtime/cntPkt_gmii2pkt[16]} {runtime/cntPkt_gmii2pkt[17]} {runtime/cntPkt_gmii2pkt[18]} {runtime/cntPkt_gmii2pkt[19]} {runtime/cntPkt_gmii2pkt[20]} {runtime/cntPkt_gmii2pkt[21]} {runtime/cntPkt_gmii2pkt[22]} {runtime/cntPkt_gmii2pkt[23]} {runtime/cntPkt_gmii2pkt[24]} {runtime/cntPkt_gmii2pkt[25]} {runtime/cntPkt_gmii2pkt[26]} {runtime/cntPkt_gmii2pkt[27]} {runtime/cntPkt_gmii2pkt[28]} {runtime/cntPkt_gmii2pkt[29]} {runtime/cntPkt_gmii2pkt[30]} {runtime/cntPkt_gmii2pkt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {runtime/cnt_calcCRC[0]} {runtime/cnt_calcCRC[1]} {runtime/cnt_calcCRC[2]} {runtime/cnt_calcCRC[3]} {runtime/cnt_calcCRC[4]} {runtime/cnt_calcCRC[5]} {runtime/cnt_calcCRC[6]} {runtime/cnt_calcCRC[7]} {runtime/cnt_calcCRC[8]} {runtime/cnt_calcCRC[9]} {runtime/cnt_calcCRC[10]} {runtime/cnt_calcCRC[11]} {runtime/cnt_calcCRC[12]} {runtime/cnt_calcCRC[13]} {runtime/cnt_calcCRC[14]} {runtime/cnt_calcCRC[15]} {runtime/cnt_calcCRC[16]} {runtime/cnt_calcCRC[17]} {runtime/cnt_calcCRC[18]} {runtime/cnt_calcCRC[19]} {runtime/cnt_calcCRC[20]} {runtime/cnt_calcCRC[21]} {runtime/cnt_calcCRC[22]} {runtime/cnt_calcCRC[23]} {runtime/cnt_calcCRC[24]} {runtime/cnt_calcCRC[25]} {runtime/cnt_calcCRC[26]} {runtime/cnt_calcCRC[27]} {runtime/cnt_calcCRC[28]} {runtime/cnt_calcCRC[29]} {runtime/cnt_calcCRC[30]} {runtime/cnt_calcCRC[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 4 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {runtime/pkt2gmii/state_div[0]} {runtime/pkt2gmii/state_div[1]} {runtime/pkt2gmii/state_div[2]} {runtime/pkt2gmii/state_div[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 16 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {UMforCPU/bus/peri_addr_test[0]} {UMforCPU/bus/peri_addr_test[1]} {UMforCPU/bus/peri_addr_test[2]} {UMforCPU/bus/peri_addr_test[3]} {UMforCPU/bus/peri_addr_test[4]} {UMforCPU/bus/peri_addr_test[5]} {UMforCPU/bus/peri_addr_test[6]} {UMforCPU/bus/peri_addr_test[7]} {UMforCPU/bus/peri_addr_test[8]} {UMforCPU/bus/peri_addr_test[9]} {UMforCPU/bus/peri_addr_test[10]} {UMforCPU/bus/peri_addr_test[11]} {UMforCPU/bus/peri_addr_test[12]} {UMforCPU/bus/peri_addr_test[13]} {UMforCPU/bus/peri_addr_test[14]} {UMforCPU/bus/peri_addr_test[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {UMforCPU/bus/rden_o[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {UMforCPU/bus/wren_o[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {UMforCPU/bus/dout_32b_valid_i[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list UMforCPU/uart_inst/dout_32b_valid_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list runtime/pkt2gmii/empty_pkt]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list UMforCPU/uart_inst/uart_ctl/empty_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list UMforCPU/uart_inst/uart_ctl/empty_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list UMforCPU/timelyRV_top/mem_instr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list UMforCPU/timelyRV_top/mem_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list UMforCPU/timelyRV_top/mem_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list UMforCPU/timelyRV_top/mem_ready_mem]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list UMforCPU/timelyRV_top/mem_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list UMforCPU/timelyRV_top/mem_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list UMforCPU/peri_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list UMforCPU/peri_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list UMforCPU/peri_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list pktData_valid_gmii]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list pktData_valid_um]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list runtime/pkt2gmii/rden_pkt]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list UMforCPU/uart_inst/uart_ctl/rden_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list UMforCPU/uart_inst/uart_ctl/rden_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list UMforCPU/uart_inst/rxclk_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list UMforCPU/timelyRV_top/trap]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list UMforCPU/uart_inst/txclk_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list UMforCPU/uart_inst/uart_dataRx_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list UMforCPU/uart_inst/uart_dataTx_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list UMforCPU/uart_inst/uart_tx_busy_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list UMforCPU/uart_inst/uart_ctl/wren_tx]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_125m]
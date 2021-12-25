########################################################
#port 0
set_property PACKAGE_PIN E19 [get_ports {rgmii_td[0]}]
set_property PACKAGE_PIN D19 [get_ports {rgmii_td[1]}]
set_property PACKAGE_PIN E17 [get_ports {rgmii_td[2]}]
set_property PACKAGE_PIN E18 [get_ports {rgmii_td[3]}]
set_property PACKAGE_PIN E16 [get_ports mdio_mdc]
set_property PACKAGE_PIN G14 [get_ports mdio_mdio_io]
#set_property PACKAGE_PIN L19 [get_ports phy_reset_n]
set_property PACKAGE_PIN G22 [get_ports rgmii_rxc]
set_property PACKAGE_PIN D22 [get_ports rgmii_rx_ctl]
set_property PACKAGE_PIN E22 [get_ports {rgmii_rd[0]}]
set_property PACKAGE_PIN F21 [get_ports {rgmii_rd[1]}]
set_property PACKAGE_PIN F22 [get_ports {rgmii_rd[2]}]
set_property PACKAGE_PIN G21 [get_ports {rgmii_rd[3]}]
set_property PACKAGE_PIN F19 [get_ports rgmii_txc]
set_property PACKAGE_PIN F20 [get_ports rgmii_tx_ctl]

set_property IOSTANDARD LVCMOS33 [get_ports mdio_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports mdio_mdio_io]
#set_property IOSTANDARD LVCMOS33 [get_ports phy_reset_n]
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
#set_property SLEW SLOW [get_ports phy_reset_n]


############## clock and reset define##################
set_property PACKAGE_PIN AB2 [get_ports rst_n]
set_property PACKAGE_PIN P15 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property UNAVAILABLE_DURING_CALIBRATION true [get_ports mdio_mdio_io]

create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]
create_clock -period 8.000 -name RGMII_RXC_0 -waveform {0.000 4.000} [get_ports rgmii_rxc]
create_clock -period 8.000 -name RGMII_TXC_0 -waveform {0.000 4.000} [get_ports rgmii_txc]

#set_input_delay -clock RGMII_RXC_0 -min -add_delay -1.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
#set_input_delay -clock RGMII_RXC_0 -max -add_delay -0.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
#set_input_delay -clock RGMII_RXC_0 -clock_fall -min -add_delay -1.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
#set_input_delay -clock RGMII_RXC_0 -clock_fall -max -add_delay -0.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]

#set_output_delay -clock RGMII_TXC_0 -min -add_delay -0.500 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
#set_output_delay -clock RGMII_TXC_0 -max -add_delay 1.000 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
#set_output_delay -clock RGMII_TXC_0 -clock_fall -min -add_delay -0.500 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
#set_output_delay -clock RGMII_TXC_0 -clock_fall -max -add_delay 1.000 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]



############## usb uart define########################
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property PACKAGE_PIN B16 [get_ports uart_rx]

set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property PACKAGE_PIN D11 [get_ports uart_tx]



set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rgmii_rxc_IBUF]

connect_debug_port u_ila_0/probe2 [get_nets [list {UMforCPU/picoTop/picorv32/cpu_state[0]} {UMforCPU/picoTop/picorv32/cpu_state[1]} {UMforCPU/picoTop/picorv32/cpu_state[2]} {UMforCPU/picoTop/picorv32/cpu_state[3]} {UMforCPU/picoTop/picorv32/cpu_state[4]} {UMforCPU/picoTop/picorv32/cpu_state[5]} {UMforCPU/picoTop/picorv32/cpu_state[6]} {UMforCPU/picoTop/picorv32/cpu_state[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/picoTop/mem_rdata[0]} {UMforCPU/picoTop/mem_rdata[1]} {UMforCPU/picoTop/mem_rdata[2]} {UMforCPU/picoTop/mem_rdata[3]} {UMforCPU/picoTop/mem_rdata[4]} {UMforCPU/picoTop/mem_rdata[5]} {UMforCPU/picoTop/mem_rdata[6]} {UMforCPU/picoTop/mem_rdata[7]} {UMforCPU/picoTop/mem_rdata[8]} {UMforCPU/picoTop/mem_rdata[9]} {UMforCPU/picoTop/mem_rdata[10]} {UMforCPU/picoTop/mem_rdata[11]} {UMforCPU/picoTop/mem_rdata[12]} {UMforCPU/picoTop/mem_rdata[13]} {UMforCPU/picoTop/mem_rdata[14]} {UMforCPU/picoTop/mem_rdata[15]} {UMforCPU/picoTop/mem_rdata[16]} {UMforCPU/picoTop/mem_rdata[17]} {UMforCPU/picoTop/mem_rdata[18]} {UMforCPU/picoTop/mem_rdata[19]} {UMforCPU/picoTop/mem_rdata[20]} {UMforCPU/picoTop/mem_rdata[21]} {UMforCPU/picoTop/mem_rdata[22]} {UMforCPU/picoTop/mem_rdata[23]} {UMforCPU/picoTop/mem_rdata[24]} {UMforCPU/picoTop/mem_rdata[25]} {UMforCPU/picoTop/mem_rdata[26]} {UMforCPU/picoTop/mem_rdata[27]} {UMforCPU/picoTop/mem_rdata[28]} {UMforCPU/picoTop/mem_rdata[29]} {UMforCPU/picoTop/mem_rdata[30]} {UMforCPU/picoTop/mem_rdata[31]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/picoTop/mem_wdata[0]} {UMforCPU/picoTop/mem_wdata[1]} {UMforCPU/picoTop/mem_wdata[2]} {UMforCPU/picoTop/mem_wdata[3]} {UMforCPU/picoTop/mem_wdata[4]} {UMforCPU/picoTop/mem_wdata[5]} {UMforCPU/picoTop/mem_wdata[6]} {UMforCPU/picoTop/mem_wdata[7]} {UMforCPU/picoTop/mem_wdata[8]} {UMforCPU/picoTop/mem_wdata[9]} {UMforCPU/picoTop/mem_wdata[10]} {UMforCPU/picoTop/mem_wdata[11]} {UMforCPU/picoTop/mem_wdata[12]} {UMforCPU/picoTop/mem_wdata[13]} {UMforCPU/picoTop/mem_wdata[14]} {UMforCPU/picoTop/mem_wdata[15]} {UMforCPU/picoTop/mem_wdata[16]} {UMforCPU/picoTop/mem_wdata[17]} {UMforCPU/picoTop/mem_wdata[18]} {UMforCPU/picoTop/mem_wdata[19]} {UMforCPU/picoTop/mem_wdata[20]} {UMforCPU/picoTop/mem_wdata[21]} {UMforCPU/picoTop/mem_wdata[22]} {UMforCPU/picoTop/mem_wdata[23]} {UMforCPU/picoTop/mem_wdata[24]} {UMforCPU/picoTop/mem_wdata[25]} {UMforCPU/picoTop/mem_wdata[26]} {UMforCPU/picoTop/mem_wdata[27]} {UMforCPU/picoTop/mem_wdata[28]} {UMforCPU/picoTop/mem_wdata[29]} {UMforCPU/picoTop/mem_wdata[30]} {UMforCPU/picoTop/mem_wdata[31]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/picoTop/mem_wstrb[0]} {UMforCPU/picoTop/mem_wstrb[1]} {UMforCPU/picoTop/mem_wstrb[2]} {UMforCPU/picoTop/mem_wstrb[3]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/picoTop/mem_addr[0]} {UMforCPU/picoTop/mem_addr[1]} {UMforCPU/picoTop/mem_addr[2]} {UMforCPU/picoTop/mem_addr[3]} {UMforCPU/picoTop/mem_addr[4]} {UMforCPU/picoTop/mem_addr[5]} {UMforCPU/picoTop/mem_addr[6]} {UMforCPU/picoTop/mem_addr[7]} {UMforCPU/picoTop/mem_addr[8]} {UMforCPU/picoTop/mem_addr[9]} {UMforCPU/picoTop/mem_addr[10]} {UMforCPU/picoTop/mem_addr[11]} {UMforCPU/picoTop/mem_addr[12]} {UMforCPU/picoTop/mem_addr[13]} {UMforCPU/picoTop/mem_addr[14]} {UMforCPU/picoTop/mem_addr[15]} {UMforCPU/picoTop/mem_addr[16]} {UMforCPU/picoTop/mem_addr[17]} {UMforCPU/picoTop/mem_addr[18]} {UMforCPU/picoTop/mem_addr[19]} {UMforCPU/picoTop/mem_addr[20]} {UMforCPU/picoTop/mem_addr[21]} {UMforCPU/picoTop/mem_addr[22]} {UMforCPU/picoTop/mem_addr[23]} {UMforCPU/picoTop/mem_addr[24]} {UMforCPU/picoTop/mem_addr[25]} {UMforCPU/picoTop/mem_addr[26]} {UMforCPU/picoTop/mem_addr[27]} {UMforCPU/picoTop/mem_addr[28]} {UMforCPU/picoTop/mem_addr[29]} {UMforCPU/picoTop/mem_addr[30]} {UMforCPU/picoTop/mem_addr[31]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {UMforCPU/print_value[0]} {UMforCPU/print_value[1]} {UMforCPU/print_value[2]} {UMforCPU/print_value[3]} {UMforCPU/print_value[4]} {UMforCPU/print_value[5]} {UMforCPU/print_value[6]} {UMforCPU/print_value[7]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list UMforCPU/confMem/conf_sel]]
connect_debug_port u_ila_0/probe11 [get_nets [list UMforCPU/conf_sel]]
connect_debug_port u_ila_0/probe12 [get_nets [list UMforCPU/conf_wren]]
connect_debug_port u_ila_0/probe13 [get_nets [list UMforCPU/picoTop/mem_instr]]
connect_debug_port u_ila_0/probe14 [get_nets [list UMforCPU/picoTop/mem_rden]]
connect_debug_port u_ila_0/probe15 [get_nets [list UMforCPU/picoTop/mem_ready]]
connect_debug_port u_ila_0/probe16 [get_nets [list UMforCPU/picoTop/mem_valid]]
connect_debug_port u_ila_0/probe17 [get_nets [list UMforCPU/picoTop/mem_wren]]
connect_debug_port u_ila_0/probe20 [get_nets [list UMforCPU/print_valid]]

connect_debug_port u_ila_1/clk [get_nets [list rgmii2gmii/gmii_rx_clk]]



connect_debug_port u_ila_0/probe0 [get_nets [list {UMforCPU/picoTop/picorv32/cpu_state[0]} {UMforCPU/picoTop/picorv32/cpu_state[1]} {UMforCPU/picoTop/picorv32/cpu_state[2]} {UMforCPU/picoTop/picorv32/cpu_state[3]} {UMforCPU/picoTop/picorv32/cpu_state[4]} {UMforCPU/picoTop/picorv32/cpu_state[5]} {UMforCPU/picoTop/picorv32/cpu_state[6]} {UMforCPU/picoTop/picorv32/cpu_state[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {UMforCPU/picoTop/mem_rdata[0]} {UMforCPU/picoTop/mem_rdata[1]} {UMforCPU/picoTop/mem_rdata[2]} {UMforCPU/picoTop/mem_rdata[3]} {UMforCPU/picoTop/mem_rdata[4]} {UMforCPU/picoTop/mem_rdata[5]} {UMforCPU/picoTop/mem_rdata[6]} {UMforCPU/picoTop/mem_rdata[7]} {UMforCPU/picoTop/mem_rdata[8]} {UMforCPU/picoTop/mem_rdata[9]} {UMforCPU/picoTop/mem_rdata[10]} {UMforCPU/picoTop/mem_rdata[11]} {UMforCPU/picoTop/mem_rdata[12]} {UMforCPU/picoTop/mem_rdata[13]} {UMforCPU/picoTop/mem_rdata[14]} {UMforCPU/picoTop/mem_rdata[15]} {UMforCPU/picoTop/mem_rdata[16]} {UMforCPU/picoTop/mem_rdata[17]} {UMforCPU/picoTop/mem_rdata[18]} {UMforCPU/picoTop/mem_rdata[19]} {UMforCPU/picoTop/mem_rdata[20]} {UMforCPU/picoTop/mem_rdata[21]} {UMforCPU/picoTop/mem_rdata[22]} {UMforCPU/picoTop/mem_rdata[23]} {UMforCPU/picoTop/mem_rdata[24]} {UMforCPU/picoTop/mem_rdata[25]} {UMforCPU/picoTop/mem_rdata[26]} {UMforCPU/picoTop/mem_rdata[27]} {UMforCPU/picoTop/mem_rdata[28]} {UMforCPU/picoTop/mem_rdata[29]} {UMforCPU/picoTop/mem_rdata[30]} {UMforCPU/picoTop/mem_rdata[31]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {UMforCPU/picoTop/mem_addr[0]} {UMforCPU/picoTop/mem_addr[1]} {UMforCPU/picoTop/mem_addr[2]} {UMforCPU/picoTop/mem_addr[3]} {UMforCPU/picoTop/mem_addr[4]} {UMforCPU/picoTop/mem_addr[5]} {UMforCPU/picoTop/mem_addr[6]} {UMforCPU/picoTop/mem_addr[7]} {UMforCPU/picoTop/mem_addr[8]} {UMforCPU/picoTop/mem_addr[9]} {UMforCPU/picoTop/mem_addr[10]} {UMforCPU/picoTop/mem_addr[11]} {UMforCPU/picoTop/mem_addr[12]} {UMforCPU/picoTop/mem_addr[13]} {UMforCPU/picoTop/mem_addr[14]} {UMforCPU/picoTop/mem_addr[15]} {UMforCPU/picoTop/mem_addr[16]} {UMforCPU/picoTop/mem_addr[17]} {UMforCPU/picoTop/mem_addr[18]} {UMforCPU/picoTop/mem_addr[19]} {UMforCPU/picoTop/mem_addr[20]} {UMforCPU/picoTop/mem_addr[21]} {UMforCPU/picoTop/mem_addr[22]} {UMforCPU/picoTop/mem_addr[23]} {UMforCPU/picoTop/mem_addr[24]} {UMforCPU/picoTop/mem_addr[25]} {UMforCPU/picoTop/mem_addr[26]} {UMforCPU/picoTop/mem_addr[27]} {UMforCPU/picoTop/mem_addr[28]} {UMforCPU/picoTop/mem_addr[29]} {UMforCPU/picoTop/mem_addr[30]} {UMforCPU/picoTop/mem_addr[31]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/picoTop/mem_wdata[0]} {UMforCPU/picoTop/mem_wdata[1]} {UMforCPU/picoTop/mem_wdata[2]} {UMforCPU/picoTop/mem_wdata[3]} {UMforCPU/picoTop/mem_wdata[4]} {UMforCPU/picoTop/mem_wdata[5]} {UMforCPU/picoTop/mem_wdata[6]} {UMforCPU/picoTop/mem_wdata[7]} {UMforCPU/picoTop/mem_wdata[8]} {UMforCPU/picoTop/mem_wdata[9]} {UMforCPU/picoTop/mem_wdata[10]} {UMforCPU/picoTop/mem_wdata[11]} {UMforCPU/picoTop/mem_wdata[12]} {UMforCPU/picoTop/mem_wdata[13]} {UMforCPU/picoTop/mem_wdata[14]} {UMforCPU/picoTop/mem_wdata[15]} {UMforCPU/picoTop/mem_wdata[16]} {UMforCPU/picoTop/mem_wdata[17]} {UMforCPU/picoTop/mem_wdata[18]} {UMforCPU/picoTop/mem_wdata[19]} {UMforCPU/picoTop/mem_wdata[20]} {UMforCPU/picoTop/mem_wdata[21]} {UMforCPU/picoTop/mem_wdata[22]} {UMforCPU/picoTop/mem_wdata[23]} {UMforCPU/picoTop/mem_wdata[24]} {UMforCPU/picoTop/mem_wdata[25]} {UMforCPU/picoTop/mem_wdata[26]} {UMforCPU/picoTop/mem_wdata[27]} {UMforCPU/picoTop/mem_wdata[28]} {UMforCPU/picoTop/mem_wdata[29]} {UMforCPU/picoTop/mem_wdata[30]} {UMforCPU/picoTop/mem_wdata[31]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/picoTop/mem_wstrb[0]} {UMforCPU/picoTop/mem_wstrb[1]} {UMforCPU/picoTop/mem_wstrb[2]} {UMforCPU/picoTop/mem_wstrb[3]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/conf_wdata[0]} {UMforCPU/conf_wdata[1]} {UMforCPU/conf_wdata[2]} {UMforCPU/conf_wdata[3]} {UMforCPU/conf_wdata[4]} {UMforCPU/conf_wdata[5]} {UMforCPU/conf_wdata[6]} {UMforCPU/conf_wdata[7]} {UMforCPU/conf_wdata[8]} {UMforCPU/conf_wdata[9]} {UMforCPU/conf_wdata[10]} {UMforCPU/conf_wdata[11]} {UMforCPU/conf_wdata[12]} {UMforCPU/conf_wdata[13]} {UMforCPU/conf_wdata[14]} {UMforCPU/conf_wdata[15]} {UMforCPU/conf_wdata[16]} {UMforCPU/conf_wdata[17]} {UMforCPU/conf_wdata[18]} {UMforCPU/conf_wdata[19]} {UMforCPU/conf_wdata[20]} {UMforCPU/conf_wdata[21]} {UMforCPU/conf_wdata[22]} {UMforCPU/conf_wdata[23]} {UMforCPU/conf_wdata[24]} {UMforCPU/conf_wdata[25]} {UMforCPU/conf_wdata[26]} {UMforCPU/conf_wdata[27]} {UMforCPU/conf_wdata[28]} {UMforCPU/conf_wdata[29]} {UMforCPU/conf_wdata[30]} {UMforCPU/conf_wdata[31]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/conf_rdata[0]} {UMforCPU/conf_rdata[1]} {UMforCPU/conf_rdata[2]} {UMforCPU/conf_rdata[3]} {UMforCPU/conf_rdata[4]} {UMforCPU/conf_rdata[5]} {UMforCPU/conf_rdata[6]} {UMforCPU/conf_rdata[7]} {UMforCPU/conf_rdata[8]} {UMforCPU/conf_rdata[9]} {UMforCPU/conf_rdata[10]} {UMforCPU/conf_rdata[11]} {UMforCPU/conf_rdata[12]} {UMforCPU/conf_rdata[13]} {UMforCPU/conf_rdata[14]} {UMforCPU/conf_rdata[15]} {UMforCPU/conf_rdata[16]} {UMforCPU/conf_rdata[17]} {UMforCPU/conf_rdata[18]} {UMforCPU/conf_rdata[19]} {UMforCPU/conf_rdata[20]} {UMforCPU/conf_rdata[21]} {UMforCPU/conf_rdata[22]} {UMforCPU/conf_rdata[23]} {UMforCPU/conf_rdata[24]} {UMforCPU/conf_rdata[25]} {UMforCPU/conf_rdata[26]} {UMforCPU/conf_rdata[27]} {UMforCPU/conf_rdata[28]} {UMforCPU/conf_rdata[29]} {UMforCPU/conf_rdata[30]} {UMforCPU/conf_rdata[31]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list {UMforCPU/print_value[0]} {UMforCPU/print_value[1]} {UMforCPU/print_value[2]} {UMforCPU/print_value[3]} {UMforCPU/print_value[4]} {UMforCPU/print_value[5]} {UMforCPU/print_value[6]} {UMforCPU/print_value[7]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {UMforCPU/conf_addr[0]} {UMforCPU/conf_addr[1]} {UMforCPU/conf_addr[2]} {UMforCPU/conf_addr[3]} {UMforCPU/conf_addr[4]} {UMforCPU/conf_addr[5]} {UMforCPU/conf_addr[6]} {UMforCPU/conf_addr[7]} {UMforCPU/conf_addr[8]} {UMforCPU/conf_addr[9]} {UMforCPU/conf_addr[10]} {UMforCPU/conf_addr[11]} {UMforCPU/conf_addr[12]} {UMforCPU/conf_addr[13]} {UMforCPU/conf_addr[14]} {UMforCPU/conf_addr[15]} {UMforCPU/conf_addr[16]} {UMforCPU/conf_addr[17]} {UMforCPU/conf_addr[18]} {UMforCPU/conf_addr[19]} {UMforCPU/conf_addr[20]} {UMforCPU/conf_addr[21]} {UMforCPU/conf_addr[22]} {UMforCPU/conf_addr[23]} {UMforCPU/conf_addr[24]} {UMforCPU/conf_addr[25]} {UMforCPU/conf_addr[26]} {UMforCPU/conf_addr[27]} {UMforCPU/conf_addr[28]} {UMforCPU/conf_addr[29]} {UMforCPU/conf_addr[30]} {UMforCPU/conf_addr[31]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list {UMforCPU/data_out[0]} {UMforCPU/data_out[1]} {UMforCPU/data_out[2]} {UMforCPU/data_out[3]} {UMforCPU/data_out[4]} {UMforCPU/data_out[5]} {UMforCPU/data_out[6]} {UMforCPU/data_out[7]} {UMforCPU/data_out[8]} {UMforCPU/data_out[9]} {UMforCPU/data_out[10]} {UMforCPU/data_out[11]} {UMforCPU/data_out[12]} {UMforCPU/data_out[13]} {UMforCPU/data_out[14]} {UMforCPU/data_out[15]} {UMforCPU/data_out[16]} {UMforCPU/data_out[17]} {UMforCPU/data_out[18]} {UMforCPU/data_out[19]} {UMforCPU/data_out[20]} {UMforCPU/data_out[21]} {UMforCPU/data_out[22]} {UMforCPU/data_out[23]} {UMforCPU/data_out[24]} {UMforCPU/data_out[25]} {UMforCPU/data_out[26]} {UMforCPU/data_out[27]} {UMforCPU/data_out[28]} {UMforCPU/data_out[29]} {UMforCPU/data_out[30]} {UMforCPU/data_out[31]} {UMforCPU/data_out[32]} {UMforCPU/data_out[33]} {UMforCPU/data_out[34]} {UMforCPU/data_out[35]} {UMforCPU/data_out[36]} {UMforCPU/data_out[37]} {UMforCPU/data_out[38]} {UMforCPU/data_out[39]} {UMforCPU/data_out[40]} {UMforCPU/data_out[41]} {UMforCPU/data_out[42]} {UMforCPU/data_out[43]} {UMforCPU/data_out[44]} {UMforCPU/data_out[45]} {UMforCPU/data_out[46]} {UMforCPU/data_out[47]} {UMforCPU/data_out[48]} {UMforCPU/data_out[49]} {UMforCPU/data_out[50]} {UMforCPU/data_out[51]} {UMforCPU/data_out[52]} {UMforCPU/data_out[53]} {UMforCPU/data_out[54]} {UMforCPU/data_out[55]} {UMforCPU/data_out[56]} {UMforCPU/data_out[57]} {UMforCPU/data_out[58]} {UMforCPU/data_out[59]} {UMforCPU/data_out[60]} {UMforCPU/data_out[61]} {UMforCPU/data_out[62]} {UMforCPU/data_out[63]} {UMforCPU/data_out[64]} {UMforCPU/data_out[65]} {UMforCPU/data_out[66]} {UMforCPU/data_out[67]} {UMforCPU/data_out[68]} {UMforCPU/data_out[69]} {UMforCPU/data_out[70]} {UMforCPU/data_out[71]} {UMforCPU/data_out[72]} {UMforCPU/data_out[73]} {UMforCPU/data_out[74]} {UMforCPU/data_out[75]} {UMforCPU/data_out[76]} {UMforCPU/data_out[77]} {UMforCPU/data_out[78]} {UMforCPU/data_out[79]} {UMforCPU/data_out[80]} {UMforCPU/data_out[81]} {UMforCPU/data_out[82]} {UMforCPU/data_out[83]} {UMforCPU/data_out[84]} {UMforCPU/data_out[85]} {UMforCPU/data_out[86]} {UMforCPU/data_out[87]} {UMforCPU/data_out[88]} {UMforCPU/data_out[89]} {UMforCPU/data_out[90]} {UMforCPU/data_out[91]} {UMforCPU/data_out[92]} {UMforCPU/data_out[93]} {UMforCPU/data_out[94]} {UMforCPU/data_out[95]} {UMforCPU/data_out[96]} {UMforCPU/data_out[97]} {UMforCPU/data_out[98]} {UMforCPU/data_out[99]} {UMforCPU/data_out[100]} {UMforCPU/data_out[101]} {UMforCPU/data_out[102]} {UMforCPU/data_out[103]} {UMforCPU/data_out[104]} {UMforCPU/data_out[105]} {UMforCPU/data_out[106]} {UMforCPU/data_out[107]} {UMforCPU/data_out[108]} {UMforCPU/data_out[109]} {UMforCPU/data_out[110]} {UMforCPU/data_out[111]} {UMforCPU/data_out[112]} {UMforCPU/data_out[113]} {UMforCPU/data_out[114]} {UMforCPU/data_out[115]} {UMforCPU/data_out[116]} {UMforCPU/data_out[117]} {UMforCPU/data_out[118]} {UMforCPU/data_out[119]} {UMforCPU/data_out[120]} {UMforCPU/data_out[121]} {UMforCPU/data_out[122]} {UMforCPU/data_out[123]} {UMforCPU/data_out[124]} {UMforCPU/data_out[125]} {UMforCPU/data_out[126]} {UMforCPU/data_out[127]} {UMforCPU/data_out[128]} {UMforCPU/data_out[129]} {UMforCPU/data_out[130]} {UMforCPU/data_out[131]} {UMforCPU/data_out[132]} {UMforCPU/data_out[133]}]]
connect_debug_port u_ila_0/probe11 [get_nets [list {UMforCPU/confMem/state_out[0]} {UMforCPU/confMem/state_out[1]} {UMforCPU/confMem/state_out[2]} {UMforCPU/confMem/state_out[3]}]]
connect_debug_port u_ila_0/probe12 [get_nets [list {UMforCPU/confMem/state_conf[0]} {UMforCPU/confMem/state_conf[1]} {UMforCPU/confMem/state_conf[2]} {UMforCPU/confMem/state_conf[3]}]]
connect_debug_port u_ila_0/probe13 [get_nets [list UMforCPU/conf_rden]]
connect_debug_port u_ila_0/probe14 [get_nets [list UMforCPU/confMem/conf_sel]]
connect_debug_port u_ila_0/probe15 [get_nets [list UMforCPU/conf_sel]]
connect_debug_port u_ila_0/probe16 [get_nets [list UMforCPU/conf_wren]]
connect_debug_port u_ila_0/probe17 [get_nets [list UMforCPU/picoTop/mem_instr]]
connect_debug_port u_ila_0/probe18 [get_nets [list UMforCPU/picoTop/mem_rden]]
connect_debug_port u_ila_0/probe19 [get_nets [list UMforCPU/picoTop/mem_ready]]
connect_debug_port u_ila_0/probe20 [get_nets [list UMforCPU/picoTop/mem_valid]]
connect_debug_port u_ila_0/probe21 [get_nets [list UMforCPU/picoTop/mem_wren]]
connect_debug_port u_ila_0/probe24 [get_nets [list UMforCPU/print_valid]]
connect_debug_port u_ila_0/probe25 [get_nets [list UMforCPU/rden_i]]
connect_debug_port u_ila_0/probe26 [get_nets [list UMforCPU/picoTop/trap]]
connect_debug_port u_ila_0/probe27 [get_nets [list UMforCPU/wren_i]]

connect_debug_port u_ila_0/probe14 [get_nets [list gmiiEr_calCRC]]
connect_debug_port u_ila_0/probe15 [get_nets [list gmiiEr_checkCRC]]
connect_debug_port u_ila_0/probe16 [get_nets [list gmiiEr_modifyPKT]]
connect_debug_port u_ila_1/clk [get_nets [list rgmii2gmii/gmii_rx_clk]]

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
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {UMforCPU/picoTop/picorv32/cpu_state[0]} {UMforCPU/picoTop/picorv32/cpu_state[1]} {UMforCPU/picoTop/picorv32/cpu_state[2]} {UMforCPU/picoTop/picorv32/cpu_state[3]} {UMforCPU/picoTop/picorv32/cpu_state[4]} {UMforCPU/picoTop/picorv32/cpu_state[5]} {UMforCPU/picoTop/picorv32/cpu_state[6]} {UMforCPU/picoTop/picorv32/cpu_state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {UMforCPU/conf_rdata[0]} {UMforCPU/conf_rdata[1]} {UMforCPU/conf_rdata[2]} {UMforCPU/conf_rdata[3]} {UMforCPU/conf_rdata[4]} {UMforCPU/conf_rdata[5]} {UMforCPU/conf_rdata[6]} {UMforCPU/conf_rdata[7]} {UMforCPU/conf_rdata[8]} {UMforCPU/conf_rdata[9]} {UMforCPU/conf_rdata[10]} {UMforCPU/conf_rdata[11]} {UMforCPU/conf_rdata[12]} {UMforCPU/conf_rdata[13]} {UMforCPU/conf_rdata[14]} {UMforCPU/conf_rdata[15]} {UMforCPU/conf_rdata[16]} {UMforCPU/conf_rdata[17]} {UMforCPU/conf_rdata[18]} {UMforCPU/conf_rdata[19]} {UMforCPU/conf_rdata[20]} {UMforCPU/conf_rdata[21]} {UMforCPU/conf_rdata[22]} {UMforCPU/conf_rdata[23]} {UMforCPU/conf_rdata[24]} {UMforCPU/conf_rdata[25]} {UMforCPU/conf_rdata[26]} {UMforCPU/conf_rdata[27]} {UMforCPU/conf_rdata[28]} {UMforCPU/conf_rdata[29]} {UMforCPU/conf_rdata[30]} {UMforCPU/conf_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {UMforCPU/picoTop/mem_rdata[0]} {UMforCPU/picoTop/mem_rdata[1]} {UMforCPU/picoTop/mem_rdata[2]} {UMforCPU/picoTop/mem_rdata[3]} {UMforCPU/picoTop/mem_rdata[4]} {UMforCPU/picoTop/mem_rdata[5]} {UMforCPU/picoTop/mem_rdata[6]} {UMforCPU/picoTop/mem_rdata[7]} {UMforCPU/picoTop/mem_rdata[8]} {UMforCPU/picoTop/mem_rdata[9]} {UMforCPU/picoTop/mem_rdata[10]} {UMforCPU/picoTop/mem_rdata[11]} {UMforCPU/picoTop/mem_rdata[12]} {UMforCPU/picoTop/mem_rdata[13]} {UMforCPU/picoTop/mem_rdata[14]} {UMforCPU/picoTop/mem_rdata[15]} {UMforCPU/picoTop/mem_rdata[16]} {UMforCPU/picoTop/mem_rdata[17]} {UMforCPU/picoTop/mem_rdata[18]} {UMforCPU/picoTop/mem_rdata[19]} {UMforCPU/picoTop/mem_rdata[20]} {UMforCPU/picoTop/mem_rdata[21]} {UMforCPU/picoTop/mem_rdata[22]} {UMforCPU/picoTop/mem_rdata[23]} {UMforCPU/picoTop/mem_rdata[24]} {UMforCPU/picoTop/mem_rdata[25]} {UMforCPU/picoTop/mem_rdata[26]} {UMforCPU/picoTop/mem_rdata[27]} {UMforCPU/picoTop/mem_rdata[28]} {UMforCPU/picoTop/mem_rdata[29]} {UMforCPU/picoTop/mem_rdata[30]} {UMforCPU/picoTop/mem_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/picoTop/mem_addr[0]} {UMforCPU/picoTop/mem_addr[1]} {UMforCPU/picoTop/mem_addr[2]} {UMforCPU/picoTop/mem_addr[3]} {UMforCPU/picoTop/mem_addr[4]} {UMforCPU/picoTop/mem_addr[5]} {UMforCPU/picoTop/mem_addr[6]} {UMforCPU/picoTop/mem_addr[7]} {UMforCPU/picoTop/mem_addr[8]} {UMforCPU/picoTop/mem_addr[9]} {UMforCPU/picoTop/mem_addr[10]} {UMforCPU/picoTop/mem_addr[11]} {UMforCPU/picoTop/mem_addr[12]} {UMforCPU/picoTop/mem_addr[13]} {UMforCPU/picoTop/mem_addr[14]} {UMforCPU/picoTop/mem_addr[15]} {UMforCPU/picoTop/mem_addr[16]} {UMforCPU/picoTop/mem_addr[17]} {UMforCPU/picoTop/mem_addr[18]} {UMforCPU/picoTop/mem_addr[19]} {UMforCPU/picoTop/mem_addr[20]} {UMforCPU/picoTop/mem_addr[21]} {UMforCPU/picoTop/mem_addr[22]} {UMforCPU/picoTop/mem_addr[23]} {UMforCPU/picoTop/mem_addr[24]} {UMforCPU/picoTop/mem_addr[25]} {UMforCPU/picoTop/mem_addr[26]} {UMforCPU/picoTop/mem_addr[27]} {UMforCPU/picoTop/mem_addr[28]} {UMforCPU/picoTop/mem_addr[29]} {UMforCPU/picoTop/mem_addr[30]} {UMforCPU/picoTop/mem_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 4 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/picoTop/mem_wstrb[0]} {UMforCPU/picoTop/mem_wstrb[1]} {UMforCPU/picoTop/mem_wstrb[2]} {UMforCPU/picoTop/mem_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/conf_wdata[0]} {UMforCPU/conf_wdata[1]} {UMforCPU/conf_wdata[2]} {UMforCPU/conf_wdata[3]} {UMforCPU/conf_wdata[4]} {UMforCPU/conf_wdata[5]} {UMforCPU/conf_wdata[6]} {UMforCPU/conf_wdata[7]} {UMforCPU/conf_wdata[8]} {UMforCPU/conf_wdata[9]} {UMforCPU/conf_wdata[10]} {UMforCPU/conf_wdata[11]} {UMforCPU/conf_wdata[12]} {UMforCPU/conf_wdata[13]} {UMforCPU/conf_wdata[14]} {UMforCPU/conf_wdata[15]} {UMforCPU/conf_wdata[16]} {UMforCPU/conf_wdata[17]} {UMforCPU/conf_wdata[18]} {UMforCPU/conf_wdata[19]} {UMforCPU/conf_wdata[20]} {UMforCPU/conf_wdata[21]} {UMforCPU/conf_wdata[22]} {UMforCPU/conf_wdata[23]} {UMforCPU/conf_wdata[24]} {UMforCPU/conf_wdata[25]} {UMforCPU/conf_wdata[26]} {UMforCPU/conf_wdata[27]} {UMforCPU/conf_wdata[28]} {UMforCPU/conf_wdata[29]} {UMforCPU/conf_wdata[30]} {UMforCPU/conf_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/conf_addr[0]} {UMforCPU/conf_addr[1]} {UMforCPU/conf_addr[2]} {UMforCPU/conf_addr[3]} {UMforCPU/conf_addr[4]} {UMforCPU/conf_addr[5]} {UMforCPU/conf_addr[6]} {UMforCPU/conf_addr[7]} {UMforCPU/conf_addr[8]} {UMforCPU/conf_addr[9]} {UMforCPU/conf_addr[10]} {UMforCPU/conf_addr[11]} {UMforCPU/conf_addr[12]} {UMforCPU/conf_addr[13]} {UMforCPU/conf_addr[14]} {UMforCPU/conf_addr[15]} {UMforCPU/conf_addr[16]} {UMforCPU/conf_addr[17]} {UMforCPU/conf_addr[18]} {UMforCPU/conf_addr[19]} {UMforCPU/conf_addr[20]} {UMforCPU/conf_addr[21]} {UMforCPU/conf_addr[22]} {UMforCPU/conf_addr[23]} {UMforCPU/conf_addr[24]} {UMforCPU/conf_addr[25]} {UMforCPU/conf_addr[26]} {UMforCPU/conf_addr[27]} {UMforCPU/conf_addr[28]} {UMforCPU/conf_addr[29]} {UMforCPU/conf_addr[30]} {UMforCPU/conf_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {UMforCPU/picoTop/mem_wdata[0]} {UMforCPU/picoTop/mem_wdata[1]} {UMforCPU/picoTop/mem_wdata[2]} {UMforCPU/picoTop/mem_wdata[3]} {UMforCPU/picoTop/mem_wdata[4]} {UMforCPU/picoTop/mem_wdata[5]} {UMforCPU/picoTop/mem_wdata[6]} {UMforCPU/picoTop/mem_wdata[7]} {UMforCPU/picoTop/mem_wdata[8]} {UMforCPU/picoTop/mem_wdata[9]} {UMforCPU/picoTop/mem_wdata[10]} {UMforCPU/picoTop/mem_wdata[11]} {UMforCPU/picoTop/mem_wdata[12]} {UMforCPU/picoTop/mem_wdata[13]} {UMforCPU/picoTop/mem_wdata[14]} {UMforCPU/picoTop/mem_wdata[15]} {UMforCPU/picoTop/mem_wdata[16]} {UMforCPU/picoTop/mem_wdata[17]} {UMforCPU/picoTop/mem_wdata[18]} {UMforCPU/picoTop/mem_wdata[19]} {UMforCPU/picoTop/mem_wdata[20]} {UMforCPU/picoTop/mem_wdata[21]} {UMforCPU/picoTop/mem_wdata[22]} {UMforCPU/picoTop/mem_wdata[23]} {UMforCPU/picoTop/mem_wdata[24]} {UMforCPU/picoTop/mem_wdata[25]} {UMforCPU/picoTop/mem_wdata[26]} {UMforCPU/picoTop/mem_wdata[27]} {UMforCPU/picoTop/mem_wdata[28]} {UMforCPU/picoTop/mem_wdata[29]} {UMforCPU/picoTop/mem_wdata[30]} {UMforCPU/picoTop/mem_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {UMforCPU/confMem/state_conf[0]} {UMforCPU/confMem/state_conf[1]} {UMforCPU/confMem/state_conf[2]} {UMforCPU/confMem/state_conf[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 4 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {UMforCPU/confMem/state_out[0]} {UMforCPU/confMem/state_out[1]} {UMforCPU/confMem/state_out[2]} {UMforCPU/confMem/state_out[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 134 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {pktData_um[0]} {pktData_um[1]} {pktData_um[2]} {pktData_um[3]} {pktData_um[4]} {pktData_um[5]} {pktData_um[6]} {pktData_um[7]} {pktData_um[8]} {pktData_um[9]} {pktData_um[10]} {pktData_um[11]} {pktData_um[12]} {pktData_um[13]} {pktData_um[14]} {pktData_um[15]} {pktData_um[16]} {pktData_um[17]} {pktData_um[18]} {pktData_um[19]} {pktData_um[20]} {pktData_um[21]} {pktData_um[22]} {pktData_um[23]} {pktData_um[24]} {pktData_um[25]} {pktData_um[26]} {pktData_um[27]} {pktData_um[28]} {pktData_um[29]} {pktData_um[30]} {pktData_um[31]} {pktData_um[32]} {pktData_um[33]} {pktData_um[34]} {pktData_um[35]} {pktData_um[36]} {pktData_um[37]} {pktData_um[38]} {pktData_um[39]} {pktData_um[40]} {pktData_um[41]} {pktData_um[42]} {pktData_um[43]} {pktData_um[44]} {pktData_um[45]} {pktData_um[46]} {pktData_um[47]} {pktData_um[48]} {pktData_um[49]} {pktData_um[50]} {pktData_um[51]} {pktData_um[52]} {pktData_um[53]} {pktData_um[54]} {pktData_um[55]} {pktData_um[56]} {pktData_um[57]} {pktData_um[58]} {pktData_um[59]} {pktData_um[60]} {pktData_um[61]} {pktData_um[62]} {pktData_um[63]} {pktData_um[64]} {pktData_um[65]} {pktData_um[66]} {pktData_um[67]} {pktData_um[68]} {pktData_um[69]} {pktData_um[70]} {pktData_um[71]} {pktData_um[72]} {pktData_um[73]} {pktData_um[74]} {pktData_um[75]} {pktData_um[76]} {pktData_um[77]} {pktData_um[78]} {pktData_um[79]} {pktData_um[80]} {pktData_um[81]} {pktData_um[82]} {pktData_um[83]} {pktData_um[84]} {pktData_um[85]} {pktData_um[86]} {pktData_um[87]} {pktData_um[88]} {pktData_um[89]} {pktData_um[90]} {pktData_um[91]} {pktData_um[92]} {pktData_um[93]} {pktData_um[94]} {pktData_um[95]} {pktData_um[96]} {pktData_um[97]} {pktData_um[98]} {pktData_um[99]} {pktData_um[100]} {pktData_um[101]} {pktData_um[102]} {pktData_um[103]} {pktData_um[104]} {pktData_um[105]} {pktData_um[106]} {pktData_um[107]} {pktData_um[108]} {pktData_um[109]} {pktData_um[110]} {pktData_um[111]} {pktData_um[112]} {pktData_um[113]} {pktData_um[114]} {pktData_um[115]} {pktData_um[116]} {pktData_um[117]} {pktData_um[118]} {pktData_um[119]} {pktData_um[120]} {pktData_um[121]} {pktData_um[122]} {pktData_um[123]} {pktData_um[124]} {pktData_um[125]} {pktData_um[126]} {pktData_um[127]} {pktData_um[128]} {pktData_um[129]} {pktData_um[130]} {pktData_um[131]} {pktData_um[132]} {pktData_um[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 134 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {pktData_gmii[0]} {pktData_gmii[1]} {pktData_gmii[2]} {pktData_gmii[3]} {pktData_gmii[4]} {pktData_gmii[5]} {pktData_gmii[6]} {pktData_gmii[7]} {pktData_gmii[8]} {pktData_gmii[9]} {pktData_gmii[10]} {pktData_gmii[11]} {pktData_gmii[12]} {pktData_gmii[13]} {pktData_gmii[14]} {pktData_gmii[15]} {pktData_gmii[16]} {pktData_gmii[17]} {pktData_gmii[18]} {pktData_gmii[19]} {pktData_gmii[20]} {pktData_gmii[21]} {pktData_gmii[22]} {pktData_gmii[23]} {pktData_gmii[24]} {pktData_gmii[25]} {pktData_gmii[26]} {pktData_gmii[27]} {pktData_gmii[28]} {pktData_gmii[29]} {pktData_gmii[30]} {pktData_gmii[31]} {pktData_gmii[32]} {pktData_gmii[33]} {pktData_gmii[34]} {pktData_gmii[35]} {pktData_gmii[36]} {pktData_gmii[37]} {pktData_gmii[38]} {pktData_gmii[39]} {pktData_gmii[40]} {pktData_gmii[41]} {pktData_gmii[42]} {pktData_gmii[43]} {pktData_gmii[44]} {pktData_gmii[45]} {pktData_gmii[46]} {pktData_gmii[47]} {pktData_gmii[48]} {pktData_gmii[49]} {pktData_gmii[50]} {pktData_gmii[51]} {pktData_gmii[52]} {pktData_gmii[53]} {pktData_gmii[54]} {pktData_gmii[55]} {pktData_gmii[56]} {pktData_gmii[57]} {pktData_gmii[58]} {pktData_gmii[59]} {pktData_gmii[60]} {pktData_gmii[61]} {pktData_gmii[62]} {pktData_gmii[63]} {pktData_gmii[64]} {pktData_gmii[65]} {pktData_gmii[66]} {pktData_gmii[67]} {pktData_gmii[68]} {pktData_gmii[69]} {pktData_gmii[70]} {pktData_gmii[71]} {pktData_gmii[72]} {pktData_gmii[73]} {pktData_gmii[74]} {pktData_gmii[75]} {pktData_gmii[76]} {pktData_gmii[77]} {pktData_gmii[78]} {pktData_gmii[79]} {pktData_gmii[80]} {pktData_gmii[81]} {pktData_gmii[82]} {pktData_gmii[83]} {pktData_gmii[84]} {pktData_gmii[85]} {pktData_gmii[86]} {pktData_gmii[87]} {pktData_gmii[88]} {pktData_gmii[89]} {pktData_gmii[90]} {pktData_gmii[91]} {pktData_gmii[92]} {pktData_gmii[93]} {pktData_gmii[94]} {pktData_gmii[95]} {pktData_gmii[96]} {pktData_gmii[97]} {pktData_gmii[98]} {pktData_gmii[99]} {pktData_gmii[100]} {pktData_gmii[101]} {pktData_gmii[102]} {pktData_gmii[103]} {pktData_gmii[104]} {pktData_gmii[105]} {pktData_gmii[106]} {pktData_gmii[107]} {pktData_gmii[108]} {pktData_gmii[109]} {pktData_gmii[110]} {pktData_gmii[111]} {pktData_gmii[112]} {pktData_gmii[113]} {pktData_gmii[114]} {pktData_gmii[115]} {pktData_gmii[116]} {pktData_gmii[117]} {pktData_gmii[118]} {pktData_gmii[119]} {pktData_gmii[120]} {pktData_gmii[121]} {pktData_gmii[122]} {pktData_gmii[123]} {pktData_gmii[124]} {pktData_gmii[125]} {pktData_gmii[126]} {pktData_gmii[127]} {pktData_gmii[128]} {pktData_gmii[129]} {pktData_gmii[130]} {pktData_gmii[131]} {pktData_gmii[132]} {pktData_gmii[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {UMforCPU/print_value[0]} {UMforCPU/print_value[1]} {UMforCPU/print_value[2]} {UMforCPU/print_value[3]} {UMforCPU/print_value[4]} {UMforCPU/print_value[5]} {UMforCPU/print_value[6]} {UMforCPU/print_value[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list UMforCPU/conf_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list UMforCPU/conf_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list UMforCPU/confMem/conf_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list UMforCPU/conf_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list UMforCPU/picoTop/mem_instr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list UMforCPU/picoTop/mem_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list UMforCPU/picoTop/mem_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list UMforCPU/picoTop/mem_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list UMforCPU/picoTop/mem_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list pktData_valid_gmii]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list pktData_valid_um]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list UMforCPU/print_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list UMforCPU/picoTop/trap]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_125m]

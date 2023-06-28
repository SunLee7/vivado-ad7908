set_property IOSTANDARD LVCMOS33 [get_ports clk_ad]
set_property IOSTANDARD LVCMOS33 [get_ports cnv]
set_property IOSTANDARD LVCMOS33 [get_ports cs1]
set_property IOSTANDARD LVCMOS33 [get_ports cs2]
set_property IOSTANDARD LVCMOS33 [get_ports data_in]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN R17 [get_ports rst_n]
set_property PULLUP true [get_ports rst_n]
set_property PACKAGE_PIN Y19 [get_ports data_in]

set_property PACKAGE_PIN W14 [get_ports cnv]
set_property PACKAGE_PIN Y16 [get_ports cs1]
set_property PACKAGE_PIN Y17 [get_ports cs2]

set_property PACKAGE_PIN U18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports adc_clk]
set_property PACKAGE_PIN Y18 [get_ports adc_clk]

set_property SLEW FAST [get_ports adc_clk]
set_property SLEW FAST [get_ports cnv]
set_property SLEW FAST [get_ports cs1]
set_property SLEW FAST [get_ports cs2]

set clk_axi  [get_clocks -of_objects [get_nets -of_objects [get_pins d_1_i/zynq_ultra_ps_e_0/pl_clk0]]]
set clk_adc0 [get_clocks -of_objects [get_nets -of_objects [get_pins d_1_i/usp_rf_data_converter_0/clk_adc0]]]

set_clock_group -name clk_axi_to_adc0 -asynchronous \
    -group [get_clocks $clk_axi] \
    -group [get_clocks $clk_adc0]
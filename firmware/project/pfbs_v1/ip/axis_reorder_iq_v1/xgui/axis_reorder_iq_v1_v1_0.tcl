# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "B" -parent ${Page_0}
  ipgui::add_param $IPINST -name "L" -parent ${Page_0}


}

proc update_PARAM_VALUE.B { PARAM_VALUE.B } {
	# Procedure called to update B when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.B { PARAM_VALUE.B } {
	# Procedure called to validate B
	return true
}

proc update_PARAM_VALUE.L { PARAM_VALUE.L } {
	# Procedure called to update L when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.L { PARAM_VALUE.L } {
	# Procedure called to validate L
	return true
}


proc update_MODELPARAM_VALUE.B { MODELPARAM_VALUE.B PARAM_VALUE.B } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.B}] ${MODELPARAM_VALUE.B}
}

proc update_MODELPARAM_VALUE.L { MODELPARAM_VALUE.L PARAM_VALUE.L } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.L}] ${MODELPARAM_VALUE.L}
}


# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BAXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BDATA" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BUSER" -parent ${Page_0}


}

proc update_PARAM_VALUE.BAXIS { PARAM_VALUE.BAXIS } {
	# Procedure called to update BAXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAXIS { PARAM_VALUE.BAXIS } {
	# Procedure called to validate BAXIS
	return true
}

proc update_PARAM_VALUE.BDATA { PARAM_VALUE.BDATA } {
	# Procedure called to update BDATA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BDATA { PARAM_VALUE.BDATA } {
	# Procedure called to validate BDATA
	return true
}

proc update_PARAM_VALUE.BUSER { PARAM_VALUE.BUSER } {
	# Procedure called to update BUSER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUSER { PARAM_VALUE.BUSER } {
	# Procedure called to validate BUSER
	return true
}


proc update_MODELPARAM_VALUE.BDATA { MODELPARAM_VALUE.BDATA PARAM_VALUE.BDATA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BDATA}] ${MODELPARAM_VALUE.BDATA}
}

proc update_MODELPARAM_VALUE.BUSER { MODELPARAM_VALUE.BUSER PARAM_VALUE.BUSER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUSER}] ${MODELPARAM_VALUE.BUSER}
}

proc update_MODELPARAM_VALUE.BAXIS { MODELPARAM_VALUE.BAXIS PARAM_VALUE.BAXIS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BAXIS}] ${MODELPARAM_VALUE.BAXIS}
}


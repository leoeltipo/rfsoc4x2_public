create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_0
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_0.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_0]

create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_1
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_1.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_1]

create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_2
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_2.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_2]

create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_3
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_3.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_3]

create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_4
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_4.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_4]

create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_5
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_5.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_5]

create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_6
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_6.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_6]

create_ip -name fir_compiler -vendor xilinx.com -library ip -version 7.2 -module_name fir_7
set_property -dict [list \
	CONFIG.CoefficientSource {COE_File} \
	CONFIG.Coefficient_File {/home/lstefana/rfsoc-vivado-2022-1/ip/axis_pfbs_pr_4x256_v1/src/fir/coef/fir_7.coe} \
	CONFIG.Coefficient_Sets {32} \
	CONFIG.Filter_Type {Interpolated} \
	CONFIG.Number_Channels {32} \
	CONFIG.Number_Paths {2} \
	CONFIG.RateSpecification {Input_Sample_Period} \
	CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
	CONFIG.Output_Width {16} \
	CONFIG.DATA_Has_TLAST {Vector_Framing} \
	CONFIG.S_CONFIG_Method {By_Channel} \
	CONFIG.Interpolation_Rate {1} \
	CONFIG.Decimation_Rate {1} \
	CONFIG.Zero_Pack_Factor {2} \
	CONFIG.Select_Pattern {All} \
	CONFIG.SamplePeriod {1} \
	CONFIG.Sample_Frequency {0.001} \
	CONFIG.Clock_Frequency {300.0} \
	CONFIG.Coefficient_Sign {Signed} \
	CONFIG.Quantization {Integer_Coefficients} \
	CONFIG.Coefficient_Width {16} \
	CONFIG.Coefficient_Fractional_Bits {0} \
	CONFIG.Coefficient_Structure {Inferred} \
	CONFIG.Data_Width {16} \
	CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
	CONFIG.ColumnConfig {7} \
	CONFIG.S_DATA_Has_TUSER {Not_Required} \
	CONFIG.M_DATA_Has_TUSER {Not_Required} \
	CONFIG.Filter_Selection {1}] \
[get_ips fir_7]


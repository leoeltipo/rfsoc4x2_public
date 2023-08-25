module dds_top
	#(
		parameter NCH = 16
	)
	(
		// Reset and clock.
		input 	wire 			rstn			,
		input 	wire 			clk				,

		// Memory interface.
		output	wire [15:0]		mem_addr		,
		input	wire [127:0]	mem_do			,

		// Input data.
		input	wire [31:0]		din				,
		input	wire			din_last		,

		// Output down-converted data.
		output	wire [31:0]		dout_dc			,
		output	wire			dout_dc_last	,

		// Output up-converted data.
		output	wire [31:0]		dout_uc			,
		output	wire			dout_uc_last	,

		// Registers.
		input	wire			SYNC_REG
	);

/*************/
/* Internals */
/*************/
// DDS Framing.
wire [31:0]		framing_dds_freq	;
wire [31:0]		framing_dds_phase	;
wire [15:0]		framing_dds_gain	;
wire [31:0]		framing_comp_gain	;
wire [7:0]		framing_cfg			;
wire			framing_last		;

// DDS TDM.
wire [31:0]		dds_tdm_dout		;
wire			dds_tdm_last		;

// DDS down-converter.
wire [31:0]		dds_dc_dout			;
wire			dds_dc_last			;

// DDS up-converter.
wire [31:0]		dds_uc_dout			;
wire			dds_uc_last			;

// Latency for input data.
wire [31:0]		din_la				;

// Latency for compensation gain.
wire [31:0]		comp_gain_la		;

// Latency for configuration.
wire [7:0]		cfg_la				;

// Latency for gain.
wire [15:0]		gain_la				;

/****************/
/* Architecture */
/****************/

// DDS Framing.
// L = 1.
dds_framing
	#(
		.NCH(NCH)
	)
	dds_framing_i
	(
		// Reset and clock.
		.rstn		(rstn				),
		.clk		(clk				),

		// Memory interface.
		.mem_addr	(mem_addr			),
		.mem_do		(mem_do				),

		// Input tlast for framing.
		.last_i		(din_last			),

		// Output for dds control
		.dds_freq	(framing_dds_freq	),
		.dds_phase	(framing_dds_phase	),
		.dds_gain	(framing_dds_gain	),
		.comp_gain	(framing_comp_gain	),
		.cfg		(framing_cfg		),

		// Output tlast for framing.
		.last_o		(framing_last		),

		// Registers.
		.SYNC_REG	(SYNC_REG			)
	);

// DDS TDM.
// L = 12.
dds_tdm dds_tdm_i
	(
		// Reset and clock.
		.rstn		(rstn				),
		.clk		(clk				),

		// Data input.
		.din_freq	(framing_dds_freq	),
		.din_phase	(framing_dds_phase	),
		.din_last	(framing_last		),

		// Data output.
		.dout		(dds_tdm_dout		),
		.dout_last	(dds_tdm_last		)
	);

// DDS down-converter.
// L = 5.
dds_downconv dds_downconv_i
	(
		// Reset and clock.
		.rstn		(rstn			),
		.clk		(clk			),

		// Input data.
		.din		(din_la			),
		.din_dds	(dds_tdm_dout	),
		.din_last	(dds_tdm_last	),

		// Compensation gain (complex).
		.gain		(comp_gain_la	),

		// Configuration.
		.cfg		(cfg_la	[2:0]	),

		// Output data.
		.dout		(dds_dc_dout	),
		.dout_last	(dds_dc_last	)
	);

// DDS up-converter.
// L = 2.
dds_upconv dds_upconv_i
	(
		// Reset and clock.
		.rstn		(rstn			),
		.clk		(clk			),

		// Input data.
		.din		(dds_tdm_dout	),
		.din_last	(dds_tdm_last	),

		// Input gain.
		.gain		(gain_la		),

		// Output data.
		.dout		(dds_uc_dout	),
		.dout_last	(dds_uc_last	)
	);

// Latency for input data.
latency_reg
	#(
		// Latency.
		.N(1 + 12	),	// DDS Framing + DDS TDM.

		// Data width.
		.B(32		)
	)
	latency_reg_din_i
	(
		// Reset and clock.
		.rstn	(rstn	),
		.clk	(clk	),

		// Data input.
		.din	(din	),

		// Data output.
		.dout	(din_la	)
	);

// Latency for compensation gain.
latency_reg
	#(
		// Latency.
		.N(12),	// DDS TDM.

		// Data width.
		.B(32)
	)
	latency_reg_comp_gain_i
	(
		// Reset and clock.
		.rstn	(rstn				),
		.clk	(clk				),

		// Data input.
		.din	(framing_comp_gain	),

		// Data output.
		.dout	(comp_gain_la		)
	);

// Latency for configuration.
latency_reg
	#(
		// Latency.
		.N(12),	// DDS TDM.

		// Data width.
		.B(8)
	)
	latency_reg_cfg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(framing_cfg	),

		// Data output.
		.dout	(cfg_la			)
	);

// Latency for gain.
latency_reg
	#(
		// Latency.
		.N(12),	// DDS TDM.

		// Data width.
		.B(16)
	)
	latency_reg_gain_i
	(
		// Reset and clock.
		.rstn	(rstn				),
		.clk	(clk				),

		// Data input.
		.din	(framing_dds_gain	),

		// Data output.
		.dout	(gain_la			)
	);


// Registers.
always @(posedge clk) begin
	if (~rstn) begin
	end
	else begin
	end
end 

// Assign outputs.
assign dout_dc		= dds_dc_dout;
assign dout_dc_last	= dds_dc_last;
assign dout_uc		= dds_uc_dout;
assign dout_uc_last	= dds_uc_last;

endmodule


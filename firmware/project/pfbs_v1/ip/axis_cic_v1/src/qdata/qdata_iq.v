module qdata_iq
	#(
		// Number of bits of Input.
		parameter BIN 	= 24	,

		// Number of bits of Output.
		parameter BOUT	= 16
	)
	(
		// Reset and clock.
		input	wire				rstn		,
		input 	wire				clk			,

		// Input data.
		input 	wire [2*BIN-1:0]	din			,
		input 	wire				din_last	,
		input 	wire				din_valid	,

		// Output data.
		output 	wire [2*BOUT-1:0]	dout		,
		output 	wire				dout_last	,
		output 	wire				dout_valid	,

		// Registers.
		input	wire [31:0]			QSEL_REG
	);

/*************/
/* Internals */
/*************/
wire [BIN-1:0]	din_real;
wire [BIN-1:0]	din_imag;
wire [BOUT-1:0]	dout_real;
wire [BOUT-1:0]	dout_imag;

/****************/
/* Architecture */
/****************/

// Input data.
assign din_real = din[0 +: BIN];
assign din_imag = din[BIN +: BIN];

// Quantization of Real part.
qdata
	#(
		// Number of bits of Input.
		.BIN	(BIN	),

		// Number of bits of Output.
		.BOUT	(BOUT	)
	)
	qdata_i
	(
		// Reset and clock.
		.rstn		(rstn		),
		.clk		(clk		),

		// Input data.
		.din		(din_real  	),
		.din_last	(din_last 	),
		.din_valid	(din_valid	),

		// Output data.
		.dout		(dout_real	),
		.dout_last	(dout_last	),
		.dout_valid	(dout_valid	),

		// Registers.
		.QSEL_REG	(QSEL_REG	)
	);

// Quantization of Imaginary part.
qdata
	#(
		// Number of bits of Input.
		.BIN	(BIN	),

		// Number of bits of Output.
		.BOUT	(BOUT	)
	)
	qdata_q
	(
		// Reset and clock.
		.rstn		(rstn		),
		.clk		(clk		),

		// Input data.
		.din		(din_imag  	),
		.din_last	(din_last 	),
		.din_valid	(din_valid	),

		// Output data.
		.dout		(dout_imag	),
		.dout_last	(			),
		.dout_valid	(			),

		// Registers.
		.QSEL_REG	(QSEL_REG	)
	);

// Assign outputs.
assign dout			= {dout_imag,dout_real};

endmodule


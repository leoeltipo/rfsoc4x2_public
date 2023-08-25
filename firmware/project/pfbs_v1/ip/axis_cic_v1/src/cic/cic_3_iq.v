/*
 * Cascaded CIC filter implementation with 3 stages.
 * Complex input/output.
 */
module cic_3_iq
	#(
		// Number of channels.
		parameter NCH 	= 16,

		// Number of bits.
		parameter B		= 8	,

		// Number of pipeline registers.
		parameter NPIPE	= 2
	)
	(
		// Reset and clock.
		input	wire			rstn		,
		input 	wire			clk			,

		// Input data.
		input 	wire [2*B-1:0]	din			,
		input 	wire			din_last	,

		// Output data.
		output 	wire [2*B-1:0]	dout		,
		output 	wire			dout_last	,
		output 	wire			dout_valid	,

		// Registers.
		input	wire			RST_REG		,
		input 	wire [7:0]		D_REG
	);

/*************/
/* Internals */
/*************/
// Real/Imaginary data input.
wire [B-1:0]	din_real;
wire [B-1:0]	din_imag;

// Real/Imaginary data output.
wire [B-1:0]	dout_real;
wire [B-1:0]	dout_imag;

/****************/
/* Architecture */
/****************/

// Real/Imaginary data input.
assign din_real	= din[0 +: B];
assign din_imag	= din[B +: B];

// 3-stage CIC.
cic_3
	#(
		// Number of channels.
		.NCH	(NCH	),

		// Number of bits.
		.B		(B		),

		// Number of pipeline registers.
		.NPIPE	(NPIPE	)
	)
	cic_3_real_i
	(
		.rstn		(rstn		),
		.clk		(clk		),
		.din		(din_real	),
		.din_last	(din_last	),
		.dout		(dout_real	),
		.dout_last	(dout_last	),
		.dout_valid	(dout_valid	),
		.RST_REG	(RST_REG	),
		.D_REG		(D_REG		)
	);

// 3-stage CIC.
cic_3
	#(
		// Number of channels.
		.NCH	(NCH	),

		// Number of bits.
		.B		(B		),

		// Number of pipeline registers.
		.NPIPE	(NPIPE	)
	)
	cic_3_imag_i
	(
		.rstn		(rstn		),
		.clk		(clk		),
		.din		(din_imag	),
		.din_last	(din_last	),
		.dout		(dout_imag	),
		.dout_last	(           ),
		.dout_valid	(           ),
		.RST_REG	(RST_REG	),
		.D_REG		(D_REG		)
	);

// Assign outputs.
assign dout	= {dout_imag,dout_real};

endmodule


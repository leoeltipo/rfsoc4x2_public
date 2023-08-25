module cic_top
	#(
		// Number of channels.
		parameter NCH 		= 16	,

		// Number of CIC pipeline registers.
		parameter NPIPE_CIC	= 2
	)
	(
		// Reset and clock.
		input 	wire 		rstn			,
		input 	wire 		clk				,

		// Input data.
		input	wire [31:0]	din				,
		input	wire		din_last		,

		// Output data.
		output	wire [31:0]	dout			,
		output	wire		dout_last		,
		output	wire		dout_valid		,

		// Registers.
		input	wire		CIC_RST_REG		,
		input 	wire [7:0]	CIC_D_REG		,
		input 	wire [31:0]	QDATA_QSEL_REG
	);

/*************/
/* Internals */
/*************/
// Maximum number of bits for CIC internals: BIN + Q*Log2(D),
// where Q is the number of cascaded stages and D is the 
// maximum decimation factor (pp. 562 Lyons book).
//
// NOTE: for B = 16 bits and the fixed given CIC parameters,
// the BCIC bits is 40 for I/Q components.
localparam B		= 16;
localparam DMAX_CIC	= 256;
localparam Q_CIC	= 3;
localparam BCIC		= B + Q_CIC*$clog2(DMAX_CIC);

// CIC input data.
wire [BCIC-1:0]		cic_din_real	;
wire [BCIC-1:0]		cic_din_imag	;
wire [2*BCIC-1:0]	cic_din			;

// CIC output data.
wire [2*BCIC-1:0]	cic_dout		;
wire				cic_dout_last	;
wire				cic_dout_valid	;

// CIC input data.
assign cic_din_real = {{(BCIC-B){din[15]}},din[15:0]};
assign cic_din_imag = {{(BCIC-B){din[31]}},din[31:16]};
assign cic_din		= {cic_din_imag,cic_din_real};

cic_3_iq
	#(
		// Number of channels.
		.NCH	(NCH		),

		// Number of bits.
		.B		(BCIC		),

		// Number of pipeline registers.
		.NPIPE	(NPIPE_CIC	)
	)
	cic_3_iq_i
	(
		// Reset and clock.
		.rstn		(rstn			),
		.clk		(clk			),

		// Input data.
		.din		(cic_din		),
		.din_last	(din_last		),

		// Output data.
		.dout		(cic_dout		),
		.dout_last	(cic_dout_last	),
		.dout_valid	(cic_dout_valid	),

		// Registers.
		.RST_REG	(CIC_RST_REG	),
		.D_REG		(CIC_D_REG		)
	);

qdata_iq
	#(
		// Number of bits of Input.
		.BIN	(BCIC	),

		// Number of bits of Output.
		.BOUT	(16		)
	)
	qdata_iq_i
	(
		// Reset and clock.
		.rstn		(rstn			),
		.clk		(clk			),

		// Input data.
		.din		(cic_dout		),
		.din_last	(cic_dout_last	),
		.din_valid	(cic_dout_valid	),

		// Output data.
		.dout		(dout			),
		.dout_last	(dout_last		),
		.dout_valid	(dout_valid		),

		// Registers.
		.QSEL_REG	(QDATA_QSEL_REG	)
	);
	
endmodule

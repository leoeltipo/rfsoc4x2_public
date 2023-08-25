module qdata
	#(
		// Number of bits of Input.
		parameter BIN 	= 24	,

		// Number of bits of Output.
		parameter BOUT	= 16
	)
	(
		// Reset and clock.
		input	wire			rstn		,
		input 	wire			clk			,

		// Input data.
		input 	wire [BIN-1:0]	din			,
		input 	wire			din_last	,
		input 	wire			din_valid	,

		// Output data.
		output 	wire [BOUT-1:0]	dout		,
		output 	wire			dout_last	,
		output 	wire			dout_valid	,
		
		// Registers.
		input	wire [31:0]		QSEL_REG
	);

/*************/
/* Internals */
/*************/
wire [31:0] qsel_i;

/****************/
/* Architecture */
/****************/
assign qsel_i = BIN - QSEL_REG - 1;

// Assign outputs.
assign dout			= din[qsel_i -: BOUT];
assign dout_last	= din_last;
assign dout_valid	= din_valid;

endmodule


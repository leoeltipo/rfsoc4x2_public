// This block down-converts the input data with the dds.
// The dds is supposed to provide e^jw. The dds is conjugated.
//
// Compensation gain is also applied.
//
module dds_downconv
	(
		// Reset and clock.
		input 	wire 		rstn		,
		input 	wire 		clk			,

		// Input data.
		input	wire [31:0]	din			,
		input	wire [31:0]	din_dds		,
		input	wire		din_last	,

		// Compensation gain (complex).
		input	wire [31:0]	gain		,

		// Configuration.
		input	wire [2:0]	cfg			,

		// Output data.
		output	wire [31:0]	dout		,
		output	wire		dout_last
	);

/*************/
/* Internals */
/*************/
// Input registers.
reg			[31:0]	din_r1;
reg			[31:0]	din_dds_r1;

// Gain pipeline.
reg			[31:0]	gain_r1;
reg			[31:0]	gain_r2;
reg			[31:0]	gain_r3;

// Signal Product.
wire signed	[15:0]	din_real;
wire signed	[15:0]	din_imag;
wire signed	[15:0]	dds_real;
wire signed	[15:0]	dds_imag;

wire signed [32:0]	prod_a_real;
wire signed [32:0]	prod_b_real;
reg  signed [32:0]	prod_a_real_r1;
reg  signed [32:0]	prod_b_real_r1;
wire signed [32:0]	prod_real;
wire signed [15:0]	prod_real_round;
reg  signed [15:0]	prod_real_r1;

wire signed [32:0]	prod_a_imag;
wire signed [32:0]	prod_b_imag;
reg  signed [32:0]	prod_a_imag_r1;
reg  signed [32:0]	prod_b_imag_r1;
wire signed [32:0]	prod_imag;
wire signed [15:0]	prod_imag_round;
reg  signed [15:0]	prod_imag_r1;

// DDS latency for mux.
wire		[15:0]	dds_real_la;
wire		[15:0]	dds_imag_la;

// Data input latency for mux.
wire		[15:0]	din_real_la;
wire		[15:0]	din_imag_la;

// Mux for outsel.
wire		[15:0]	prod_real_mux;
wire		[15:0]	prod_imag_mux;

// Product latency for mux (compsel).
wire		[15:0]	prod_real_mux_la;
wire		[15:0]	prod_imag_mux_la;

// Gain Product.
wire signed	[15:0]	downc_real;
wire signed	[15:0]	downc_imag;
wire signed	[15:0]	gain_real;
wire signed	[15:0]	gain_imag;

wire signed [32:0]	comp_a_real;
wire signed [32:0]	comp_b_real;
reg  signed [32:0]	comp_a_real_r1;
reg  signed [32:0]	comp_b_real_r1;
wire signed [32:0]	comp_real;
wire signed [15:0]	comp_real_round;
reg  signed [15:0]	comp_real_r1;

wire signed [32:0]	comp_a_imag;
wire signed [32:0]	comp_b_imag;
reg  signed [32:0]	comp_a_imag_r1;
reg  signed [32:0]	comp_b_imag_r1;
wire signed [32:0]	comp_imag;
wire signed [15:0]	comp_imag_round;
reg  signed [15:0]	comp_imag_r1;

// Mux for compsel.
wire		[15:0]	comp_real_mux;
wire		[15:0]	comp_imag_mux;

// Configuration.
wire		[1:0]	outsel;
wire				compsel;

// Latency for configuration.
wire		[1:0]	outsel_la;
wire				compsel_la;

// Last pipeline.
wire				last_la;

/****************/
/* Architecture */
/****************/

// Signal Product.
// (din_real + j din_imag)*(dds_real - j dds_imag)
assign	din_real		= din_r1 [15:0];
assign	din_imag		= din_r1 [31:16];
assign	dds_real		= din_dds_r1 [15:0];
assign	dds_imag		= din_dds_r1 [31:16];

assign	prod_a_real		= din_real*dds_real;
assign	prod_b_real		= din_imag*dds_imag;
assign	prod_real		= prod_a_real_r1 + prod_b_real_r1;
assign	prod_real_round	= prod_real [30 -: 16];

assign	prod_a_imag		= din_real*dds_imag;
assign	prod_b_imag		= din_imag*dds_real;
assign	prod_imag		= prod_b_imag_r1 - prod_a_imag_r1;
assign	prod_imag_round	= prod_imag [30 -: 16];

// Mux for outsel.
assign	prod_real_mux	= 	(outsel_la == 0)? prod_real_r1	:
							(outsel_la == 1)? dds_real_la	:
							(outsel_la == 2)? din_real_la	:
							0;

assign	prod_imag_mux	= 	(outsel_la == 0)? prod_imag_r1	:
							(outsel_la == 1)? dds_imag_la	:
							(outsel_la == 2)? din_imag_la	:
							0;

// Gain Product.
// (prod_real + j prod_imag)*(gain_real + j gain_imag)
assign	downc_real		= prod_real_mux;
assign	downc_imag		= prod_imag_mux;
assign	gain_real		= gain_r3[15:0];
assign	gain_imag		= gain_r3[31:16];

assign	comp_a_real		= downc_real*gain_real;
assign	comp_b_real		= downc_imag*gain_imag;
assign	comp_real		= comp_a_real_r1 - comp_b_real_r1;
assign	comp_real_round	= comp_real [30 -: 16];

assign	comp_a_imag		= downc_real*gain_imag;
assign	comp_b_imag		= downc_imag*gain_real;
assign	comp_imag		= comp_a_imag_r1 + comp_b_imag_r1;
assign	comp_imag_round	= comp_imag [30 -: 16];

// Mux for compsel.
assign comp_real_mux	= (compsel_la == 0)? comp_real_r1 : prod_real_mux_la;
assign comp_imag_mux	= (compsel_la == 0)? comp_imag_r1 : prod_imag_mux_la;

// Configuration.
assign outsel			= cfg[1:0];
assign compsel			= cfg[2];

// DDS latency for mux.
latency_reg
	#(
		// Latency.
		.N(2),

		// Data width.
		.B(16)
	)
	latency_reg_dds_real_i
	(
		// Reset and clock.
		.rstn	(rstn		),
		.clk	(clk		),

		// Data input.
		.din	(dds_real	),

		// Data output.
		.dout	(dds_real_la	)
	);

// DDS latency for mux.
latency_reg
	#(
		// Latency.
		.N(2),

		// Data width.
		.B(16)
	)
	latency_reg_dds_imag_i
	(
		// Reset and clock.
		.rstn	(rstn		),
		.clk	(clk		),

		// Data input.
		.din	(dds_imag	),

		// Data output.
		.dout	(dds_imag_la	)
	);

// Data input latency for mux.
latency_reg
	#(
		// Latency.
		.N(2),

		// Data width.
		.B(16)
	)
	latency_reg_din_real_i
	(
		// Reset and clock.
		.rstn	(rstn		),
		.clk	(clk		),

		// Data input.
		.din	(din_real	),

		// Data output.
		.dout	(din_real_la)
	);

// Data input latency for mux.
latency_reg
	#(
		// Latency.
		.N(2),

		// Data width.
		.B(16)
	)
	latency_reg_din_imag_i
	(
		// Reset and clock.
		.rstn	(rstn		),
		.clk	(clk		),

		// Data input.
		.din	(din_imag	),

		// Data output.
		.dout	(din_imag_la)
	);

// Product latency for mux (compsel).
latency_reg
	#(
		// Latency.
		.N(2),

		// Data width.
		.B(16)
	)
	latency_reg_prod_real_mux_i
	(
		// Reset and clock.
		.rstn	(rstn				),
		.clk	(clk				),

		// Data input.
		.din	(prod_real_mux		),

		// Data output.
		.dout	(prod_real_mux_la	)
	);

latency_reg
	#(
		// Latency.
		.N(2),

		// Data width.
		.B(16)
	)
	latency_reg_prod_imag_mux_i
	(
		// Reset and clock.
		.rstn	(rstn				),
		.clk	(clk				),

		// Data input.
		.din	(prod_imag_mux		),

		// Data output.
		.dout	(prod_imag_mux_la	)
	);

// Latency for configuration.
latency_reg
	#(
		// Latency.
		.N(3),

		// Data width.
		.B(2)
	)
	latency_reg_outsel_i
	(
		// Reset and clock.
		.rstn	(rstn		),
		.clk	(clk		),

		// Data input.
		.din	(outsel		),

		// Data output.
		.dout	(outsel_la	)
	);

latency_reg
	#(
		// Latency.
		.N(5),

		// Data width.
		.B(1)
	)
	latency_reg_compsel_i
	(
		// Reset and clock.
		.rstn	(rstn		),
		.clk	(clk		),

		// Data input.
		.din	(compsel	),

		// Data output.
		.dout	(compsel_la	)
	);

// Last pipeline.
latency_reg
	#(
		// Latency.
		.N(5),

		// Data width.
		.B(1)
	)
	latency_reg_last_i
	(
		// Reset and clock.
		.rstn	(rstn		),
		.clk	(clk		),

		// Data input.
		.din	(din_last	),

		// Data output.
		.dout	(last_la	)
	);

// Registers.
always @(posedge clk) begin
	if (~rstn) begin
		// Input registers.
		din_r1			<= 0;
		din_dds_r1		<= 0;

		// Gain pipeline.
		gain_r1			<= 0;
		gain_r2			<= 0;
		gain_r3			<= 0;

		// Signal Product.
		prod_a_real_r1	<= 0;
		prod_b_real_r1	<= 0;
		prod_real_r1	<= 0;
		
		prod_a_imag_r1	<= 0;
		prod_b_imag_r1	<= 0;
		prod_imag_r1	<= 0;

		// Gain Product.
		comp_a_real_r1	<= 0;
		comp_b_real_r1	<= 0;
		comp_real_r1	<= 0;
		
		comp_a_imag_r1	<= 0;
		comp_b_imag_r1	<= 0;
		comp_imag_r1	<= 0;
	end
	else begin
		// Input registers.
		din_r1			<= din;
		din_dds_r1		<= din_dds;

		// Gain pipeline.
		gain_r1			<= gain;
		gain_r2			<= gain_r1;
		gain_r3			<= gain_r2;

		// Signal Product.
		prod_a_real_r1	<= prod_a_real;
		prod_b_real_r1	<= prod_b_real;
		prod_real_r1	<= prod_real_round;
		
		prod_a_imag_r1	<= prod_a_imag;
		prod_b_imag_r1	<= prod_b_imag;
		prod_imag_r1	<= prod_imag_round;

		// Gain Product.
		comp_a_real_r1	<= comp_a_real;
		comp_b_real_r1	<= comp_b_real;
		comp_real_r1	<= comp_real_round;
		
		comp_a_imag_r1	<= comp_a_imag;
		comp_b_imag_r1	<= comp_b_imag;
		comp_imag_r1	<= comp_imag_round;
	end
end 

// Assign outputs.
assign dout			= {comp_imag_mux, comp_real_mux};
assign dout_last	= last_la;

endmodule


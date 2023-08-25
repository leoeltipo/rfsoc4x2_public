// This block multiplies the incoming dds data with the gain.
module dds_upconv
	(
		// Reset and clock.
		input 	wire 		rstn		,
		input 	wire 		clk			,

		// Input data.
		input	wire [31:0]	din			,
		input	wire		din_last	,

		// Input gain.
		input	wire [15:0]	gain		,

		// Output data.
		output	wire [31:0]	dout		,
		output	wire		dout_last
	);

/*************/
/* Internals */
/*************/
// Input registers.
reg			[31:0]	din_r1;
reg			[15:0]	gain_r1;

// Product.
wire signed	[15:0]	din_real;
wire signed	[15:0]	din_imag;
wire signed [15:0]	gain_s;
wire signed [31:0]	prod_real;
wire signed [31:0]	prod_imag;

// Rounding.
wire signed [15:0]	prod_real_round;
wire signed [15:0]	prod_imag_round;
wire		[31:0]	prod;
reg			[31:0]	prod_r1;

// last pipe.
reg					last_r1;
reg					last_r2;

/****************/
/* Architecture */
/****************/

// Partial products.
assign din_real			= din_r1[15:0];
assign din_imag			= din_r1[31:16];
assign gain_s			= gain_r1;

// Product.
assign prod_real		= din_real*gain_s;
assign prod_imag		= din_imag*gain_s;

// Rounding.
assign prod_real_round	= prod_real[30 -: 16];
assign prod_imag_round	= prod_imag[30 -: 16];
assign prod				= {prod_imag_round,prod_real_round};

// Registers.
always @(posedge clk) begin
	if (~rstn) begin
		// Input registers.
		din_r1	<= 0;
		gain_r1	<= 0;
		
		// Rounding.
		prod_r1	<= 0;

		// last pipe.
		last_r1	<= 0;
		last_r2	<= 0;
	end
	else begin
		// Input registers.
		din_r1	<= din;
		gain_r1	<= gain;
		
		// Rounding.
		prod_r1	<= prod;

		// last pipe.
		last_r1	<= din_last;
		last_r2	<= last_r1;
	end
end 

// Assign outputs.
assign dout			= prod_r1;
assign dout_last	= last_r2;

endmodule


module punct
	#(
		// Number of bits.
		parameter	B = 32	,
	
		// Number of transactions.
		parameter 	N = 16
	)
	(
		// Reset and clock.
		input 	wire 			rstn		,
		input 	wire 			clk			,

		// Input data.
		input	wire			din_valid	,
		input	wire	[B-1:0]	din			,
		input	wire			din_last	,

		// Output data.
		output	wire			dout_valid	,
		output	wire	[B-1:0]	dout		,
		output 	wire			dout_last	,

		// Registers.
		input	wire	[31:0]	PUNCT_REG
	);

/*************/
/* Internals */
/*************/;

// Pipeline registers.
reg				valid_r1	;
reg				valid_r2	;
reg		[B-1:0]	din_r1		;
reg		[B-1:0]	din_r2		;
reg				last_r1		;
reg				last_r2		;

// Counter.
reg		[4:0]	cnt			;

// Flag.
wire			sel			;

// Registers.
reg 	[31:0]	PUNCT_REG_r	;

/****************/
/* Architecture */
/****************/

// Flag.
assign sel = PUNCT_REG_r [cnt];

always @(posedge clk) begin
	if (~rstn) begin
		// Pipeline registers.
		valid_r1	<= 0;
		valid_r2	<= 0;
		din_r1		<= 0;
		din_r2		<= 0;
		last_r1		<= 0;
		last_r2		<= 0;

		// Counter.
		cnt			<= 0;

		// Registers.
		PUNCT_REG_r	<= 0;
	end
	else begin
		// Pipeline registers.
		valid_r1	<= din_valid;
		valid_r2	<= valid_r1;
		din_r1		<= din;
		din_r2		<= din_r1;
		last_r1		<= din_last;
		last_r2		<= last_r1;

		// Counter.
		if ( valid_r2 == 1'b1 )
			if ( last_r2 == 1'b1 )
				cnt	<= 0;
			else
				if (cnt < N-1)
					cnt <= cnt + 1;
				else
					cnt <= 0;

		// Registers.
		PUNCT_REG_r	<= PUNCT_REG;

	end
end

// Assign outputs.
assign dout_valid 	= valid_r2;
assign dout			= (sel == 1'b1)? din_r2 : 0;
assign dout_last	= last_r2;


endmodule

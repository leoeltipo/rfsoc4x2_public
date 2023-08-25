module tb();

parameter	B = 8		;
parameter 	N = 7		;

// Reset and clock.
reg 		rstn		;
reg 		clk			;

// Input data.
reg			din_valid	;
reg	[B-1:0]	din			;
reg			din_last	;

// Output data.
wire		dout_valid	;
wire[B-1:0]	dout		;
wire		dout_last	;

// Registers.
reg  [31:0]	PUNCT_REG	;

// DUT.
punct
	#(
		.B(B),
		.N(N)
	)
	DUT
	(
		// Reset and clock.
		.rstn		,
		.clk		,

		// Input data.
		.din_valid	,
		.din		,
		.din_last	,

		// Output data.
		.dout_valid	,
		.dout		,
		.dout_last	,

		// Registers.
		.PUNCT_REG
	);

// Main TB.
initial begin
	int n;

	rstn		<= 0;
	PUNCT_REG	<= 32'hffff_0017;
	din_valid	<= 0;
	din			<= 0;
	din_last	<= 0;
	#300;
	rstn		<= 1;

	n = 0;
	while (1) begin
		for (int i=0; i<N-1; i=i+1) begin
			@(posedge clk);
			din_valid	<= 1;	
			din			<= $random;
			din_last	<= 0;
		end
		@(posedge clk);
		din_valid	<= 1;
		din			<= $random;
		din_last	<= 1;
	end
end

always begin
	clk <= 0;
	#5;
	clk <= 1;
	#5;
end  

endmodule


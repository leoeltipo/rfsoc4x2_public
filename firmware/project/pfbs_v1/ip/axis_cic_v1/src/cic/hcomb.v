module hcomb
	#(
		parameter NCH 	= 16,
		parameter B		= 8
	)
	(
		// Reset and clock.
		input wire 			rstn		,
		input wire 			clk			,
	
		// Data input.
		input wire [B-1:0] 	din			,
		input wire 			din_last	,
		input wire			din_valid	,

		// Data output.
		output wire [B-1:0]	dout		,
		output wire 		dout_last	,
		output wire			dout_valid
	);

/*************/
/* Internals */
/*************/
// Memory size (bits).
localparam N = $clog2(NCH);

// Input pipeline registers.
reg	 [B-1:0]	din_r1;
reg				din_last_r1;
reg				din_last_r2;
reg				din_valid_r1;
reg				din_valid_r2;

// Memory data.
wire [B-1:0]	mem_dout;

// Memory address.
reg	 [N-1:0]	addr;

// Input/output.
wire signed [B-1:0] xn,yn;

// Delayed input.
reg  signed [B-1:0] xn_d;

// Output pipeline registers.
reg	 [B-1:0]	dout_r1;

/****************/
/* Architecture */
/****************/
// Input data.
assign xn = din_r1;

// Adder.
assign yn = xn - xn_d;

// Memory.
bram_sp_rf
	#(
		.N(N	),
		.B(B	)
	)
	mem_i
	(
        .clk	(clk			),
        .en		(din_valid_r1	),
        .we		(din_valid_r1	),
        .addr	(addr			),
        .din	(xn				),
        .dout	(mem_dout		)
    );

always @(posedge clk) begin
	if (rstn == 1'b0) begin
		// Input pipeline registers.
		din_r1			<= 0;
		din_last_r1		<= 0;
		din_last_r2		<= 0;
		din_valid_r1	<= 0;
		din_valid_r2	<= 0;

		// Memory address.
		addr 			<= 0;

		// Delayed input.
		xn_d			<= 0;

		// Output pipeline registers.
		dout_r1			<= 0;
	end
	else begin
		// Input pipeline registers.
		din_r1			<= din;
		din_last_r1		<= din_last;
		din_last_r2		<= din_last_r1;
		din_valid_r1	<= din_valid;
		din_valid_r2	<= din_valid_r1;

		// Memory address.
		if (din_valid_r1 == 1'b1)
			if (addr == NCH-3)
				addr 		<= 0;
			else
				addr <= addr + 1;

		// Delayed input.
		if (din_valid_r1 == 1'b1)
			xn_d <= mem_dout;

		// Output pipeline registers.
		dout_r1			<= yn;
	end
end

// Assign outputs.
assign dout 		= dout_r1;
assign dout_last	= din_last_r2;
assign dout_valid	= din_valid_r2;

endmodule


module hint
	#(
		parameter NCH 	= 16,
		parameter B		= 8
	)
	(
		// Reset and clock.
		input wire 			rstn		,
		input wire 			clk			,

		// Data input.
		input wire [B-1:0]	din			,
		input wire 			din_last	,

		// Data output.
		output wire [B-1:0]	dout		,
		output wire 		dout_last	,
		
		// Registers.
		input wire			RST_REG
	);

/*************/
/* Internals */
/*************/
// Memory size (bits).
localparam N = $clog2(NCH);

// Input pipe registers.
reg	 [B-1:0]	din_r1;
reg				din_last_r1;
reg				din_last_r2;

// Memory address.
reg	 [N-1:0]	addr;

// Memory initialization.
wire			RST_REG_resync;

// Memory data.
wire [B-1:0]	mem_din;
wire [B-1:0]	mem_dout;

// Input/output.
wire signed [B-1:0] xn,yn;
reg  signed [B-1:0]	yn_r1;

// Delayed output.
reg  signed [B-1:0] yn_d;

// Output pipe registers.
reg	 [B-1:0]	dout_r1;

/****************/
/* Architecture */
/****************/
// Memory initialization.
assign mem_din = (RST_REG_resync == 1'b1)? 0 : yn_r1;

// Input data.
assign xn = din_r1;

// Adder.
assign yn = xn + yn_d;

// RST_REG_resync.
synchronizer_n RST_REG_resync_i
	(
		.rstn	    (rstn			),
		.clk 		(clk			),
		.data_in	(RST_REG		),
		.data_out	(RST_REG_resync	)
	);

// Memory.
bram_sp_rf
	#(
		.N(N	),
		.B(B	)
	)
	mem_i
	(
        .clk	(clk		),
        .en		(1'b1		),
        .we		(1'b1		),
        .addr	(addr		),
        .din	(mem_din	),
        .dout	(mem_dout	)
    );

always @(posedge clk) begin
	if (rstn == 1'b0) begin
		// Input pipe registers.
		din_r1		<= 0;
		din_last_r1	<= 0;
		din_last_r2	<= 0;

		// Memory address.
		addr 		<= 0;

		// Output.
		yn_r1		<= 0;

		// Delayed output.
		yn_d		<= 0;

		// Output pipe registers.
		dout_r1		<= 0;
	end
	else begin
		// Input pipe registers.
		din_r1		<= din;
		din_last_r1	<= din_last;
		din_last_r2	<= din_last_r1;

		// Memory address.
		if (addr == NCH-4) begin
			addr 		<= 0;
		end 
		else
			addr <= addr + 1;

		// Output.
		yn_r1		<= yn;

		// Delayed output.
		yn_d		<= mem_dout;

		// Output pipe registers.
		dout_r1		<= yn;
	end
end

// Assign outputs.
assign dout 		= dout_r1;
assign dout_last	= din_last_r2;

endmodule


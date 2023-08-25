module gdec
	(
		rstn		,
		clk			,
		din			,
		din_last	,
		dout		,
		dout_last	,
		dout_valid	,
		D_REG

	);

/**************/
/* Parameters */
/**************/
parameter NCH 	= 16;
parameter B		= 8;

/*********/
/* Ports */
/*********/
input			rstn;
input			clk;
input [B-1:0]	din;
input			din_last;
output[B-1:0]	dout;
output			dout_last;
output			dout_valid;
input [7:0]		D_REG;

/*************/
/* Internals */
/*************/
// Decimation register.
wire [7:0]	dreg_int;
reg  [7:0]	dreg_r;

// Channel counter.
reg	 [9:0]	cnt_ch;

// Decimation counter.
wire		cnt_d_en;
reg	 [7:0]	cnt_d;

/****************/
/* Architecture */
/****************/
// Decimation register.
assign dreg_int = (D_REG < 2)? 2 : D_REG;

// Decimation counter.
assign cnt_d_en	= (cnt_ch == NCH-1)? 1'b1 : 1'b0;

always @(posedge clk) begin
	if (rstn == 1'b0) begin
		// Decimation register.
		dreg_r	<= 0;

		// Channel counter.
		cnt_ch	<= 0;

		// Decimation counter.
		cnt_d	<= 0;
	end
	else begin
		// Decimation register.
		dreg_r	<= dreg_int;

		// Channel counter.
		if (cnt_ch == NCH-1)
			cnt_ch	<= 0;
		else
			cnt_ch	<= cnt_ch + 1;

		// Decimation counter.
		if (cnt_d_en == 1'b1)
			if (cnt_d == dreg_r-1)
				cnt_d	<= 0;
			else
				cnt_d	<= cnt_d + 1;
	end
end

// Assign outputs.
assign dout 		= din;
assign dout_last	= din_last;
assign dout_valid	= (cnt_d == 0)? 1'b1 : 0;

endmodule


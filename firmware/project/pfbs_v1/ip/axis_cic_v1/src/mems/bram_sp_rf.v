module bram_sp_rf
	(
        clk		,
        en		,
        we		,
        addr	,
        din		,
        dout
    );

/**************/
/* Parameters */
/**************/
parameter N = 4;
parameter B	= 8;

/*********/
/* Ports */
/*********/
input 			clk		;
input 			en		;
input 			we		;
input  [N-1:0] 	addr	;
input  [B-1:0] 	din		;
output [B-1:0]	dout	;

/*************/
/* Internals */
/*************/
(* ram_style = "block" *) reg	[B-1:0] ram [0:2**N-1];
reg	[B-1:0] dor;

always @(posedge clk) begin
	if (en) begin
		dor <= ram[addr];
		if (we)
			ram[addr] <= din;
	end
end

assign dout = dor;

endmodule


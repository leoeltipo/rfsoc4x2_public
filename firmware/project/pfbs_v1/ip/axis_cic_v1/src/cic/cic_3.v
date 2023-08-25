/*
 * Cascaded CIC filter implementation with 3 stages.
 */
module cic_3
	#(
		// Number of channels.
		parameter NCH 	= 16,


		// Number of bits.
		parameter B		= 8	,

		// Number of pipeline registers.
		parameter NPIPE	= 2
	)
	(
		// Reset and clock.
		input wire 			rstn		,
		input wire 			clk			,

		// Data input.
		input wire [B-1:0] 	din			,
		input wire 			din_last	,

		// Data output.
		output wire [B-1:0]	dout		,
		output wire 		dout_last	,
		output wire			dout_valid	,

		// Registers.
		input wire			RST_REG		,
		input wire [7:0]	D_REG
	);

/*************/
/* Internals */
/*************/
// Data input latency.
wire	[B-1:0]	din_la;
wire			din_last_la;

// Integrator outputs.
wire	[B-1:0]	hint0_dout;
wire			hint0_last;
wire	[B-1:0]	hint1_dout;
wire			hint1_last;
wire	[B-1:0]	hint2_dout;
wire			hint2_last;

// Integrator latenccy.
wire	[B-1:0]	hint0_dout_la;
wire			hint0_last_la;
wire	[B-1:0]	hint1_dout_la;
wire			hint1_last_la;
wire	[B-1:0]	hint2_dout_la;
wire			hint2_last_la;

// Group decimator outputs.
wire	[B-1:0]	gdec_dout;
wire			gdec_last;
wire			gdec_valid;

// Group decimator latency.
wire	[B-1:0]	gdec_dout_la;
wire			gdec_last_la;
wire			gdec_valid_la;

// Comb outputs.
wire	[B-1:0]	hcomb0_dout;
wire			hcomb0_last;
wire			hcomb0_valid;
wire	[B-1:0]	hcomb1_dout;
wire			hcomb1_last;
wire			hcomb1_valid;
wire	[B-1:0]	hcomb2_dout;
wire			hcomb2_last;
wire			hcomb2_valid;

// Comb latency.
wire	[B-1:0]	hcomb0_dout_la;
wire			hcomb0_last_la;
wire			hcomb0_valid_la;
wire	[B-1:0]	hcomb1_dout_la;
wire			hcomb1_last_la;
wire			hcomb1_valid_la;
wire	[B-1:0]	hcomb2_dout_la;
wire			hcomb2_last_la;
wire			hcomb2_valid_la;

// Mux for by-pass (D=1).
wire	[B-1:0]	mux_dout;
wire			mux_last;
wire			mux_valid;

/****************/
/* Architecture */
/****************/

// din_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	din_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn	),
		.clk	(clk	),

		// Data input.
		.din	(din	),

		// Data output.
		.dout	(din_la	)
	);

// din_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	din_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(din_last		),

		// Data output.
		.dout	(din_last_la	)
	);

// TDM Integrator.
hint
    #(
        .NCH(NCH),
        .B	(B	)
    )
    hint0_i
	( 
		.rstn		(rstn			),
        .clk   		(clk			),
        .din    	(din_la			),
		.din_last	(din_last_la	),
        .dout		(hint0_dout		),
		.dout_last	(hint0_last		),
		.RST_REG	(RST_REG		)
    );

// hint0_dout_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	hint0_dout_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hint0_dout		),

		// Data output.
		.dout	(hint0_dout_la	)
	);

// hint0_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hint0_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hint0_last		),

		// Data output.
		.dout	(hint0_last_la	)
	);

// TDM Integrator.
hint
    #(
        .NCH(NCH),
        .B	(B	)
    )
    hint1_i
	( 
		.rstn		(rstn			),
        .clk   		(clk			),
        .din    	(hint0_dout_la	),
		.din_last	(hint0_last_la	),
        .dout		(hint1_dout		),
		.dout_last	(hint1_last		),
		.RST_REG	(RST_REG		)
    );

// hint1_dout_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	hint1_dout_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hint1_dout		),

		// Data output.
		.dout	(hint1_dout_la	)
	);

// hint1_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hint1_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hint1_last		),

		// Data output.
		.dout	(hint1_last_la	)
	);

// TDM Integrator.
hint
    #(
        .NCH(NCH),
        .B	(B	)
    )
    hint2_i
	( 
		.rstn		(rstn			),
        .clk   		(clk			),
        .din    	(hint1_dout_la	),
		.din_last	(hint1_last_la	),
        .dout		(hint2_dout		),
		.dout_last	(hint2_last		),
		.RST_REG	(RST_REG		)
    );

// hint2_dout_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	hint2_dout_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hint2_dout		),

		// Data output.
		.dout	(hint2_dout_la	)
	);

// hint2_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hint2_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hint2_last		),

		// Data output.
		.dout	(hint2_last_la	)
	);

// TDM Decimator.
gdec
    #(
        .NCH(NCH),
        .B	(B	)
    )
    gdec_i
	( 
		.rstn		(rstn			),
        .clk   		(clk			),
        .din    	(hint2_dout_la	),
		.din_last	(hint2_last_la	),
        .dout		(gdec_dout		),
		.dout_last	(gdec_last		),
		.dout_valid	(gdec_valid		),
		.D_REG		(D_REG			)
    );

// gdec_dout_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	gdec_dout_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(gdec_dout		),

		// Data output.
		.dout	(gdec_dout_la	)
	);

// gdec_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	gdec_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(gdec_last		),

		// Data output.
		.dout	(gdec_last_la	)
	);

// gdec_valid_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	gdec_valid_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(gdec_valid		),

		// Data output.
		.dout	(gdec_valid_la	)
	);

// TDM Comb
hcomb
    #(
        .NCH(NCH),
        .B	(B	)
    )
    hcomb0_i
	( 
		.rstn		(rstn			),
        .clk   		(clk			),
        .din    	(gdec_dout_la	),
		.din_last	(gdec_last_la	),
		.din_valid	(gdec_valid_la	),
        .dout		(hcomb0_dout	),
		.dout_last	(hcomb0_last	),
		.dout_valid	(hcomb0_valid	)
    );

// hcomb0_dout_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	hcomb0_dout_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hcomb0_dout	),

		// Data output.
		.dout	(hcomb0_dout_la	)
	);

// hcomb0_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hcomb0_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hcomb0_last	),

		// Data output.
		.dout	(hcomb0_last_la	)
	);

// hcomb0_valid_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hcomb0_valid_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn				),
		.clk	(clk				),

		// Data input.
		.din	(hcomb0_valid		),

		// Data output.
		.dout	(hcomb0_valid_la	)
	);

// TDM Comb
hcomb
    #(
        .NCH(NCH),
        .B	(B	)
    )
    hcomb1_i
	( 
		.rstn		(rstn				),
        .clk   		(clk				),
        .din		(hcomb0_dout_la		),
		.din_last	(hcomb0_last_la		),
		.din_valid	(hcomb0_valid_la	),
        .dout		(hcomb1_dout		),
		.dout_last	(hcomb1_last		),
		.dout_valid	(hcomb1_valid		)
    );

// hcomb1_dout_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	hcomb1_dout_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hcomb1_dout	),

		// Data output.
		.dout	(hcomb1_dout_la	)
	);

// hcomb1_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hcomb1_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hcomb1_last	),

		// Data output.
		.dout	(hcomb1_last_la	)
	);

// hcomb1_valid_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hcomb1_valid_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn				),
		.clk	(clk				),

		// Data input.
		.din	(hcomb1_valid		),

		// Data output.
		.dout	(hcomb1_valid_la	)
	);

// TDM Comb
hcomb
    #(
        .NCH(NCH),
        .B	(B	)
    )
    hcomb2_i
	( 
		.rstn		(rstn				),
        .clk   		(clk				),
        .din		(hcomb1_dout_la		),
		.din_last	(hcomb1_last_la		),
		.din_valid	(hcomb1_valid_la	),
        .dout		(hcomb2_dout		),
		.dout_last	(hcomb2_last		),
		.dout_valid	(hcomb2_valid		)
    );

// hcomb2_dout_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(B	)
	)
	hcomb2_dout_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hcomb2_dout	),

		// Data output.
		.dout	(hcomb2_dout_la	)
	);

// hcomb2_last_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hcomb2_last_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn			),
		.clk	(clk			),

		// Data input.
		.din	(hcomb2_last	),

		// Data output.
		.dout	(hcomb2_last_la	)
	);

// hcomb2_valid_latency_reg
latency_reg
	#(
		// Latency.
		.N(NPIPE),

		// Data width.
		.B(1	)
	)
	hcomb2_valid_latency_reg_i
	(
		// Reset and clock.
		.rstn	(rstn				),
		.clk	(clk				),

		// Data input.
		.din	(hcomb2_valid		),

		// Data output.
		.dout	(hcomb2_valid_la	)
	);

// Mux for by-pass (D=1).
assign mux_dout		= (D_REG == 1)? din_la 		: hcomb2_dout_la;
assign mux_last		= (D_REG == 1)? din_last_la	: hcomb2_last_la;
assign mux_valid	= (D_REG == 1)? 1'b1		: hcomb2_valid_la;

// Assign outputs.
assign dout			= mux_dout;
assign dout_last	= mux_last;
assign dout_valid	= mux_valid;

endmodule


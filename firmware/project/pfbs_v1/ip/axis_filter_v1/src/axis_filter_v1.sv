module axis_filter_v1
	#(
		// Number of lanes/channels.
		parameter L	= 8		,
		parameter N = 256	,

		// Bits.
		parameter B = 32
	)
	( 	
		// AXI Slave I/F for configuration.
		input	wire  				s_axi_aclk		,
		input 	wire  				s_axi_aresetn	,

		input 	wire	[7:0]		s_axi_awaddr	,
		input 	wire 	[2:0]		s_axi_awprot	,
		input 	wire  				s_axi_awvalid	,
		output	wire  				s_axi_awready	,

		input 	wire 	[31:0] 		s_axi_wdata		,
		input 	wire 	[3:0]		s_axi_wstrb		,
		input 	wire  				s_axi_wvalid	,
		output 	wire  				s_axi_wready	,

		output 	wire 	[1:0]		s_axi_bresp		,
		output 	wire  				s_axi_bvalid	,
		input 	wire  				s_axi_bready	,

		input 	wire 	[7:0] 		s_axi_araddr	,
		input 	wire 	[2:0] 		s_axi_arprot	,
		input 	wire  				s_axi_arvalid	,
		output 	wire  				s_axi_arready	,

		output 	wire 	[31:0] 		s_axi_rdata		,
		output 	wire 	[1:0]		s_axi_rresp		,
		output 	wire  				s_axi_rvalid	,
		input 	wire  				s_axi_rready	,

		// Reset and clock for axis_*.
		input 	wire 				aresetn			,
		input 	wire 				aclk			,

		// s_axis_* for input.
		input	wire				s_axis_tvalid	,
		input	wire	[B*L-1:0]	s_axis_tdata	,
		input	wire				s_axis_tlast	,

		// m_axis_* for output.
		output	wire				m_axis_tvalid	,
		output	wire	[B*L-1:0]	m_axis_tdata	,
		output	wire				m_axis_tlast
	);

/********************/
/* Internal signals */
/********************/
// Number of transactions.
localparam NT 	= N/L;

// Data input vector.
wire	[B-1:0]	din_v		[L]	;

// Data output vector.
wire	[L-1:0]	dout_valid		;
wire	[B-1:0]	dout_v		[L]	;
wire	[L-1:0]	dout_last		;

// Registers.
wire 	[31:0]	PUNCT0_REG		;
wire 	[31:0]	PUNCT1_REG		;
wire 	[31:0]	PUNCT2_REG		;
wire 	[31:0]	PUNCT3_REG		;
wire 	[31:0]	PUNCT4_REG		;
wire 	[31:0]	PUNCT5_REG		;
wire 	[31:0]	PUNCT6_REG		;
wire 	[31:0]	PUNCT7_REG		;
wire	[31:0]	punct_reg_v	[L]	;

/**********************/
/* Begin Architecture */
/**********************/
// AXI Slave.
axi_slv axi_slv_i
	(
		.s_axi_aclk		(s_axi_aclk	  	),
		.s_axi_aresetn	(s_axi_aresetn	),

		// Write Address Channel.
		.s_axi_awaddr	(s_axi_awaddr	),
		.s_axi_awprot	(s_axi_awprot	),
		.s_axi_awvalid	(s_axi_awvalid	),
		.s_axi_awready	(s_axi_awready	),

		// Write Data Channel.
		.s_axi_wdata	(s_axi_wdata	),
		.s_axi_wstrb	(s_axi_wstrb	),
		.s_axi_wvalid	(s_axi_wvalid	),
		.s_axi_wready	(s_axi_wready	),

		// Write Response Channel.
		.s_axi_bresp	(s_axi_bresp	),
		.s_axi_bvalid	(s_axi_bvalid	),
		.s_axi_bready	(s_axi_bready	),

		// Read Address Channel.
		.s_axi_araddr	(s_axi_araddr	),
		.s_axi_arprot	(s_axi_arprot	),
		.s_axi_arvalid	(s_axi_arvalid	),
		.s_axi_arready	(s_axi_arready	),

		// Read Data Channel.
		.s_axi_rdata	(s_axi_rdata	),
		.s_axi_rresp	(s_axi_rresp	),
		.s_axi_rvalid	(s_axi_rvalid	),
		.s_axi_rready	(s_axi_rready	),

		// Registers.
		.PUNCT0_REG		(PUNCT0_REG		),
		.PUNCT1_REG		(PUNCT1_REG		),
		.PUNCT2_REG		(PUNCT2_REG		),
		.PUNCT3_REG		(PUNCT3_REG		),
		.PUNCT4_REG		(PUNCT4_REG		),
		.PUNCT5_REG		(PUNCT5_REG		),
		.PUNCT6_REG		(PUNCT6_REG		),
		.PUNCT7_REG		(PUNCT7_REG		)
	);

// Registers to vector.
assign punct_reg_v[0] = PUNCT0_REG;
assign punct_reg_v[1] = PUNCT1_REG;
assign punct_reg_v[2] = PUNCT2_REG;
assign punct_reg_v[3] = PUNCT3_REG;
assign punct_reg_v[4] = PUNCT4_REG;
assign punct_reg_v[5] = PUNCT5_REG;
assign punct_reg_v[6] = PUNCT6_REG;
assign punct_reg_v[7] = PUNCT7_REG;

genvar i;
generate
	for (i=0; i<L; i=i+1) begin : GEN_punct
		// Punct Block.
		punct
			#(
				// Number of bits.
				.B(B),
			
				// Number of transactions.
				.N(NT)
			)
			punct_i
			(
				// Reset and clock.
				.rstn		(aresetn			),
				.clk		(aclk				),
		
				// Input data.
				.din_valid	(s_axis_tvalid		),
				.din		(din_v			[i]	),
				.din_last	(s_axis_tlast		),
		
				// Output data.
				.dout_valid	(dout_valid		[i]	),
				.dout		(dout_v			[i]	),
				.dout_last	(dout_last		[i]	),
		
				// Registers.
				.PUNCT_REG	(punct_reg_v	[i]	)
			);

		// Data input vector
		assign din_v		[i]			= s_axis_tdata [i*B +: B];

		// Data output vector.
		assign m_axis_tdata [i*B +: B]	= dout_v[i]	;

	end
endgenerate

// Assign outputs.
assign m_axis_tvalid 	= dout_valid[0];
assign m_axis_tlast		= dout_last[0];

endmodule


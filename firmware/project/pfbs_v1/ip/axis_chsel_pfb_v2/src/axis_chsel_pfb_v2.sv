module axis_chsel_pfb_v2
	#(
		// Number of bits of complex word.
		parameter B		= 16	,

		// Number of channels.
		parameter NCH	= 4096	,

		// Number of lanes.
		parameter L		= 8
	)
	( 	
		// AXI Slave I/F for configuration.
		input wire  				s_axi_aclk		,
		input wire  				s_axi_aresetn	,

		input wire [7:0]			s_axi_awaddr	,
		input wire [2:0]			s_axi_awprot	,
		input wire  				s_axi_awvalid	,
		output wire  				s_axi_awready	,

		input wire [31:0] 			s_axi_wdata		,
		input wire [3:0]			s_axi_wstrb		,
		input wire  				s_axi_wvalid	,
		output wire  				s_axi_wready	,

		output wire [1:0]			s_axi_bresp		,
		output wire  				s_axi_bvalid	,
		input wire  				s_axi_bready	,

		input wire [7:0] 			s_axi_araddr	,
		input wire [2:0] 			s_axi_arprot	,
		input wire  				s_axi_arvalid	,
		output wire  				s_axi_arready	,

		output wire [31:0] 			s_axi_rdata		,
		output wire [1:0]			s_axi_rresp		,
		output wire  				s_axi_rvalid	,
		input wire  				s_axi_rready	,

		// Reset and clock for axis_*.
		input 	wire 				aresetn			,
		input 	wire 				aclk			,

		// s_axis_* for input.
		input	wire				s_axis_tvalid	,
		input	wire				s_axis_tlast	,
		input	wire	[B*L-1:0]	s_axis_tdata	,

		// m_axis_* for output.
		output	wire				m_axis_tvalid	,
		output	wire	[B*L-1:0]	m_axis_tdata	,
		output	wire	[15:0]		m_axis_tuser
	);

/********************/
/* Internal signals */
/********************/

// Number of TDM transactions per frame.
localparam NT 		= NCH/L;

// Number of memory locations (each location contains 32 bits).
localparam NM		= NT/32;
localparam NM_LOG2	= $clog2(NM);

// Registers.
wire					START_REG	;
wire	[NM_LOG2-1:0]	ADDR_REG	;
wire	[31:0]			DATA_REG	;
wire					WE_REG		;

// Memory.
wire					mem_wea		;
wire	[31:0]			mem_addra	;
wire	[31:0]			mem_dia		;
wire	[31:0]			mem_addrb	;
wire	[31:0]			mem_dob		;

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
		.START_REG		(START_REG		),
		.ADDR_REG		(ADDR_REG		),
		.DATA_REG		(DATA_REG		),
		.WE_REG			(WE_REG			)
	);

// Packet puncturing block.
punct
	#(
		.B	(B*L),
		.NT	(NT	)
	)
	punct_i
	(
		// Reset and clock.
		.aresetn		(aresetn		),
		.aclk			(aclk			),

		// Memory interface.
		.mem_addr		(mem_addrb		),
		.mem_do			(mem_dob		),

    	// S_AXIS for data input.
		.s_axis_tvalid	(s_axis_tvalid	),
		.s_axis_tlast	(s_axis_tlast	),
		.s_axis_tdata	(s_axis_tdata	),

		// M_AXIS for data output.
		.m_axis_tvalid	(m_axis_tvalid	),
		.m_axis_tdata	(m_axis_tdata	),
		.m_axis_tuser	(m_axis_tuser	),

		// Registers.
		.START_REG		(START_REG		)
	);

// Memory writer block.
memw_ctrl
	#(
		.B(32		),
		.N(NM_LOG2	)
	)
	memw_ctrl_i
	(
		// Reset and clock.
		.aresetn		(s_axi_aresetn	),
		.aclk			(s_axi_aclk		),

		// Memory interface.
		.mem_we			(mem_wea		),
		.mem_addr		(mem_addra		),
		.mem_di			(mem_dia		),

		// Registers.
		.ADDR_REG		(ADDR_REG		),
		.DATA_REG		(DATA_REG		),
		.WE_REG			(WE_REG			)
	);

// BRAM instance.
bram_dp
    #(
        // Memory address size.
        .N(NM_LOG2	),
        // Data width.
        .B(32		)
    )
	bram_dp_i
    ( 
		.clka  	(s_axi_aclk	),
        .clkb   (aclk		),
        .ena    (1'b1		),
        .enb    (1'b1		),
        .wea    (mem_wea	),
        .web    (1'b0		),
        .addra  (mem_addra	),
        .addrb  (mem_addrb	),
        .dia    (mem_dia	),
        .dib    (0			),
        .doa    (			),
        .dob    (mem_dob	)
    );


endmodule


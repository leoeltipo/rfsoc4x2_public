// This block integrates a multi-lane, TDM 3rd order CIC.
// Input data is fixed to 16-bit for I and 16-bit for Q.
// Multi-lane expects IQ to be interleaved between channels.
//
// Q[L-1] I[L-1] .. Q[1] I[1] Q[0] I[0].
//
// Given the input width and CIC characteristics, the output
// data width is 40-bit for I and 40-bit for Q on the CIC filter.
// There is a Quantization Block that converts back to 16-bit
// for I and 16-bit for Q.
//
// NOTE: the block is to be connected to a "always valid" data
// stream. As such, it is not possible to drop s_axis_tvalid
// as the block won't use this to stop the processing. At the
// output, however, m_axis_tvalid should be used as the block
// performs decimation and then only a portion of the packets
// will be valid. Framing is done by using s_axis_tlast for 
// sync. Output m_axis_tlast is honored, too. Finally, back
// pressure is not possible by using m_axis_tready.

module axis_cic
	#(
		// Number of Lanes.
		parameter L 	= 4	,

		// Number of Channels.
		parameter NCH 	= 16
    )
	( 
		// AXI Slave I/F.
		input	wire				s_axi_aclk		,
		input	wire				s_axi_aresetn	,

		// Write Address Channel.
		input	wire	[5:0]		s_axi_awaddr	,
		input	wire	[2:0]		s_axi_awprot	,
		input	wire				s_axi_awvalid	,
		output	wire				s_axi_awready	,

		// Write Data Channel.
		input	wire	[31:0]		s_axi_wdata		,
		input	wire	[3:0]		s_axi_wstrb		,
		input	wire				s_axi_wvalid	,
		output	wire				s_axi_wready	,

		// Write Response Channel.
		output	wire	[1:0]		s_axi_bresp		,
		output	wire				s_axi_bvalid	,
		input	wire				s_axi_bready	,

		// Read Address Channel.
		input	wire	[5:0]		s_axi_araddr	,
		input	wire	[2:0]		s_axi_arprot	,
		input	wire				s_axi_arvalid	,
		output	wire				s_axi_arready	,

		// Read Data Channel.
		output	wire	[31:0]		s_axi_rdata		,
		output	wire	[1:0]		s_axi_rresp		,
		output	wire				s_axi_rvalid	,
		input	wire				s_axi_rready	,

		// Reset and clock of AXIS I/Fs.
		input	wire				aresetn			,
		input	wire				aclk			,

		// Slave AXIS I/F for input data.
		input	wire	[32*L-1:0]	s_axis_tdata	,
		input	wire				s_axis_tlast	,
		input	wire				s_axis_tvalid	,
		output	wire				s_axis_tready	,

		// Master AXIS I/F for output data.
		output	wire	[32*L-1:0]	m_axis_tdata	,
		output	wire				m_axis_tlast	,
		output	wire				m_axis_tvalid
	);

/*************/
/* Internals */
/*************/
// Number of bits of memory address map.
localparam NCH_LOG2 = $clog2(NCH);


// Registers.
wire					CIC_RST_REG			;
wire	[7:0]			CIC_D_REG			;
wire	[31:0]			QDATA_QSEL_REG		;

// Data vectors.
wire	[31:0]			din_v		[L]		;
wire	[31:0]			dout_v		[L]		;

// last/valid.
wire	[L-1:0]			last_i				;
wire	[L-1:0]			valid_i				;

// AXI Slave.
axi_slv axi_slv_i
	(
		.aclk				(s_axi_aclk	 		),
		.aresetn			(s_axi_aresetn		),

		// Write Address Channel.
		.awaddr				(s_axi_awaddr 		),
		.awprot				(s_axi_awprot 		),
		.awvalid			(s_axi_awvalid		),
		.awready			(s_axi_awready		),

		// Write Data Channel.
		.wdata				(s_axi_wdata 		),
		.wstrb				(s_axi_wstrb 		),
		.wvalid				(s_axi_wvalid 		),
		.wready				(s_axi_wready 		),

		// Write Response Channel.
		.bresp				(s_axi_bresp		),
		.bvalid				(s_axi_bvalid		),
		.bready				(s_axi_bready		),

		// Read Address Channel.
		.araddr				(s_axi_araddr 		),
		.arprot				(s_axi_arprot 		),
		.arvalid			(s_axi_arvalid		),
		.arready			(s_axi_arready		),

		// Read Data Channel.
		.rdata				(s_axi_rdata 		),
		.rresp				(s_axi_rresp 		),
		.rvalid				(s_axi_rvalid		),
		.rready				(s_axi_rready		),

		// Registers.
		.CIC_RST_REG		(CIC_RST_REG		),
		.CIC_D_REG			(CIC_D_REG			),
		.QDATA_QSEL_REG		(QDATA_QSEL_REG		)
	);

// Generate.
genvar i;
generate
	for (i=0; i<L; i++) begin : GEN_lane
		// Input/output data.
		assign din_v[i]						= s_axis_tdata[i*32 +: 32];
		assign m_axis_tdata[i*32 +: 32] 	= dout_v[i];
	
		// TDM-muxed DDS + up-conversion + down-conversion.
		cic_top
			#(
				// Number of channels.
				.NCH		(NCH),

				// Number of CIC pipeline registers.
				.NPIPE_CIC	(2	)
			)
			cic_top_i
			(
				// Reset and clock.
				.rstn			(aresetn		),
				.clk			(aclk			),
		
				// Input data.
				.din			(din_v		[i]	),
				.din_last		(s_axis_tlast	),
		
				// Output data.
				.dout			(dout_v		[i]	),
				.dout_last		(last_i		[i]	),
				.dout_valid		(valid_i	[i]	),
		
				// Registers.
				.CIC_RST_REG	(CIC_RST_REG	),
				.CIC_D_REG		(CIC_D_REG		),
				.QDATA_QSEL_REG	(QDATA_QSEL_REG	)
			);
	end	    
endgenerate

// Assign outputs.
assign s_axis_tready	= 1'b1;
assign m_axis_tlast		= last_i	[0];
assign m_axis_tvalid	= valid_i	[0];

endmodule


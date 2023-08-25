// This block integrates the TDM-muxed DDS and 3rd order CIC.
// Input data is fixed to 16-bit for I and 16-bit for Q.
// Multi-lane expects IQ to be interleaved between channels.
//
// Q[L-1] I[L-1] .. Q[1] I[1] Q[0] I[0].
//
// Given the input width and CIC characteristics, the output
// data width is 40-bit for I and 40-bit for Q on the CIC filter.
// There is a Quantization Block that converts back tto 16-bit
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

module axis_dds_dual
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

		// Slave AXIS I/F for input data (from ADC).
		input	wire	[32*L-1:0]	s0_axis_tdata	,
		input	wire				s0_axis_tlast	,
		input	wire				s0_axis_tvalid	,

		// Master AXIS I/F for output data (to DAC).
		output	wire	[32*L-1:0]	m0_axis_tdata	,
		output	wire				m0_axis_tlast	,
		output	wire				m0_axis_tvalid	,

		// Master AXIS I/F for output data (down-converted).
		output	wire	[32*L-1:0]	m1_axis_tdata	,
		output	wire				m1_axis_tlast	,
		output	wire				m1_axis_tvalid
	);

/*************/
/* Internals */
/*************/
// Number of bits of memory address map.
localparam NCH_LOG2 = $clog2(NCH);


// Registers.
wire	[31:0]			ADDR_NCHAN_REG		;
wire	[31:0]			ADDR_PINC_REG		;
wire	[31:0]			ADDR_PHASE_REG		;
wire	[15:0]			ADDR_DDS_GAIN_REG	;
wire	[31:0]			ADDR_COMP_GAIN_REG	;
wire	[7:0]			ADDR_CFG_REG		;
wire					ADDR_WE_REG			;
wire					DDS_SYNC_REG		;

// Internal decoded signals.
wire	[31:0]			nchan_i				;
wire	[L-1:0]			we_i				;


// Memory signals.
wire	[NCH_LOG2-1:0]	mem_addra			;
wire	[127:0]			mem_dia				;
wire	[NCH_LOG2-1:0]	mem_addrb 	[L]		;
wire	[127:0]			mem_dob		[L]		;

// Data vectors.
wire	[31:0]			data_in_v	[L]		;
wire	[31:0]			dc_dout_v	[L]		;
wire	[31:0]			uc_dout_v	[L]		;

// Internal tlast.
wire	[L-1:0]			dc_last_i			;
wire	[L-1:0]			uc_last_i			;

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
		.ADDR_NCHAN_REG		(ADDR_NCHAN_REG		),
		.ADDR_PINC_REG		(ADDR_PINC_REG		),
		.ADDR_PHASE_REG		(ADDR_PHASE_REG		),
		.ADDR_DDS_GAIN_REG	(ADDR_DDS_GAIN_REG	),
		.ADDR_COMP_GAIN_REG	(ADDR_COMP_GAIN_REG	),
		.ADDR_CFG_REG		(ADDR_CFG_REG		),
		.ADDR_WE_REG		(ADDR_WE_REG		),
		.DDS_SYNC_REG		(DDS_SYNC_REG		)
	);

// Address decode block.
addr_decode
    #(
		// Number of Lanes.
		.L(L)
    )
	addr_decode_i
	( 
		// Reset and clock.
		.rstn   	(s_axi_aresetn	),
		.clk		(s_axi_aclk		),

		// Outputs.
		.nchan		(nchan_i		),
		.we			(we_i			),

		// Registers.
		.NCHAN_REG	(ADDR_NCHAN_REG	),
		.WE_REG		(ADDR_WE_REG	)
	);

// Memory address/data.
assign mem_addra = nchan_i[NCH_LOG2-1:0];
assign mem_dia	= {	{8{1'b0}}			,
					ADDR_CFG_REG 		, 
					ADDR_COMP_GAIN_REG	,
					ADDR_DDS_GAIN_REG	,
					ADDR_PHASE_REG		,
					ADDR_PINC_REG		};

// Generate.
genvar i;
generate
	for (i=0; i<L; i++) begin : GEN_lane
		// Input data (high: Q, low: I).
		assign data_in_v[i]					= s0_axis_tdata[i*32 +: 32];
	
		// Output data (up-converted).
		assign m0_axis_tdata[i*32 +: 32] 	= uc_dout_v[i];
	
		// Output data (down-converted).
		assign m1_axis_tdata[i*32 +: 32] 	= dc_dout_v[i];
		
		// TDM-muxed DDS + up-conversion + down-conversion.
		dds_top
			#(
				.NCH(NCH)
			)
			dds_top_i
			(
				// Reset and clock.
				.rstn			(aresetn		),
				.clk			(aclk			),
		
				// Memory interface.
				.mem_addr		(mem_addrb	[i]	),
				.mem_do			(mem_dob	[i]	),
		
				// Input data.
				.din			(data_in_v	[i]	),
				.din_last		(s0_axis_tlast	),
		
				// Output down-converted data.
				.dout_dc		(dc_dout_v	[i]	),
				.dout_dc_last	(dc_last_i	[i]	),
		
				// Output up-converted data.
				.dout_uc		(uc_dout_v	[i]	),
				.dout_uc_last	(uc_last_i	[i]	),
		
				// Registers.
				.SYNC_REG		(DDS_SYNC_REG	)
			);
	
		// Dual-port, dual-clock bram.
		bram_dp
		    #(
		        // Memory address size.
		        .N(NCH_LOG2	),
		        // Data width.
		        .B(128		)
		    )
			bram_dp_i
			(
				// Port A.
		        .clka    (s_axi_aclk	),
		        .ena     (1'b1			),
		        .wea     (we_i		[i]	),
		        .addra   (mem_addra		),
		        .dia     (mem_dia		),
		        .doa     (				),
	
				// Port B.
		        .clkb    (aclk			),
		        .enb     (1'b1			),
		        .web     (1'b0			),
		        .addrb   (mem_addrb	[i]	),
		        .dib     ({128{1'b0}}	),
		        .dob     (mem_dob	[i]	)
		    );
	end	    
endgenerate

// Assign outputs.
assign m0_axis_tlast	= uc_last_i[0];
assign m0_axis_tvalid	= 1'b1;
assign m1_axis_tlast	= dc_last_i[0];
assign m1_axis_tvalid	= 1'b1;

endmodule


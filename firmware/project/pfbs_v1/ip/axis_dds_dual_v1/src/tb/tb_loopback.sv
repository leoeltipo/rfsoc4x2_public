import axi_vip_pkg::*;
import axi_mst_0_pkg::*;

module tb();

// DUT generics.
parameter L 	= 4;
parameter NCH 	= 4;

reg						s_axi_aclk		;
reg						s_axi_aresetn	;
wire 	[5:0]			s_axi_araddr	;
wire 	[2:0]			s_axi_arprot	;
wire					s_axi_arready	;
wire					s_axi_arvalid	;
wire 	[5:0]			s_axi_awaddr	;
wire 	[2:0]			s_axi_awprot	;
wire					s_axi_awready	;
wire					s_axi_awvalid	;
wire					s_axi_bready	;
wire 	[1:0]			s_axi_bresp		;
wire					s_axi_bvalid	;
wire 	[31:0]			s_axi_rdata		;
wire					s_axi_rready	;
wire 	[1:0]			s_axi_rresp		;
wire					s_axi_rvalid	;
wire 	[31:0]			s_axi_wdata		;
wire					s_axi_wready	;
wire 	[3:0]			s_axi_wstrb		;
wire					s_axi_wvalid	;

reg						aresetn			;
reg						aclk			;

// Slave AXIS I/F for input data (from ADC).
wire [32*L-1:0]			s0_axis_tdata	;
reg						s0_axis_tlast	;
reg						s0_axis_tvalid	;

// Master AXIS I/F for output data (to DAC).
wire [32*L-1:0]			m0_axis_tdata	;
wire					m0_axis_tlast	;
wire					m0_axis_tvalid	;

// Master AXIS I/F for output data (down-converted).
wire [32*L-1:0]			m1_axis_tdata	;
wire					m1_axis_tlast	;
wire					m1_axis_tvalid	;

// Delayed data for aligning s0/m0.
reg	 [32*L-1:0]			axis_tdata_r1	;
reg						axis_tlast_r1	;

xil_axi_prot_t  prot        = 0;
reg[31:0]       data;
xil_axi_resp_t  resp;

// TDM demux.
reg						sync_demux					;

// down-converted.
wire [31:0]				dc_demux_din_v 	[L]			;
wire [NCH*32-1:0]		dc_demux_dout_v [L]			;
wire [L-1:0]			dc_demux_valid				;
wire signed [15:0]		dc_real_ii 		[L][NCH]	;
wire signed [15:0]		dc_imag_ii 		[L][NCH]	;

// AXI Master.
axi_mst_0 axi_mst_0_i
	(
		.aclk			(s_axi_aclk		),
		.aresetn		(s_axi_aresetn	),
		.m_axi_araddr	(s_axi_araddr	),
		.m_axi_arprot	(s_axi_arprot	),
		.m_axi_arready	(s_axi_arready	),
		.m_axi_arvalid	(s_axi_arvalid	),
		.m_axi_awaddr	(s_axi_awaddr	),
		.m_axi_awprot	(s_axi_awprot	),
		.m_axi_awready	(s_axi_awready	),
		.m_axi_awvalid	(s_axi_awvalid	),
		.m_axi_bready	(s_axi_bready	),
		.m_axi_bresp	(s_axi_bresp	),
		.m_axi_bvalid	(s_axi_bvalid	),
		.m_axi_rdata	(s_axi_rdata	),
		.m_axi_rready	(s_axi_rready	),
		.m_axi_rresp	(s_axi_rresp	),
		.m_axi_rvalid	(s_axi_rvalid	),
		.m_axi_wdata	(s_axi_wdata	),
		.m_axi_wready	(s_axi_wready	),
		.m_axi_wstrb	(s_axi_wstrb	),
		.m_axi_wvalid	(s_axi_wvalid	)
	);

axis_dds_dual
    #(
		// Number of Lanes.
		.L	(L	),

		// Number of Channels.
		.NCH(NCH)
    )
	DUT
	( 
		// AXI Slave I/F.
		.s_axi_aclk		(s_axi_aclk		),
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

		// Reset and clock of AXIS I/Fs.
		.aresetn		(aresetn		),
		.aclk			(aclk			),

		// Slave AXIS I/F for input data (from ADC).
		.s0_axis_tdata	(s0_axis_tdata	),
		.s0_axis_tlast	(s0_axis_tlast	),
		.s0_axis_tvalid	(s0_axis_tvalid	),

		// Master AXIS I/F for output data (to DAC).
		.m0_axis_tdata	(m0_axis_tdata	),
		.m0_axis_tlast	(m0_axis_tlast	),
		.m0_axis_tvalid	(m0_axis_tvalid	),

		// Master AXIS I/F for output data (down-converted).
		.m1_axis_tdata	(m1_axis_tdata	),
		.m1_axis_tlast	(m1_axis_tlast	),
		.m1_axis_tvalid	(m1_axis_tvalid	)
	);

// Input data (loop-back).
assign s0_axis_tdata = axis_tdata_r1;

genvar i,j;
generate
	for (i=0; i<L; i = i+1) begin : gen_demux
		for (j=0; j<NCH; j=j+1) begin
			// down-converted.
			assign dc_real_ii[i][j] = dc_demux_dout_v[i][2*j*16 	+: 16];
			assign dc_imag_ii[i][j] = dc_demux_dout_v[i][(2*j+1)*16 +: 16];
		end

		// TDM demux down-converted.
		tdm_demux
		    #(
		        .NCH(NCH),
		        .B	(32	)
		    )
			dc_tdm_demux_i
			(
				// Reset and clock.
				.rstn		(aresetn			),
				.clk		(aclk				),
		
				// Resync.
				.sync		(sync_demux			),
		
				// Data input.
				.din		(dc_demux_din_v[i]	),
				.din_last	(m1_axis_tlast		),
				.din_valid	(m1_axis_tvalid		),
		
				// Data output.
				.dout		(dc_demux_dout_v[i]	),
				.dout_valid	(dc_demux_valid[i]	)
			);

		// TDM demux down-converted.
		assign dc_demux_din_v[i] = m1_axis_tdata[32*i +: 32];
	end
endgenerate

// VIP Agents
axi_mst_0_mst_t 	axi_mst_0_agent;

// Main TB.
initial begin
	// Frequency vector for DDSs.
    real 	freq_v[L*NCH];

	// Compensation gain.
    real 	compi_v[L*NCH];
    real 	compq_v[L*NCH];

	// Output selection vector.
	integer outsel_v[L*NCH];

	// Create agents.
	axi_mst_0_agent 	= new("axi_mst_0 VIP Agent",tb.axi_mst_0_i.inst.IF);

	// Set tag for agents.
	axi_mst_0_agent.set_agent_tag("axi_mst_0 VIP");

	// Start agents.
	axi_mst_0_agent.start_master();

	// Reset sequence.
	s_axi_aresetn 		<= 0;
	aresetn 			<= 0;
	#500;
	s_axi_aresetn 		<= 1;
	aresetn 			<= 1;

	#1000;
	
	$display("###############################");
	$display("### Program DDS Frequencies ###");
	$display("###############################");
	$display("t = %0t", $time);

	// Initialize vectors.
	for (int i=0; i<L*NCH; i=i+1) begin
		freq_v	[i]	= 0;
		compi_v	[i]	= 0;
		compq_v	[i]	= 0;
		outsel_v[i] = 3; // output 0 value.
	end

	// Set some DDS frequencies (MHz).
	freq_v	[1]	= 0.234;
	outsel_v[1] = 8'b00000101;	// DDS.
	freq_v	[5]	= 0.234;
	compi_v	[5] = 0.972;
	compq_v	[5] = 0.233;
	//I = 19447
	//Q = -4658
	//Icomp = 31866
	//Qcomp = 7632
	outsel_v[5] = 8'b00000000;	// Product.

	sync_demux <= 1;

	// DDS_SYNC_REG: force SYNC while programming frequencies.
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*7, prot, 1, resp);
	#10;

	for (int i=0; i<NCH; i = i+1) begin
		for (int j=0; j<L; j = j+1) begin
			// ADDR_NCHAN_REG
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*0, prot, L*i+j, resp);
			#10;

			// ADDR_PINC_REG
			data = freq_calc(100, NCH, freq_v[L*i+j]);
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*1, prot, data, resp);
			#10;

			// ADDR_PHASE_REG
			data = 100;
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*2, prot, data, resp);
			#10;

			// ADDR_DDS_GAIN_REG
			data = 20000;
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*3, prot, data, resp);
			#10;

			// ADDR_COMP_GAIN_REG
			data = {16'd7632, 16'd31866};
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*4, prot, data, resp);
			#10;

			// ADDR_CFG_REG
			data = outsel_v[L*i+j];
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*5, prot, data, resp);
			#10;
			
			// ADDR_WE_REG
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*6, prot, 1, resp);
			#10;	

			// ADDR_WE_REG
			axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*6, prot, 0, resp);
			#10;	
		end
	end

	// DDS_SYNC_REG.
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*7, prot, 0, resp);
	#10;

	sync_demux <= 0;
	
	#1000;
end

// TLAST generation.
initial begin
	s0_axis_tlast	<= 0;

	while(1) begin
		for (int i=0; i<NCH-1; i = i + 1) begin
			@(posedge aclk);
			s0_axis_tlast <= 0;
		end
		@(posedge aclk);
		s0_axis_tlast <= 1;
	end

end

always @(posedge aclk) begin
	axis_tdata_r1 <= m0_axis_tdata;
	axis_tlast_r1 <= m0_axis_tlast;
end

always begin
	s_axi_aclk <= 0;
	#10;
	s_axi_aclk <= 1;
	#10;
end

always begin
	aclk <= 0;
	#5;
	aclk <= 1;
	#5;
end  

// Function to compute frequency register.
function [31:0] freq_calc;
    input real fclk;
	input real nch;
    input real f;
    
	// All input frequencies are in MHz.
	real fclk_temp, temp;
	fclk_temp = fclk/nch;
	temp = f/fclk_temp*2**30;
	freq_calc = {int'(temp),2'b00};
endfunction

endmodule


import axi_vip_pkg::*;
import axi_mst_0_pkg::*;

module tb();

// DUT generics.
parameter L 	= 8;
parameter NCH 	= 18;

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

wire [32*L-1:0]			s_axis_tdata	;
reg						s_axis_tlast	;
reg						s_axis_tvalid	;
wire					s_axis_tready	;

wire [32*L-1:0]			m_axis_tdata	;
wire					m_axis_tlast	;
wire					m_axis_tvalid	;

xil_axi_prot_t  prot        = 0;
reg[31:0]       data;
xil_axi_resp_t  resp;

// Input data.
reg  [15:0]	data_in_real [L];
reg  [15:0]	data_in_imag [L];
// TDM demux for debugging.
reg						sync_demux		;
wire [31:0]				din_demux_v [L]	;
wire [NCH*32-1:0]		dout_demux_v [L];
wire [L-1:0]			valid_demux		;

wire signed [15:0]		dout_real_ii [L][NCH];
wire signed [15:0]		dout_imag_ii [L][NCH];

// TB Control.
reg tb_write_out = 0;

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

axis_cic
    #(
		// Number of Lanes.
		.L	(L		),

		// Number of Channels.
		.NCH(NCH	)

    )
	DUT
	( 
		// AXI Slave I/F.
		.s_axi_aclk		,
		.s_axi_aresetn	,

		// Write Address Channel.
		.s_axi_awaddr	,
		.s_axi_awprot	,
		.s_axi_awvalid	,
		.s_axi_awready	,

		// Write Data Channel.
		.s_axi_wdata	,
		.s_axi_wstrb	,
		.s_axi_wvalid	,
		.s_axi_wready	,

		// Write Response Channel.
		.s_axi_bresp	,
		.s_axi_bvalid	,
		.s_axi_bready	,

		// Read Address Channel.
		.s_axi_araddr	,
		.s_axi_arprot	,
		.s_axi_arvalid	,
		.s_axi_arready	,

		// Read Data Channel.
		.s_axi_rdata	,
		.s_axi_rresp	,
		.s_axi_rvalid	,
		.s_axi_rready	,

		// Reset and clock of AXIS I/Fs.
		.aresetn		,
		.aclk			,

		// Slave AXIS I/F for input data.
		.s_axis_tdata	,
		.s_axis_tlast	,
		.s_axis_tvalid	,
		.s_axis_tready	,

		// Master AXIS I/F for output data.
		.m_axis_tdata	,
		.m_axis_tlast	,
		.m_axis_tvalid
	);

genvar i,j;
generate
	for (i=0; i<L; i = i+1) begin : gen_demux
		for (j=0; j<NCH; j=j+1) begin
			assign dout_real_ii[i][j] = dout_demux_v[i][2*j*16 +: 16];
			assign dout_imag_ii[i][j] = dout_demux_v[i][(2*j+1)*16 +: 16];
		end
		// TDM demux.
		tdm_demux
		    #(
		        .NCH(NCH),
		        .B	(32	)
		    )
			tdm_demux_i
			(
				// Reset and clock.
				.rstn		(aresetn			),
				.clk		(aclk				),
		
				// Resync.
				.sync		(sync_demux			),
		
				// Data input.
				.din		(din_demux_v[i]		),
				.din_last	(m_axis_tlast		),
				.din_valid	(m_axis_tvalid		),
		
				// Data output.
				.dout		(dout_demux_v[i]	),
				.dout_valid	(valid_demux[i]		)
			);

		// Input data.
		assign s_axis_tdata [32*i +: 32] = {data_in_imag[i],data_in_real[i]};

		// TDM demux input data.
		assign din_demux_v[i] = m_axis_tdata[32*i +: 32];
	end
endgenerate

// VIP Agents
axi_mst_0_mst_t 	axi_mst_0_agent;

// Main TB.
initial begin
	// Frequency vector for DDSs.
    real freq_v[L*NCH];
	integer decimation;
	integer qsel;

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
	

	sync_demux <= 1;

	// CIC_RST_REG: force RST while initializing.
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*0, prot, 1, resp);
	#10;

	// CIC_D_REG.
	decimation = 7;
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*1, prot, decimation, resp);
	#10;

	// QDATA_QSEL_REG.
	qsel = 24 - 3*$clog2(decimation);
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*2, prot, qsel, resp);
	#10;

	#10000;

	// CIC_RST_REG.
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*0, prot, 0, resp);
	#10;

	sync_demux <= 0;
	
	#1000;
	
	tb_write_out <= 1;
end

// Input data generation.
initial begin
	// Frequency vector for DDSs.
    real freq_v[L*NCH];
	real fs;
	real pi;
	
	// Amplitudes.
	real a0_v[L*NCH];
	
	fs = 100/NCH;
	pi = 3.14159;


	s_axis_tvalid	<= 1;

	// Frequencies.
	for (int i=0; i<L*NCH; i=i+1) begin
		freq_v[i] 	= 0;
		a0_v[i] 	= 0;
	end

	// Set some input frequencies (MHz).
	freq_v[0] 	= 0.001;
	a0_v[0] 	= 0.5;
	freq_v[L] 	= 0.001;
	a0_v[L] 	= 0.5;
	
	// Send TDM data.
	// Each lane multiplex NCH channels. There are L*NCH total channels.
	// On each clock, I need to send L inputs. Channels are numbered as
	// follows (L=4, NCH=8):
	// 
	// L = 0 CH0 CH4 CH8  CH12 CH16 CH20 CH24 CH28 CH0 CH4 CH8  CH12 CH16 CH20 CH24 CH28 ..
	// L = 1 CH1 CH5 CH9  CH13 CH17 CH21 CH25 CH29 CH1 CH5 CH9  CH13 CH17 CH21 CH25 CH29 ..
	// L = 2 CH2 CH6 CH10 CH14 CH18 CH22 CH26 CH20 CH2 CH6 CH10 CH14 CH18 CH22 CH26 CH20 ..
	// L = 3 CH3 CH7 CH11 CH15 CH19 CH23 CH27 CH31 CH3 CH7 CH11 CH15 CH19 CH23 CH27 CH31 ..
	// last	 0   0   0    0    0    0    0    1    0   0   0    0    0    0    0    1    ..
	// 
	// As it can be seen, each lane has NCH multiplexed Channels.
	
	for (int n=0; n<100000; n=n+1) begin
		for (int i=0; i<NCH-1; i = i + 1) begin
				@(posedge aclk);
				s_axis_tlast <= 0;
				for (int j=0; j<L; j = j+1) begin
					data_in_real[j] <= a0_v[L*i+j]*(2**15-1)*$cos(2*pi*freq_v[L*i+j]/fs*n);
					data_in_imag[j] <= a0_v[L*i+j]*(2**15-1)*$sin(2*pi*freq_v[L*i+j]/fs*n);
				end
		end
		@(posedge aclk);
		s_axis_tlast <= 1;
		for (int j=0; j<L; j = j+1) begin
			data_in_real[j] <= a0_v[L*(NCH-1)+j]*(2**15-1)*$cos(2*pi*freq_v[L*(NCH-1)+j]/fs*n);
			data_in_imag[j] <= a0_v[L*(NCH-1)+j]*(2**15-1)*$sin(2*pi*freq_v[L*(NCH-1)+j]/fs*n);
		end
	end
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

endmodule


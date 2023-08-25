import axi_vip_pkg::*;
import axi_mst_0_pkg::*;

module tb();

// DUT generics.
parameter BDATA = 8;
parameter BUSER	= 2;

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

// s_axis_* for input.
reg 					s_axis_aresetn	;
reg 					s_axis_aclk		;
reg						s_axis_tvalid	;
wire					s_axis_tready	;
reg [BDATA-1:0]			s_axis_tdata	;
reg [BUSER-1:0]			s_axis_tuser	;

// m_axis_* for output.
reg 					m_axis_aresetn	;
reg 					m_axis_aclk		;
wire					m_axis_tvalid	;
reg						m_axis_tready	;
wire [BUSER+BDATA-1:0]	m_axis_tdata	;
wire					m_axis_tlast	;

xil_axi_prot_t  prot        = 0;
reg[31:0]       data;
xil_axi_resp_t  resp;

// TB control.
reg tb_data_in 	= 0;
reg tb_data_out = 0;

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

axis_streamer_v1
    #(
		.BDATA(BDATA),
		.BUSER(BUSER)
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

		// s_axis_* for input.
		.s_axis_aresetn	,
		.s_axis_aclk	,
		.s_axis_tvalid	,
		.s_axis_tready	,
		.s_axis_tdata	,
		.s_axis_tuser	,

		// m_axis_* for output.
		.m_axis_aresetn	,
		.m_axis_aclk	,
		.m_axis_tvalid	,
		.m_axis_tready	,
		.m_axis_tdata	,
		.m_axis_tlast
	);

// VIP Agents
axi_mst_0_mst_t 	axi_mst_0_agent;

// Main TB.
initial begin
	// Create agents.
	axi_mst_0_agent 	= new("axi_mst_0 VIP Agent",tb.axi_mst_0_i.inst.IF);

	// Set tag for agents.
	axi_mst_0_agent.set_agent_tag("axi_mst_0 VIP");

	// Start agents.
	axi_mst_0_agent.start_master();

	// Reset sequence.
	s_axi_aresetn 	<= 0;
	s_axis_aresetn 	<= 0;
	m_axis_aresetn 	<= 0;
	#500;
	s_axi_aresetn 	<= 1;
	s_axis_aresetn 	<= 1;
	m_axis_aresetn 	<= 1;

	#1000;
	
	// NSAMP_REG.
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*1, prot, 134, resp);
	#10;

	// START_REG.
	axi_mst_0_agent.AXI4LITE_WRITE_BURST(4*0, prot, 1, resp);
	#10;

	#200;
	
	tb_data_in <= 1;
	tb_data_out <= 1;
end

initial begin
	s_axis_tvalid	<= 0;
	s_axis_tdata	<= 0;
	s_axis_tuser	<= 0;

	wait (tb_data_in);

	for (int i=0; i<10000; i = i+1) begin
		for (int j=0; j<22; j=j+1) begin
			@(posedge s_axis_aclk);
			s_axis_tvalid 	<= 1;
			s_axis_tdata	<= $random;
			s_axis_tuser	<= j;
		end
		for (int j=0; j<8; j=j+1) begin
			@(posedge s_axis_aclk);
			s_axis_tvalid 	<= 0;
		end
		for (int j=0; j<57; j=j+1) begin
			@(posedge s_axis_aclk);
			s_axis_tvalid 	<= 1;
			s_axis_tdata	<= $random;
			s_axis_tuser	<= j+33;
		end
		for (int j=0; j<33; j=j+1) begin
			@(posedge s_axis_aclk);
			s_axis_tvalid 	<= 0;
		end
	end
end

initial begin
	m_axis_tready	<= 0;

	wait (tb_data_out);

	for (int i=0; i<10000; i = i+1) begin
		for (int j=0; j<220; j=j+1) begin
			@(posedge m_axis_aclk);
			m_axis_tready 	<= 1;
		end
		for (int j=0; j<89; j=j+1) begin
			@(posedge m_axis_aclk);
			m_axis_tready 	<= 1;
		end
		for (int j=0; j<57; j=j+1) begin
			@(posedge m_axis_aclk);
			m_axis_tready 	<= 1;
		end
		for (int j=0; j<33; j=j+1) begin
			@(posedge m_axis_aclk);
			m_axis_tready 	<= 1;
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
	s_axis_aclk <= 0;
	#7;
	s_axis_aclk <= 1;
	#7;
end  

always begin
	m_axis_aclk <= 0;
	#4;
	m_axis_aclk <= 1;
	#4;
end  

endmodule


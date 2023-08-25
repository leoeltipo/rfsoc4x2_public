module tb();

// DUT generics.
parameter BDATA = 8;
parameter BUSER	= 2;

// s_axis_* for input.
reg 			s_axis_aresetn	;
reg 			s_axis_aclk		;
reg				s_axis_tvalid	;
wire			s_axis_tready	;
reg [BDATA-1:0]	s_axis_tdata	;
reg [BUSER-1:0]	s_axis_tuser	;

// m_axis_* for output.
reg 			m_axis_aresetn	;
reg 			m_axis_aclk		;
wire			m_axis_tvalid	;
reg				m_axis_tready	;
wire [BDATA-1:0]m_axis_tdata	;
wire [BUSER-1:0]m_axis_tuser	;

// Registers.
reg				START_REG		;
reg	[31:0]		NSAMP_REG		;

// DUT.
streamer
	#(
		.BDATA(BDATA),
		.BUSER(BUSER)
	)
	DUT
	(
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
		.m_axis_tuser	,

		// Registers.
		.START_REG		,
		.NSAMP_REG
	);
	
// Main TB.
initial begin
	// Reset sequence.
	s_axis_aresetn 	<= 0;
	s_axis_tvalid	<= 0;
	s_axis_tdata	<= 0;
	s_axis_tuser	<= 0;
	m_axis_aresetn 	<= 0;
	m_axis_tready	<= 0;
	START_REG		<= 0;
	NSAMP_REG		<= 0;
	#500;
	s_axis_aresetn 	<= 1;
	m_axis_aresetn 	<= 1;

	#1000;

	// Configure block and start transfer mode.
	NSAMP_REG		<= 13;
	#20;
	START_REG		<= 1;

	#100;

	@(posedge m_axis_aclk);
	m_axis_tready	<= 1;

	@(posedge s_axis_aclk);
	s_axis_tvalid	<= 1;

	#2000;

	START_REG		<= 0;
	
end

always begin
	s_axis_aclk <= 0;
	#10;
	s_axis_aclk <= 1;
	#10;
end

always begin
	m_axis_aclk <= 0;
	#7;
	m_axis_aclk <= 1;
	#7;
end

endmodule


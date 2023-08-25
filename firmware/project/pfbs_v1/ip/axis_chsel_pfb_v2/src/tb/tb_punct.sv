module tb;

parameter B		= 8		;
parameter NT	= 256	;

// Reset and clock.
reg 			aresetn			;
reg 			aclk			;

// Memory interface.
wire 	[31:0]	mem_addr		;
wire 	[31:0]	mem_do			;

// S_AXIS for data input.
reg				s_axis_tvalid	;
reg				s_axis_tlast	;
reg		[B-1:0]	s_axis_tdata	;

// M_AXIS for data output.
wire			m_axis_tvalid	;
wire	[B-1:0]	m_axis_tdata	;
wire	[15:0]	m_axis_tuser	;

// Registers.
reg				START_REG		;

// Memory control.
reg				mem_wea			;
reg		[7:0]	mem_addra		;
reg		[31:0]	mem_dia			;

// DUT.
punct
	#(
		.B	(B	),
		.NT	(NT	)
	)
	DUT
	(
		// Reset and clock.
		.aresetn		,
		.aclk			,

		// Memory interface.
		.mem_addr		,
		.mem_do			,

    	// S_AXIS for data input.
		.s_axis_tvalid	,
		.s_axis_tlast	,
		.s_axis_tdata	,

		// M_AXIS for data output.
		.m_axis_tvalid	,
		.m_axis_tdata	,
		.m_axis_tuser	,

		// Registers.
		.START_REG
	);

// BRAM.
bram_dp
    #(
        // Memory address size.
        .N(8),
        // Data width.
        .B(32)
    )
    bram_i
	( 
		.clka	(aclk		),
		.clkb   (aclk		),
		.ena    (1'b1		),
		.enb    (1'b1		),
		.wea    (mem_wea	),
		.web    (1'b0		),
		.addra  (mem_addra	),
		.addrb  (mem_addr	),
		.dia    (mem_dia	),
		.dib    (0			),
		.doa    (			),
		.dob    (mem_do		)
    );

initial begin
	aresetn 		<= 0;
	s_axis_tvalid	<= 0;
	s_axis_tlast	<= 0;
	s_axis_tdata	<= 0;
	START_REG		<= 0;
	mem_wea			<= 0;
	mem_addra		<= 0;
	mem_dia			<= 0;
	#200;
	aresetn			<= 1;

	#100;

	// Initialize memory.
	for (int i=0; i<256; i++) begin
		@(posedge aclk);
		mem_wea		<= 1;
		mem_addra	<= i;	
		mem_dia		<= 0;
	end

	@(posedge aclk);
	mem_wea		<= 0;

	// Program some puncturing bits.
	@(posedge aclk);
	mem_wea		<= 1;
	mem_addra	<= 1;	
	mem_dia		<= 32'h0000_ffff;

	@(posedge aclk);
	mem_wea		<= 1;
	mem_addra	<= 7;	
	mem_dia		<= 32'haaaa_0001;

	@(posedge aclk);
	mem_wea		<= 0;

	// Start.
	START_REG		<= 1;

	#3000;

	while (1) begin
		for (int i=0; i<NT; i++) begin
			@(posedge aclk);
			s_axis_tvalid 	<= 1;
			s_axis_tdata	<= $random;
			if (i == NT-1)
				s_axis_tlast <= 1;
			else
				s_axis_tlast <= 0;
		end
		for (int i=0; i<100; i++) begin
			@(posedge aclk);
			s_axis_tvalid 	<= 1;
			s_axis_tdata	<= $random;
			s_axis_tlast 	<= 0;
		end
		for (int i=0; i<7; i++) begin
			@(posedge aclk);
			s_axis_tvalid 	<= 0;
		end
		for (int i=0; i<156; i++) begin
			@(posedge aclk);
			s_axis_tvalid 	<= 1;
			s_axis_tdata	<= $random;
			if (i == 155)
				s_axis_tlast <= 1;
			else
				s_axis_tlast <= 0;
		end
	end
end

always begin
	aclk <= 0;
	#5;
	aclk <= 1;
	#5;
end

endmodule


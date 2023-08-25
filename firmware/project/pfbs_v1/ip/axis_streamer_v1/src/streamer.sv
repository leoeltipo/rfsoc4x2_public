module streamer
	#(
		parameter BDATA	= 16	,
		parameter BUSER	= 8
	)
	(
		// s_axis_* for input.
		input 	wire 					s_axis_aresetn	,
		input 	wire 					s_axis_aclk		,
		input	wire					s_axis_tvalid	,
		output  wire					s_axis_tready	,
		input	wire [BDATA-1:0]		s_axis_tdata	,
		input	wire [BUSER-1:0]		s_axis_tuser	,

		// m_axis_* for output.
		input 	wire 					m_axis_aresetn	,
		input 	wire 					m_axis_aclk		,
		output	wire					m_axis_tvalid	,
		input   wire					m_axis_tready	,
		output	wire [BUSER+BDATA-1:0]	m_axis_tdata	,
		output  wire					m_axis_tlast	,

		// Registers.
		input	wire					START_REG		,
		input   wire [31:0]				NSAMP_REG
	);

/*************/
/* Internals */
/*************/
localparam BFIFO = BUSER + BDATA;
localparam NFIFO = 16;

// States.
typedef enum	{	INIT_ST	,
					RUN_ST
				} state_t;

// State register.
(* fsm_encoding = "one_hot" *) state_t state;

reg					init_state			;
reg					run_state			;

// Counter.
reg	 [31:0]			cnt					;

// Re-sync registers.
wire				START_REG_resync	;
reg	 [31:0]			NSAMP_REG_r			;

// Fifo signals.
wire				fifo_wr_en			;
wire [BFIFO-1:0]	fifo_din			;
wire				fifo_rd_en			;
wire [BFIFO-1:0]	fifo_dout			;
wire				fifo_full			;
wire				fifo_empty			;

// last.
wire				last_i				;

/****************/
/* Architecture */
/****************/
// START_REG_resync.
synchronizer_n SYNC_REG_resync_i
	(
		.rstn	    (m_axis_aresetn		),
		.clk 		(m_axis_aclk		),
		.data_in	(START_REG			),
		.data_out	(START_REG_resync	)
	);

// Dual-Clock FIFO.
fifo_dc_axi
    #(
        // Data width.
        .B	(BFIFO	),
        
        // Fifo depth.
        .N	(NFIFO	)
    )
    fifo_i
    ( 
        .wr_rstn	(s_axis_aresetn	),
        .wr_clk 	(s_axis_aclk	),

        .rd_rstn	(m_axis_aresetn	),
        .rd_clk 	(m_axis_aclk	),
        
        // Write I/F.
        .wr_en  	(fifo_wr_en		),
        .din     	(fifo_din		),
        
        // Read I/F.
        .rd_en  	(fifo_rd_en		),
        .dout   	(fifo_dout		),
        
        // Flags.
        .full    	(fifo_full		),
        .empty   	(fifo_empty		)
    );

// Fifo connections.
assign fifo_wr_en	= run_state & s_axis_tvalid;
assign fifo_din 	= {s_axis_tuser,s_axis_tdata};
assign fifo_rd_en	= run_state & m_axis_tready;

// last.
assign last_i		= (cnt == NSAMP_REG_r-1)? 1'b1 : 1'b0;

// Registers.
always @(posedge m_axis_aclk) begin
	if (~m_axis_aresetn) begin
		// State register.
		state 		<= INIT_ST;

		// Counter.
		cnt			<= 0;

		// Re-sync registers.
		NSAMP_REG_r	<= 0;
	end
	else begin
		// State register.
		case (state)
			INIT_ST:
				if (START_REG_resync == 1'b1)
					state <= RUN_ST;

			RUN_ST:
				// Check if while transferring last sample, the block needs to stop.
				if (cnt == NSAMP_REG_r-1 && fifo_empty == 1'b0 && m_axis_tready == 1'b1 && START_REG_resync == 1'b0)
					state <= INIT_ST;
		endcase

		// Counter.
		if (run_state == 1'b1 && fifo_empty == 1'b0 && m_axis_tready == 1'b1)
			if (cnt == NSAMP_REG_r-1)
				cnt <= 0;
			else
				cnt <= cnt + 1;

		// Re-sync registers.
		if (START_REG_resync == 1'b0)
			NSAMP_REG_r	<= NSAMP_REG;
	end
end 

// FSM outputs.
always_comb	begin
	// Default.
	init_state	= 0;
	run_state	= 0;

	case (state)
		INIT_ST:
			init_state 	= 1'b1;

		RUN_ST:
			run_state 	= 1'b1;
	endcase
end

// Assign outputs.
assign s_axis_tready	= ~fifo_full;
assign m_axis_tvalid	= ~fifo_empty;
assign m_axis_tdata		= fifo_dout;
assign m_axis_tlast		= last_i;

endmodule


module memw_ctrl
	#(
		parameter B	= 8	,
		parameter N	= 8
	)
	(
		// Reset and clock.
		input 	wire 				aresetn			,
		input 	wire 				aclk			,

		// Memory interface.
		output	wire				mem_we			,
		output	wire 	[N-1:0]		mem_addr		,
		output	wire 	[B-1:0]		mem_di			,

		// Registers.
		input	wire	[N-1:0]		ADDR_REG		,
		input	wire	[B-1:0]		DATA_REG		,
		input	wire				WE_REG
	);

/*************/
/* Internals */
/*************/
// States.
typedef enum	{	INIT_ST	,
					REGS_ST	,
					MEMW_ST	,
					WAIT_ST
				} state_t;

// State register.
(* fsm_encoding = "one_hot" *) state_t state;

reg				regs_state	;
reg				memw_state	;

// Registers.
reg		[N-1:0]	addr_r		;
reg		[B-1:0]	data_r		;

/****************/
/* Architecture */
/****************/

// Registers.
always @(posedge aclk) begin
	if (~aresetn) begin
		// State register.
		state 	<= INIT_ST;

		// Registers.
		addr_r	<= 0;
		data_r	<= 0;
	end
	else begin
		// State register.
		case (state)
			INIT_ST:
				if (WE_REG == 1'b1)
					state <= REGS_ST;

			REGS_ST:
				state <= MEMW_ST;

			MEMW_ST:
				state <= WAIT_ST;

			WAIT_ST:
				if (WE_REG == 1'b0)
					state <= INIT_ST;
		endcase

		// Registers.
		if (regs_state == 1'b1) begin
			addr_r	<= ADDR_REG;
			data_r	<= DATA_REG;
		end
	end
end 

// FSM outputs.
always_comb	begin
	// Default.
	regs_state	= 0;
	memw_state	= 0;

	case (state)
		//INIT_ST:

		REGS_ST:
			regs_state	= 1'b1;

		MEMW_ST:
			memw_state	= 1'b1;

		//WAIT_ST:
	endcase
end

// Assign outputs.
assign mem_we	= memw_state;
assign mem_addr	= addr_r	;
assign mem_di	= data_r	;

endmodule


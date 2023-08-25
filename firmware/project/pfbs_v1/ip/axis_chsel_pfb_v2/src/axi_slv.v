`timescale 1 ns / 1 ps

module axi_slv
	(
		input wire  				s_axi_aclk		,
		input wire  				s_axi_aresetn	,

		// Write Address Channel.
		input wire [7:0]			s_axi_awaddr	,
		input wire [2:0]			s_axi_awprot	,
		input wire  				s_axi_awvalid	,
		output wire  				s_axi_awready	,

		// Write Data Channel.
		input wire [31:0] 			s_axi_wdata		,
		input wire [3:0]			s_axi_wstrb		,
		input wire  				s_axi_wvalid	,
		output wire  				s_axi_wready	,

		// Write Response Channel.
		output wire [1:0]			s_axi_bresp		,
		output wire  				s_axi_bvalid	,
		input wire  				s_axi_bready	,

		// Read Address Channel.
		input wire [7:0] 			s_axi_araddr	,
		input wire [2:0] 			s_axi_arprot	,
		input wire  				s_axi_arvalid	,
		output wire  				s_axi_arready	,

		// Read Data Channel.
		output wire [31:0] 			s_axi_rdata		,
		output wire [1:0]			s_axi_rresp		,
		output wire  				s_axi_rvalid	,
		input wire  				s_axi_rready	,

		// Registers.
		output wire					START_REG		,
		output wire	[31:0]			ADDR_REG		,
		output wire	[31:0]			DATA_REG		,
		output wire					WE_REG
);

// Width of S_AXI data bus
localparam integer C_S_AXI_DATA_WIDTH	= 32;
// Width of S_AXI address bus
localparam integer C_S_AXI_ADDR_WIDTH	= 8;

// AXI4LITE signals
reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
reg  	axi_awready;
reg  	axi_wready;
reg [1 : 0] 	axi_bresp;
reg  	axi_bvalid;
reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
reg  	axi_arready;
reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
reg [1 : 0] 	axi_rresp;
reg  	axi_rvalid;

// Example-specific design signals
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 5;
//----------------------------------------------
//-- Signals for user logic register space example
//------------------------------------------------
//-- Number of Slave Registers 64
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg16;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg17;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg18;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg19;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg20;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg21;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg22;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg23;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg24;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg25;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg26;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg27;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg28;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg29;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg30;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg31;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg32;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg33;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg34;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg35;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg36;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg37;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg38;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg39;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg40;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg41;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg42;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg43;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg44;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg45;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg46;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg47;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg48;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg49;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg50;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg51;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg52;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg53;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg54;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg55;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg56;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg57;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg58;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg59;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg60;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg61;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg62;
reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg63;
wire	 slv_reg_rden;
wire	 slv_reg_wren;
reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
integer	 byte_index;
reg	 aw_en;

// I/O Connections assignments

assign s_axi_awready	= axi_awready;
assign s_axi_wready	= axi_wready;
assign s_axi_bresp	= axi_bresp;
assign s_axi_bvalid	= axi_bvalid;
assign s_axi_arready	= axi_arready;
assign s_axi_rdata	= axi_rdata;
assign s_axi_rresp	= axi_rresp;
assign s_axi_rvalid	= axi_rvalid;
// Implement axi_awready generation
// axi_awready is asserted for one s_axi_aclk clock cycle when both
// s_axi_awvalid and s_axi_wvalid are asserted. axi_awready is
// de-asserted when reset is low.

always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      axi_awready <= 1'b0;
      aw_en <= 1'b1;
    end 
  else
    begin    
      if (~axi_awready && s_axi_awvalid && s_axi_wvalid && aw_en)
        begin
          // slave is ready to accept write address when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_awready <= 1'b1;
          aw_en <= 1'b0;
        end
        else if (s_axi_bready && axi_bvalid)
            begin
              aw_en <= 1'b1;
              axi_awready <= 1'b0;
            end
      else           
        begin
          axi_awready <= 1'b0;
        end
    end 
end       

// Implement axi_awaddr latching
// This process is used to latch the address when both 
// s_axi_awvalid and s_axi_wvalid are valid. 

always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      axi_awaddr <= 0;
    end 
  else
    begin    
      if (~axi_awready && s_axi_awvalid && s_axi_wvalid && aw_en)
        begin
          // Write Address latching 
          axi_awaddr <= s_axi_awaddr;
        end
    end 
end       

// Implement axi_wready generation
// axi_wready is asserted for one s_axi_aclk clock cycle when both
// s_axi_awvalid and s_axi_wvalid are asserted. axi_wready is 
// de-asserted when reset is low. 

always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      axi_wready <= 1'b0;
    end 
  else
    begin    
      if (~axi_wready && s_axi_wvalid && s_axi_awvalid && aw_en )
        begin
          // slave is ready to accept write data when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_wready <= 1'b1;
        end
      else
        begin
          axi_wready <= 1'b0;
        end
    end 
end       

// Implement memory mapped register select and write logic generation
// The write data is accepted and written to memory mapped registers when
// axi_awready, s_axi_wvalid, axi_wready and s_axi_wvalid are asserted. Write strobes are used to
// select byte enables of slave registers while writing.
// These registers are cleared when reset (active low) is applied.
// Slave register write enable is asserted when valid address and data are available
// and the slave is ready to accept the write address and write data.
assign slv_reg_wren = axi_wready && s_axi_wvalid && axi_awready && s_axi_awvalid;

always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      slv_reg0 <= 0;
      slv_reg1 <= 0;
      slv_reg2 <= 0;
      slv_reg3 <= 0;
      slv_reg4 <= 0;
      slv_reg5 <= 0;
      slv_reg6 <= 0;
      slv_reg7 <= 0;
      slv_reg8 <= 0;
      slv_reg9 <= 0;
      slv_reg10 <= 0;
      slv_reg11 <= 0;
      slv_reg12 <= 0;
      slv_reg13 <= 0;
      slv_reg14 <= 0;
      slv_reg15 <= 0;
      slv_reg16 <= 0;
      slv_reg17 <= 0;
      slv_reg18 <= 0;
      slv_reg19 <= 0;
      slv_reg20 <= 0;
      slv_reg21 <= 0;
      slv_reg22 <= 0;
      slv_reg23 <= 0;
      slv_reg24 <= 0;
      slv_reg25 <= 0;
      slv_reg26 <= 0;
      slv_reg27 <= 0;
      slv_reg28 <= 0;
      slv_reg29 <= 0;
      slv_reg30 <= 0;
      slv_reg31 <= 0;
      slv_reg32 <= 0;
      slv_reg33 <= 0;
      slv_reg34 <= 0;
      slv_reg35 <= 0;
      slv_reg36 <= 0;
      slv_reg37 <= 0;
      slv_reg38 <= 0;
      slv_reg39 <= 0;
      slv_reg40 <= 0;
      slv_reg41 <= 0;
      slv_reg42 <= 0;
      slv_reg43 <= 0;
      slv_reg44 <= 0;
      slv_reg45 <= 0;
      slv_reg46 <= 0;
      slv_reg47 <= 0;
      slv_reg48 <= 0;
      slv_reg49 <= 0;
      slv_reg50 <= 0;
      slv_reg51 <= 0;
      slv_reg52 <= 0;
      slv_reg53 <= 0;
      slv_reg54 <= 0;
      slv_reg55 <= 0;
      slv_reg56 <= 0;
      slv_reg57 <= 0;
      slv_reg58 <= 0;
      slv_reg59 <= 0;
      slv_reg60 <= 0;
      slv_reg61 <= 0;
      slv_reg62 <= 0;
      slv_reg63 <= 0;
    end 
  else begin
    if (slv_reg_wren)
      begin
        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
          6'h00:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 0
                slv_reg0[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h01:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 1
                slv_reg1[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h02:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 2
                slv_reg2[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h03:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 3
                slv_reg3[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h04:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 4
                slv_reg4[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h05:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 5
                slv_reg5[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h06:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 6
                slv_reg6[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h07:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 7
                slv_reg7[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h08:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 8
                slv_reg8[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h09:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 9
                slv_reg9[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h0A:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 10
                slv_reg10[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h0B:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 11
                slv_reg11[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h0C:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 12
                slv_reg12[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h0D:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 13
                slv_reg13[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h0E:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 14
                slv_reg14[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h0F:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 15
                slv_reg15[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h10:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 16
                slv_reg16[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h11:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 17
                slv_reg17[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h12:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 18
                slv_reg18[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h13:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 19
                slv_reg19[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h14:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 20
                slv_reg20[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h15:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 21
                slv_reg21[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h16:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 22
                slv_reg22[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h17:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 23
                slv_reg23[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h18:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 24
                slv_reg24[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h19:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 25
                slv_reg25[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h1A:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 26
                slv_reg26[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h1B:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 27
                slv_reg27[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h1C:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 28
                slv_reg28[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h1D:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 29
                slv_reg29[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h1E:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 30
                slv_reg30[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h1F:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 31
                slv_reg31[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h20:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 32
                slv_reg32[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h21:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 33
                slv_reg33[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h22:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 34
                slv_reg34[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h23:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 35
                slv_reg35[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h24:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 36
                slv_reg36[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h25:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 37
                slv_reg37[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h26:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 38
                slv_reg38[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h27:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 39
                slv_reg39[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h28:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 40
                slv_reg40[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h29:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 41
                slv_reg41[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h2A:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 42
                slv_reg42[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h2B:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 43
                slv_reg43[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h2C:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 44
                slv_reg44[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h2D:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 45
                slv_reg45[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h2E:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 46
                slv_reg46[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h2F:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 47
                slv_reg47[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h30:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 48
                slv_reg48[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h31:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 49
                slv_reg49[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h32:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 50
                slv_reg50[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h33:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 51
                slv_reg51[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h34:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 52
                slv_reg52[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h35:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 53
                slv_reg53[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h36:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 54
                slv_reg54[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h37:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 55
                slv_reg55[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h38:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 56
                slv_reg56[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h39:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 57
                slv_reg57[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h3A:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 58
                slv_reg58[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h3B:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 59
                slv_reg59[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h3C:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 60
                slv_reg60[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h3D:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 61
                slv_reg61[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h3E:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 62
                slv_reg62[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          6'h3F:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( s_axi_wstrb[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 63
                slv_reg63[(byte_index*8) +: 8] <= s_axi_wdata[(byte_index*8) +: 8];
              end  
          default : begin
                      slv_reg0 <= slv_reg0;
                      slv_reg1 <= slv_reg1;
                      slv_reg2 <= slv_reg2;
                      slv_reg3 <= slv_reg3;
                      slv_reg4 <= slv_reg4;
                      slv_reg5 <= slv_reg5;
                      slv_reg6 <= slv_reg6;
                      slv_reg7 <= slv_reg7;
                      slv_reg8 <= slv_reg8;
                      slv_reg9 <= slv_reg9;
                      slv_reg10 <= slv_reg10;
                      slv_reg11 <= slv_reg11;
                      slv_reg12 <= slv_reg12;
                      slv_reg13 <= slv_reg13;
                      slv_reg14 <= slv_reg14;
                      slv_reg15 <= slv_reg15;
                      slv_reg16 <= slv_reg16;
                      slv_reg17 <= slv_reg17;
                      slv_reg18 <= slv_reg18;
                      slv_reg19 <= slv_reg19;
                      slv_reg20 <= slv_reg20;
                      slv_reg21 <= slv_reg21;
                      slv_reg22 <= slv_reg22;
                      slv_reg23 <= slv_reg23;
                      slv_reg24 <= slv_reg24;
                      slv_reg25 <= slv_reg25;
                      slv_reg26 <= slv_reg26;
                      slv_reg27 <= slv_reg27;
                      slv_reg28 <= slv_reg28;
                      slv_reg29 <= slv_reg29;
                      slv_reg30 <= slv_reg30;
                      slv_reg31 <= slv_reg31;
                      slv_reg32 <= slv_reg32;
                      slv_reg33 <= slv_reg33;
                      slv_reg34 <= slv_reg34;
                      slv_reg35 <= slv_reg35;
                      slv_reg36 <= slv_reg36;
                      slv_reg37 <= slv_reg37;
                      slv_reg38 <= slv_reg38;
                      slv_reg39 <= slv_reg39;
                      slv_reg40 <= slv_reg40;
                      slv_reg41 <= slv_reg41;
                      slv_reg42 <= slv_reg42;
                      slv_reg43 <= slv_reg43;
                      slv_reg44 <= slv_reg44;
                      slv_reg45 <= slv_reg45;
                      slv_reg46 <= slv_reg46;
                      slv_reg47 <= slv_reg47;
                      slv_reg48 <= slv_reg48;
                      slv_reg49 <= slv_reg49;
                      slv_reg50 <= slv_reg50;
                      slv_reg51 <= slv_reg51;
                      slv_reg52 <= slv_reg52;
                      slv_reg53 <= slv_reg53;
                      slv_reg54 <= slv_reg54;
                      slv_reg55 <= slv_reg55;
                      slv_reg56 <= slv_reg56;
                      slv_reg57 <= slv_reg57;
                      slv_reg58 <= slv_reg58;
                      slv_reg59 <= slv_reg59;
                      slv_reg60 <= slv_reg60;
                      slv_reg61 <= slv_reg61;
                      slv_reg62 <= slv_reg62;
                      slv_reg63 <= slv_reg63;
                    end
        endcase
      end
  end
end    

// Implement write response logic generation
// The write response and response valid signals are asserted by the slave 
// when axi_wready, s_axi_wvalid, axi_wready and s_axi_wvalid are asserted.  
// This marks the acceptance of address and indicates the status of 
// write transaction.

always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      axi_bvalid  <= 0;
      axi_bresp   <= 2'b0;
    end 
  else
    begin    
      if (axi_awready && s_axi_awvalid && ~axi_bvalid && axi_wready && s_axi_wvalid)
        begin
          // indicates a valid write response is available
          axi_bvalid <= 1'b1;
          axi_bresp  <= 2'b0; // 'OKAY' response 
        end                   // work error responses in future
      else
        begin
          if (s_axi_bready && axi_bvalid) 
            //check if bready is asserted while bvalid is high) 
            //(there is a possibility that bready is always asserted high)   
            begin
              axi_bvalid <= 1'b0; 
            end  
        end
    end
end   

// Implement axi_arready generation
// axi_arready is asserted for one s_axi_aclk clock cycle when
// s_axi_arvalid is asserted. axi_awready is 
// de-asserted when reset (active low) is asserted. 
// The read address is also latched when s_axi_arvalid is 
// asserted. axi_araddr is reset to zero on reset assertion.

always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      axi_arready <= 1'b0;
      axi_araddr  <= 32'b0;
    end 
  else
    begin    
      if (~axi_arready && s_axi_arvalid)
        begin
          // indicates that the slave has acceped the valid read address
          axi_arready <= 1'b1;
          // Read address latching
          axi_araddr  <= s_axi_araddr;
        end
      else
        begin
          axi_arready <= 1'b0;
        end
    end 
end       

// Implement axi_arvalid generation
// axi_rvalid is asserted for one s_axi_aclk clock cycle when both 
// s_axi_arvalid and axi_arready are asserted. The slave registers 
// data are available on the axi_rdata bus at this instance. The 
// assertion of axi_rvalid marks the validity of read data on the 
// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
// is deasserted on reset (active low). axi_rresp and axi_rdata are 
// cleared to zero on reset (active low).  
always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      axi_rvalid <= 0;
      axi_rresp  <= 0;
    end 
  else
    begin    
      if (axi_arready && s_axi_arvalid && ~axi_rvalid)
        begin
          // Valid read data is available at the read data bus
          axi_rvalid <= 1'b1;
          axi_rresp  <= 2'b0; // 'OKAY' response
        end   
      else if (axi_rvalid && s_axi_rready)
        begin
          // Read data is accepted by the master
          axi_rvalid <= 1'b0;
        end                
    end
end    

// Implement memory mapped register select and read logic generation
// Slave register read enable is asserted when valid address is available
// and the slave is ready to accept the read address.
assign slv_reg_rden = axi_arready & s_axi_arvalid & ~axi_rvalid;
always @(*)
begin
      // Address decoding for reading registers
      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
        6'h00   : reg_data_out <= slv_reg0;
        6'h01   : reg_data_out <= slv_reg1;
        6'h02   : reg_data_out <= slv_reg2;
        6'h03   : reg_data_out <= slv_reg3;
        6'h04   : reg_data_out <= slv_reg4;
        6'h05   : reg_data_out <= slv_reg5;
        6'h06   : reg_data_out <= slv_reg6;
        6'h07   : reg_data_out <= slv_reg7;
        6'h08   : reg_data_out <= slv_reg8;
        6'h09   : reg_data_out <= slv_reg9;
        6'h0A   : reg_data_out <= slv_reg10;
        6'h0B   : reg_data_out <= slv_reg11;
        6'h0C   : reg_data_out <= slv_reg12;
        6'h0D   : reg_data_out <= slv_reg13;
        6'h0E   : reg_data_out <= slv_reg14;
        6'h0F   : reg_data_out <= slv_reg15;
        6'h10   : reg_data_out <= slv_reg16;
        6'h11   : reg_data_out <= slv_reg17;
        6'h12   : reg_data_out <= slv_reg18;
        6'h13   : reg_data_out <= slv_reg19;
        6'h14   : reg_data_out <= slv_reg20;
        6'h15   : reg_data_out <= slv_reg21;
        6'h16   : reg_data_out <= slv_reg22;
        6'h17   : reg_data_out <= slv_reg23;
        6'h18   : reg_data_out <= slv_reg24;
        6'h19   : reg_data_out <= slv_reg25;
        6'h1A   : reg_data_out <= slv_reg26;
        6'h1B   : reg_data_out <= slv_reg27;
        6'h1C   : reg_data_out <= slv_reg28;
        6'h1D   : reg_data_out <= slv_reg29;
        6'h1E   : reg_data_out <= slv_reg30;
        6'h1F   : reg_data_out <= slv_reg31;
        6'h20   : reg_data_out <= slv_reg32;
        6'h21   : reg_data_out <= slv_reg33;
        6'h22   : reg_data_out <= slv_reg34;
        6'h23   : reg_data_out <= slv_reg35;
        6'h24   : reg_data_out <= slv_reg36;
        6'h25   : reg_data_out <= slv_reg37;
        6'h26   : reg_data_out <= slv_reg38;
        6'h27   : reg_data_out <= slv_reg39;
        6'h28   : reg_data_out <= slv_reg40;
        6'h29   : reg_data_out <= slv_reg41;
        6'h2A   : reg_data_out <= slv_reg42;
        6'h2B   : reg_data_out <= slv_reg43;
        6'h2C   : reg_data_out <= slv_reg44;
        6'h2D   : reg_data_out <= slv_reg45;
        6'h2E   : reg_data_out <= slv_reg46;
        6'h2F   : reg_data_out <= slv_reg47;
        6'h30   : reg_data_out <= slv_reg48;
        6'h31   : reg_data_out <= slv_reg49;
        6'h32   : reg_data_out <= slv_reg50;
        6'h33   : reg_data_out <= slv_reg51;
        6'h34   : reg_data_out <= slv_reg52;
        6'h35   : reg_data_out <= slv_reg53;
        6'h36   : reg_data_out <= slv_reg54;
        6'h37   : reg_data_out <= slv_reg55;
        6'h38   : reg_data_out <= slv_reg56;
        6'h39   : reg_data_out <= slv_reg57;
        6'h3A   : reg_data_out <= slv_reg58;
        6'h3B   : reg_data_out <= slv_reg59;
        6'h3C   : reg_data_out <= slv_reg60;
        6'h3D   : reg_data_out <= slv_reg61;
        6'h3E   : reg_data_out <= slv_reg62;
        6'h3F   : reg_data_out <= slv_reg63;
        default : reg_data_out <= 0;
      endcase
end

// Output register or memory read data
always @( posedge s_axi_aclk )
begin
  if ( s_axi_aresetn == 1'b0 )
    begin
      axi_rdata  <= 0;
    end 
  else
    begin    
      // When there is a valid read address (s_axi_arvalid) with 
      // acceptance of read address by the slave (axi_arready), 
      // output the read dada 
      if (slv_reg_rden)
        begin
          axi_rdata <= reg_data_out;     // register read data
        end   
    end
end    

assign START_REG	= slv_reg0[0];
assign ADDR_REG		= slv_reg1;
assign DATA_REG		= slv_reg2;
assign WE_REG		= slv_reg3[0];

endmodule

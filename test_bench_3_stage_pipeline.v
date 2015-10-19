`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: NTU
// Engineer:Dr. Smitha K G

// 
////////////////////////////////////////////////////////////////////////////////

module test_bench_3_stage_pipeline;

	// Inputs
	reg clk;
	reg rst;
	reg fileid;


	// Outputs
	wire [15:0] PCOUT;
	wire [15:0] INST;
	wire [15:0] rdata1;
	wire [15:0] rdata2;
	wire [15:0] rdata1_ID_EXE;
	wire [15:0] rdata2_ID_EXE;
	wire [15:0] imm_ID_EXE;
	wire [15:0] rdata2_imm_ID_EXE;
	wire [2:0] aluop_ID_EXE;
	wire alusrc_ID_EXE;
	wire [3:0] waddr_out_ID_EXE;
	wire [15:0] aluout;
   wire [3:0] waddr_out_ID_S4;
	wire [15:0] aluout_S4;
	// Instantiate the Unit Under Test (UUT)
	pipelined_regfile_3stage uut (
		.clk(clk), 
		.rst(rst), 
		.fileid(fileid), 
		.PCOUT(PCOUT), 
		.INST(INST), 
		.rdata1(rdata1), 
		.rdata2(rdata2), 
		.rdata1_ID_EXE(rdata1_ID_EXE), 
		.rdata2_ID_EXE(rdata2_ID_EXE), 
		.imm_ID_EXE(imm_ID_EXE), 
		.rdata2_imm_ID_EXE(rdata2_imm_ID_EXE), 
		.aluop_ID_EXE(aluop_ID_EXE),
		.alusrc_ID_EXE(alusrc_ID_EXE),
		.waddr_out_ID_EXE(waddr_out_ID_EXE), 
		.aluout(aluout),
		.waddr_out_ID_S4(waddr_out_ID_S4), 
		.aluout_S4(aluout_S4)
	);

always #15 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		fileid = 0;


		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
#25 rst =1;
#25 rst=0;


	end
      
endmodule


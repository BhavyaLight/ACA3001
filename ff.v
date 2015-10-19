`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:58:07 10/19/2015
// Design Name:   pipelined_regfile_3stage
// Module Name:   Y:/try/ff.v
// Project Name:  try
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipelined_regfile_3stage
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ff;

	// Inputs
	reg clk;
	reg rst;
	reg fileid;

	// Outputs
	wire [15:0] PCOUT;
	wire branch_ID_EXE;
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
	wire [3:0] waddr_out_EXE_DM;
	wire [15:0] aluout_EXE_DM;
	wire [15:0] rdata2_EXE_DM;
	wire branch_ID_EXE;
	wire regDst;
	wire memWrite_EXE_DM;
	wire memRead_EXE_DM;
	wire memToReg_EXE_DM;
	wire wen_DM_WB;
	wire [3:0] waddr_DM_WB;
	wire [15:0] aluout_DM_WB;
	wire [15:0] readMem;
	wire [15:0] aluout_DM;
	wire [15:0] aluout_WB;

	// Instantiate the Unit Under Test (UUT)
	pipelined_regfile_3stage uut (
		.clk(clk), 
		.rst(rst), 
		.fileid(fileid), 
		.PCOUT(PCOUT), 
		.branch_ID_EXE(branch_ID_EXE), 
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
		.waddr_out_EXE_DM(waddr_out_EXE_DM), 
		.aluout_EXE_DM(aluout_EXE_DM), 
		.rdata2_EXE_DM(rdata2_EXE_DM), 
		.branch_ID_EXE(branch_ID_EXE), 
		.regDst(regDst), 
		.memWrite_EXE_DM(memWrite_EXE_DM), 
		.memRead_EXE_DM(memRead_EXE_DM), 
		.memToReg_EXE_DM(memToReg_EXE_DM), 
		.wen_DM_WB(wen_DM_WB), 
		.waddr_DM_WB(waddr_DM_WB), 
		.aluout_DM_WB(aluout_DM_WB), 
		.readMem(readMem), 
		.aluout_DM(aluout_DM), 
		.aluout_WB(aluout_WB)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		fileid = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_3stage(clk, rst, fileid, PCOUT
,branch_ID_EXE, INST, rdata1, rdata2, rdata1_ID_EXE, rdata2_ID_EXE, imm_ID_EXE,rdata2_imm_ID_EXE,
 aluop_ID_EXE, alusrc_ID_EXE, waddr_out_ID_EXE,aluout, waddr_out_EXE_DM,aluout_EXE_DM,rdata2_EXE_DM,
,regDst,memWrite_EXE_DM,memRead_EXE_DM,memToReg_EXE_DM,wen_DM_WB,
 waddr_DM_WB,aluout_DM_WB,readMem,aluout_DM,aluout_WB);

input clk;				
											
input	rst;
input fileid; 

//Stage Fetch
output [`ISIZE-1:0]PCOUT; //
//Stage decode
output [`DSIZE-1:0]INST;  //
output [`DSIZE-1:0] rdata1;  //
output [`DSIZE-1:0] rdata2;  //
//Stage Execute
output [`DSIZE-1:0] rdata1_ID_EXE; //
output [`DSIZE-1:0] rdata2_ID_EXE; //
output [`DSIZE-1:0] imm_ID_EXE; //
output [`DSIZE-1:0] rdata2_imm_ID_EXE; //
output [`ASIZE-1:0] waddr_out_ID_EXE;	//
output [`DSIZE-1:0] aluout;	//
output [`DSIZE-1:0] rdata2_EXE_DM;			
//Stage DM
output [`ASIZE-1:0] waddr_out_EXE_DM; //	
output [`DSIZE-1:0] aluout_EXE_DM; //
output [`DSIZE-1:0] readMem;	//
output [`DSIZE-1:0] aluout_DM;//
output [`DSIZE-1:0] aluout_WB;//

//Write back
output [`ASIZE-1:0] waddr_DM_WB;//
output [`DSIZE-1:0] aluout_DM_WB;//
								
//Control Signal outputs
output branch_ID_EXE;//
output alusrc_ID_EXE;  //
output [2:0]aluop_ID_EXE; //
output regDst;//
output memWrite_EXE_DM;//
output memRead_EXE_DM;//
output memToReg_EXE_DM;//
output wen_DM_WB;//

//Program counter
wire [`ISIZE-1:0]PCIN;
wire [`ISIZE-1:0]PCNEXT;

//-------------------------------------STAGE FETCH-------------------------------------------------------------//

PC1 pc(.clk(clk),.rst(rst),.nextPC(PCNEXT),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC


assign PCIN = PCOUT + 16'b1; //increments PC to PC +1


//instruction memory
memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .fileid(4'b0),.data_out(INST));//note that memory read is having one clock cycle delay as memory is a slow operation

//initialization of regfiles is done as hardcoding here
wire wen;
wire [2:0] aluop;
wire memWrite;
wire memRead;
wire memToReg;
wire branch;
//wire alusrc missing

//---------------------------------------------------STAGE DECODE-------------------------------------------------
control C0 (.inst(INST[15:12]),.wen(wen),.alusrc(alusrc),.regDst(regDst),.memWrite(memWrite),.memRead(memRead),.memToReg(memToReg),.branch(branch), .aluop(aluop));
  //MUX 
wire [`ASIZE-1:0] RAddr2= regDst ? INST[11:8] : INST[3:0];
regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen_DM_WB), .raddr1(INST[7:4]), .raddr2(RAddr2), .waddr(waddr_DM_WB), .wdata(aluout_DM_WB), .rdata1(rdata1), .rdata2(rdata2));//note that waddr needs to come from pipeline register 

/*
Bhavya's Note on naming convention:
A signal going into pipeline register in stage ID-> EXE, will have a corresponding output
of the same name followed by ID_EXE (indicating ID to EXE)
*/
wire wen_ID_EXE;
wire [2:0] aluop_ID_EXE;
wire regDst_ID_EXE;
wire memWrite_ID_EXE;
wire memRead_ID_EXE;
wire memToReg_ID_EXE;

wire [`ISIZE-1:0]PC_ID_EXE;

ID_EXE_stage PIPE1(.clk(clk), .rst(rst), .rdata1_in(rdata1),.rdata2_in(rdata2),.imm_in({{12{INST[3]}},INST[3:0]}),.opcode_in(aluop), .alusrc_in(alusrc), .waddr_in(INST[11:8]),.wen_in(wen),.memWrite_in(memWrite),.memRead_in(memRead),.memToReg_in(memToReg),.branch_in(branch),.PC_in(PCIN), .waddr_out(waddr_out_ID_EXE),.imm_out(imm_ID_EXE), .rdata1_out(rdata1_ID_EXE), .rdata2_out(rdata2_ID_EXE),.alusrc_out(alusrc_ID_EXE), .opcode_out(aluop_ID_EXE),.wen_out(wen_ID_EXE),.memWrite_out(memWrite_ID_EXE),.memRead_out(memRead_ID_EXE),.memToReg_out(memToReg_ID_EXE),.branch_out(branch_ID_EXE),.PC_out(PC_ID_EXE));//immediate value is only zero extended. As we are concentrationg only on R type instuctions, this is not an issue.

//--------------------------------------------------STAGE EXECUTE--------------------------------------
wire [`DSIZE-1:0]rdata2_imm_ID_EXE=alusrc_ID_EXE ? imm_ID_EXE : rdata2_ID_EXE;// mux for selecting immedaite or the rdata2 value

//Branch
wire zero;

alu ALU0( .a(rdata1_ID_EXE), .b(rdata2_imm_ID_EXE), .op(aluop_ID_EXE), .out(aluout),.zero(zero));//ALU takes its input from pipeline register and the output of mux.
//Mux for PC
wire [`ISIZE-1:0] res=PC_ID_EXE+imm_ID_EXE;
assign PCNEXT=zero&branch_ID_EXE ? res : PC_ID_EXE;

wire wen_EXE_DM;

pip_stage4 S4(.clk(clk),.rst(rst),.w_addr_in(waddr_out_ID_EXE),.w_data_in(aluout),.Rdata2_in(rdata2_ID_EXE),
					.memWrite_in(memWrite_ID_EXE),.memRead_in(memRead_ID_EXE),
					.memToReg_in(memToReg_ID_EXE),.wen_in(wen_ID_EXE),.w_addr_out(waddr_out_EXE_DM),
					.w_data_out(aluout_EXE_DM),.Rdata2_out(rdata2_EXE_DM),.memWrite_out(memWrite_EXE_DM),
					.memRead_out(memRead_EXE_DM),.memToReg_out(memToReg_EXE_DM),.wen_out(wen_EXE_DM));

	 
	
//---------------------------------------------STAGE DM-------------------------------------------------

memory dm( .clk(clk), .rst(rst), .wen(memWrite_EXE_DM), .addr(aluout_EXE_DM), .data_in(rdata2_EXE_DM), .fileid(4'b1000),.data_out(readMem));

DummyReg r(.clk(clk), .rst(rst),.aluout_in(aluout_EXE_DM),.aluout_out(aluout_DM));

assign aluout_WB=memToReg_EXE_DM? aluout_DM:readMem;

Pipeline_WB_Stage WB (.clk(clk), .rst(rst), .w_addr_in(waddr_out_EXE_DM),.w_data_in(aluout_WB),.w_addr_out(waddr_DM_WB),.w_data_out(aluout_DM_WB),.wen_in(wen_EXE_DM),.wen_out(wen_DM_WB));

endmodule



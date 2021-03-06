`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_3stage(clk, rst, fileid, PCOUT
,branch_ID_EXE, INST, rdata1, rdata2, rdata1_ID_EXE, rdata2_ID_EXE, imm_ID_EXE,rdata2_imm_ID_EXE,
 aluop_ID_EXE, alusrc_ID_EXE, waddr_out_ID_EXE,aluout, waddr_out_EXE_DM,aluout_EXE_DM,rdata2_EXE_DM,
regDst,memWrite_EXE_DM,memRead_EXE_DM,memToReg_WB,wen_DM_WB,
 waddr_jal,aluout_jal,readMem,aluout_DM,aluout_WB,zero,res,jump,jal_out,jr,PC_ID_EXE,PCIN);

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
output zero;
output [`ISIZE-1:0] res;
output [`ISIZE-1:0]PC_ID_EXE;
		
//Stage DM
output [`ASIZE-1:0] waddr_out_EXE_DM; //	
output [`DSIZE-1:0] aluout_EXE_DM; //
output [`DSIZE-1:0] readMem;	//
output [`DSIZE-1:0] aluout_DM;//
output [`DSIZE-1:0] aluout_WB;//

//Write back
wire [`ASIZE-1:0] waddr_DM_WB;//
wire [`DSIZE-1:0] aluout_DM_WB;//
output [`ASIZE-1:0] waddr_jal;//
output [`DSIZE-1:0] aluout_jal;//
								
//Control Signal outputs
output branch_ID_EXE;//
output alusrc_ID_EXE;  //
output [2:0]aluop_ID_EXE; //
output regDst;//
output memWrite_EXE_DM;//
output memRead_EXE_DM;//
output memToReg_WB;//
output wen_DM_WB;//
output jump;
output jal_out;
output jr;

//Program counter
output [`ISIZE-1:0]PCIN;
wire [`ISIZE-1:0]PCNEXT;
wire [`ISIZE-1:0]PCAddr_mux;
wire [`ISIZE-1:0]PCAddr_mux2;
wire [`ISIZE-1:0]concatenator;

//-------------------------------------STAGE FETCH-------------------------------------------------------------//

PC1 pc(.clk(clk),.rst(rst),.nextPC(PCAddr_mux2),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC


assign PCIN = PCOUT + 16'b1; //increments PC to PC +1
assign PCNEXT=zero&branch_ID_EXE ? res : PCIN;
assign concatenator = {{PCIN[15:12]},{INST[11:0]}};
assign PCAddr_mux = jump? concatenator:PCNEXT ;
assign PCAddr_mux2 = jr?  rdata1:PCAddr_mux;

//instruction memory
memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .fileid(4'b0),.data_out(INST));//note that memory read is having one clock cycle delay as memory is a slow operation

//initialization of regfiles is done as hardcoding here
wire wen;
wire [2:0] aluop;
wire memWrite;
wire memRead;
wire memToReg;
wire branch;
wire jal;
//wire alusrc missing

//---------------------------------------------------STAGE DECODE-------------------------------------------------
control C0 (.inst(INST[15:12]),.wen(wen),.alusrc(alusrc),.regDst(regDst),
.memWrite(memWrite),.memRead(memRead),.memToReg(memToReg),.branch(branch), .aluop(aluop)
,.jump(jump),.jal(jal),.jr(jr));
  //MUX 
wire [`ASIZE-1:0] RAddr2= regDst ? INST[11:8] : INST[3:0];
wire [`ASIZE-1:0] wra_addr = 16'b1111;
assign waddr_jal=jal_out? wra_addr:waddr_DM_WB;
assign aluout_jal=jal_out? PC_WB:aluout_WB;

regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen_DM_WB), .raddr1(INST[7:4]), .raddr2(RAddr2),
 .waddr(waddr_jal), .wdata(aluout_jal), .rdata1(rdata1), .rdata2(rdata2));//note that waddr needs to come from pipeline register 

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
wire jal_ID_EXE;

wire [`ISIZE-1:0]PCIN2;
PCDelay PC(.clk(clk),.rst(rst),.PC_in(PCIN),.PC_out(PCIN2));
//.imm_in({{12{INST[3]}},INST[3:0]})
ID_EXE_stage PIPE1(.clk(clk), .rst(rst), .rdata1_in(rdata1),.rdata2_in(rdata2),
.imm_in({{12{1'b0}},INST[3:0]}),.opcode_in(aluop), .alusrc_in(alusrc),
 .waddr_in(INST[11:8]),.wen_in(wen),.memWrite_in(memWrite),
 .memRead_in(memRead),.memToReg_in(memToReg),.branch_in(branch),
 .PC_in(PCIN2), .waddr_out(waddr_out_ID_EXE),.imm_out(imm_ID_EXE),
 .rdata1_out(rdata1_ID_EXE), .rdata2_out(rdata2_ID_EXE),.alusrc_out(alusrc_ID_EXE),
 .opcode_out(aluop_ID_EXE),.wen_out(wen_ID_EXE),.memWrite_out(memWrite_ID_EXE),
 .memRead_out(memRead_ID_EXE),.memToReg_out(memToReg_ID_EXE),.branch_out(branch_ID_EXE),
 .PC_out(PC_ID_EXE),.jal_in(jal),.jal_out(jal_ID_EXE));
 
 //immediate value is only zero extended. As we are concentrationg only on R type instuctions, this is not an issue.

//--------------------------------------------------STAGE EXECUTE--------------------------------------
wire [`DSIZE-1:0]rdata2_imm_ID_EXE=alusrc_ID_EXE ? imm_ID_EXE : rdata2_ID_EXE;// mux for selecting immedaite or the rdata2 value


alu ALU0( .a(rdata1_ID_EXE), .b(rdata2_imm_ID_EXE), .op(aluop_ID_EXE), .out(aluout),.zero(zero));//ALU takes its input from pipeline register and the output of mux.
//Mux for PC
assign res=PC_ID_EXE+imm_ID_EXE;
//assign PCNEXT=zero&branch_ID_EXE ? res : PC_ID_EXE;


wire wen_EXE_DM_a;
wire memToReg_EXE_DM_a;
wire jal_EXE_DM;
wire [`ISIZE-1:0] PC_EXE_DM;
wire memToReg_EXE_DM;

pip_stage4 S4(.clk(clk),.rst(rst),.w_addr_in(waddr_out_ID_EXE),.w_data_in(aluout),.Rdata2_in(rdata2_ID_EXE),
					.memWrite_in(memWrite_ID_EXE),.memRead_in(memRead_ID_EXE),
					.memToReg_in(memToReg_ID_EXE),.wen_in(wen_ID_EXE),.w_addr_out(waddr_out_EXE_DM),
					.w_data_out(aluout_EXE_DM),.Rdata2_out(rdata2_EXE_DM),.memWrite_out(memWrite_EXE_DM),
					.memRead_out(memRead_EXE_DM),.memToReg_out(memToReg_EXE_DM_a),.wen_out(wen_EXE_DM_a),
					.jal_in(jal_ID_EXE),.jal_out(jal_EXE_DM),.PC_in(PC_ID_EXE),.PC_out(PC_EXE_DM));

	 
	
//---------------------------------------------STAGE DM-------------------------------------------------

memory dm( .clk(clk), .rst(rst), .wen(memWrite_EXE_DM), .addr(aluout_EXE_DM), 
.data_in(rdata2_EXE_DM), .fileid(4'b1000),.data_out(readMem));

wire wen_EXE_DM;
wire [`ISIZE-1:0]PC_EXE_DM2;
wire jal_DM;
wire memToReg_DM;

wire [`ASIZE-1:0] waddr_out_EXE_DM_a;

DummyReg r(.clk(clk), .rst(rst), .aluout_in(aluout_EXE_DM), .MemtoReg_in(memToReg_EXE_DM_a),
.wen_in(wen_EXE_DM_a),.wen_out(wen_EXE_DM),.MemtoReg_out(memToReg_EXE_DM),.aluout_out(aluout_DM),
.PC_in(PC_EXE_DM),.PC_out(PC_EXE_DM2),
.jal_in(jal_EXE_DM),.jal_out(jal_DM),
.waddr_in(waddr_out_EXE_DM),.waddr_out(waddr_out_EXE_DM_a));

wire [`DSIZE-1:0] readMem_WB;	
wire [`ISIZE-1:0]PC_WB;

Pipeline_WB_Stage WB (.clk(clk), .rst(rst), .w_addr_in(waddr_out_EXE_DM_a),
.w_data_in(aluout_DM),.w_addr_out(waddr_DM_WB),.w_data_out(aluout_DM_WB),
.wen_in(wen_EXE_DM),.wen_out(wen_DM_WB),.PC_in(PC_EXE_DM2),.PC_out(PC_WB),
.jal_in(jal_DM),.jal_out(jal_out),.MemtoReg_in(memToReg_EXE_DM),
.MemtoReg_out(memToReg_WB),.readMem_in(readMem),.readMem_out(readMem_WB));

assign aluout_WB=memToReg_WB? aluout_DM_WB:readMem_WB;
endmodule



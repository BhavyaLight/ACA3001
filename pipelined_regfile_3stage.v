`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_3stage(clk, rst, fileid, PCOUT, INST, rdata1, rdata2, rdata1_ID_EXE, rdata2_ID_EXE, imm_ID_EXE,rdata2_imm_ID_EXE, aluop_ID_EXE, alusrc_ID_EXE, waddr_out_ID_EXE,aluout, waddr_out_ID_S4,aluout_S4);

input clk;				
											
input	rst;
input fileid; 
 
output [`ISIZE-1:0]PCOUT;
output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata1_ID_EXE;
output [`DSIZE-1:0] rdata2;
output [`DSIZE-1:0] rdata2_ID_EXE;
output [`DSIZE-1:0] imm_ID_EXE;
output [`DSIZE-1:0] rdata2_imm_ID_EXE;
output [`DSIZE-1:0]INST;
output alusrc_ID_EXE;
output [2:0]aluop_ID_EXE;
output [`ASIZE-1:0] waddr_out_ID_EXE;	
output [`DSIZE-1:0] aluout;				
output [`ASIZE-1:0] waddr_out_ID_S4;	
output [`DSIZE-1:0] aluout_S4;									
 	 
//Program counter
wire [`ISIZE-1:0]PCIN;


PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC


assign PCIN = PCOUT + 16'b1; //increments PC to PC +1


//instruction memory
memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .fileid(4'b0),.data_out(INST));//note that memory read is having one clock cycle delay as memory is a slow operation

//initialization of regfiles is done as hardcoding here
wire wen;
wire [2:0] aluop;

control C0 (.inst(INST[15:12]),.wen(wen),.alusrc(alusrc), .aluop(aluop));


regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen), .raddr1(INST[7:4]), .raddr2(INST[3:0]), .waddr(waddr_out_ID_S4), .wdata(aluout_S4), .rdata1(rdata1), .rdata2(rdata2));//note that waddr needs to come from pipeline register 



ID_EXE_stage PIPE1(.clk(clk), .rst(rst), .rdata1_in(rdata1),.rdata2_in(rdata2),.imm_in({{12{INST[3]}},INST[3:0]}),.opcode_in(aluop), .alusrc_in(alusrc), .waddr_in(INST[11:8]), .waddr_out(waddr_out_ID_EXE),.imm_out(imm_ID_EXE), .rdata1_out(rdata1_ID_EXE), .rdata2_out(rdata2_ID_EXE),.alusrc_out(alusrc_ID_EXE), .opcode_out(aluop_ID_EXE));//immediate value is only zero extended. As we are concentrationg only on R type instuctions, this is not an issue.

wire [`DSIZE-1:0]rdata2_imm_ID_EXE=alusrc_ID_EXE ? imm_ID_EXE : rdata2_ID_EXE;// mux for selecting immedaite or the rdata2 value

alu ALU0 ( .a(rdata1_ID_EXE), .b(rdata2_imm_ID_EXE), .op(aluop_ID_EXE), .out(aluout));//ALU takes its input from pipeline register and the output of mux.

pip_stage4 S4(.clk(clk),.rst(rst),.w_addr(waddr_out_ID_EXE),.w_data(aluout),.w_addr_out(waddr_out_ID_S4),.w_data_out(aluout_S4));
endmodule



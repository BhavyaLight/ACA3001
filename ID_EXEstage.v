`include "define.v"

module ID_EXE_stage (
	
	input  clk,  rst, 
	input [`DSIZE-1:0] rdata1_in,
	input [`DSIZE-1:0] rdata2_in,
	input [`DSIZE-1:0] imm_in,
	input [2:0] opcode_in,
	input alusrc_in,
	input [`ASIZE-1:0]waddr_in, 
	input wen_in,
	input memWrite_in,
	input memRead_in,
	input memToReg_in,
	input branch_in,
	input jal_in,
	input jr_in,
	input jump_in,
	input [`ISIZE-1:0] conc_in,
	input [`ISIZE-1:0] PC_in,
	
	output reg [`DSIZE-1:0] rdata1_out,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg [`DSIZE-1:0] imm_out,
	output reg [2:0] opcode_out,
	output reg alusrc_out,
	output reg wen_out,
	output reg memWrite_out,
	output reg memRead_out,
	output reg memToReg_out,
	output reg branch_out,
	output reg jal_out,
	output reg jump_out,
	output reg jr_out,
	output reg [`ISIZE-1:0] conc_out,
	output reg [`ISIZE-1:0] PC_out,
	output reg[`ASIZE-1:0]waddr_out
	
);



//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.



always @ (posedge clk) begin
	if(rst)
	begin
		waddr_out <= 0;
		rdata1_out <= 0;
		rdata2_out <= 0;
		imm_out<=0;
		opcode_out<=0;
		alusrc_out<=0;
	   wen_out<=0;
	   memWrite_out<=0;
	   memRead_out<=0;
	   memToReg_out<=0;
	   branch_out<=0;
		PC_out<=0;
		jr_out<=0;
		jal_out<=0;
		jump_out<=0;
		conc_out<=0;
	end
   else
	begin
		waddr_out <= waddr_in;
		rdata1_out <= rdata1_in;
		rdata2_out <= rdata2_in;
		imm_out<=imm_in;
		opcode_out<=opcode_in;
		alusrc_out<=alusrc_in;
	   wen_out<=wen_in;
	   memWrite_out<=memWrite_in;
	   memRead_out<=memRead_in;
	   memToReg_out<=memToReg_in;
	   branch_out<=branch_in;
		PC_out<=PC_in;
		jr_out<=jr_in;
		jal_out<=jal_in;
		jump_out<=jump_in;
		conc_out<=conc_in;
	end
 
end
endmodule



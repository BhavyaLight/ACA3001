`timescale 1ns / 1ps
`include "define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:12 10/19/2015 
// Design Name: 
// Module Name:    DummyReg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DummyReg(
    input clk,
    input rst,
    input[`DSIZE-1:0] aluout_in,
	 input MemtoReg_in,
	 input wen_in,
	 input [`ISIZE-1:0]PC_in,
	 input jal_in,
	 input [`ASIZE-1:0] waddr_in,
	 
    output reg[`DSIZE-1:0] aluout_out,
	 output reg wen_out,
	 output reg MemtoReg_out,
	 output reg jal_out,
	 output reg [`ISIZE-1:0]PC_out,
	 output reg [`ASIZE-1:0] waddr_out
    );

always @ (posedge clk) begin
	if(rst)
	begin
		aluout_out <= 0;
		MemtoReg_out<=0;
		wen_out<=0;
		PC_out<=0;
		jal_out<=0;
		waddr_out<=0;
	end
   else
	begin
		aluout_out<=aluout_in;
		MemtoReg_out<=MemtoReg_in;
		wen_out<=wen_in;
		PC_out<=PC_in;
		jal_out<=jal_in;
		waddr_out<=waddr_in;
	end
 
end

endmodule

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
	 input [`ISIZE-1:0] PC_in,
	 output reg [`ISIZE-1:0] PC_out,
    output reg[`DSIZE-1:0] aluout_out
    );

always @ (posedge clk) begin
	if(rst)
	begin
		aluout_out <= 0;
		PC_out<=0;
	end
   else
	begin
		aluout_out<=aluout_in;
		PC_out<=PC_in;
	end
 
end

endmodule

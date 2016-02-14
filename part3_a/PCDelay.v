`timescale 1ns / 1ps
`include "define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:02:26 11/09/2015 
// Design Name: 
// Module Name:    PCDelay 
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
module PCDelay(
    input clk,
    input rst,
	 input [`ISIZE-1:0]PC_in,
	 
	 output reg [`ISIZE-1:0]PC_out
    );
	 
	 always @ (posedge clk) begin
	if(rst)
	begin
		PC_out<=0;
	end
   else
	begin
		PC_out<=PC_in;
	end
end

endmodule

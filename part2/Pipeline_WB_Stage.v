`timescale 1ns / 1ps
`include "define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:33:46 10/19/2015 
// Design Name: 
// Module Name:    Pipeline_WB_Stage 
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
module Pipeline_WB_Stage(
    input clk,
    input rst,
	 input wen_in,
    input [`DSIZE-1:0] w_data_in,
    input [`ASIZE-1:0]w_addr_in,
	 input [`ISIZE-1:0]PC_in,
	 input jal_in,
	 input MemtoReg_in,
	 input [`DSIZE-1:0] readMem_in,
	 
	 output reg jal_out,
	 output reg [`ISIZE-1:0] PC_out,
	 output reg[`DSIZE-1:0] w_data_out,
    output reg[`ASIZE-1:0] w_addr_out,
	 output reg wen_out,
	 output reg MemtoReg_out,
	 output reg [`DSIZE-1:0] readMem_out
    );
	 
always @ (posedge clk) 
begin
	if(rst)
	begin
		w_addr_out <= 0;
		w_data_out<=0;
		wen_out<=0;
		jal_out<=0;
		PC_out<=0;
		MemtoReg_out<=0;
		readMem_out<=0;
	end
   else
	begin
		w_addr_out <= w_addr_in;
		w_data_out<=w_data_in;
		wen_out<=wen_in;
		jal_out<=jal_in;
		PC_out<=PC_in;
		MemtoReg_out<=MemtoReg_in;
		readMem_out<=readMem_in;
	end
 
end


endmodule

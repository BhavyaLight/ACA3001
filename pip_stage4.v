`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:09:02 09/15/2015 
// Design Name: 
// Module Name:    pip_stage4 
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
module pip_stage4(
    input clk,
    input rst,
    input [3:0] w_addr,
    input [15:0] w_data,
	 output reg [3:0] w_addr_out,
    output reg [15:0] w_data_out
    );
//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.



always @ (posedge clk) begin
	if(rst)
	begin
		w_addr_out <= 0;
		w_data_out<=0;
	end
   else
	begin
		w_addr_out <= w_addr;
		w_data_out<=w_data;
	end
 
end

endmodule

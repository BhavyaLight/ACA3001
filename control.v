//control unit for write enable and ALU control

`include "define.v"

module control(
  input [3:0] inst, 
  output reg wen,
  output reg alusrc,
  output reg regDst,
  output reg memWrite,
  output reg memRead,
  output reg memToReg,
  output reg branch,
  output reg [2:0] aluop,
  output reg jump,
  output reg jal,
  output reg jr
  );
  
  always@(*)
  begin
 
    case(inst)
		  `ADD: begin
				  	 wen=1;
				 	 alusrc=0;
					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
				 	 aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
		  end
		  `SUB: begin
                wen=1;
					 alusrc=0;
					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
        `AND: begin
                wen=1;
					 alusrc=0;
					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
        `XOR: begin
                wen=1;
					 alusrc=0;
					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
        `SLL: begin
                wen=1;
					 alusrc=1;
					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
        `SRL: begin
                wen=1;
					 alusrc=1;
					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
        `COM: begin
                wen=1;
					 alusrc=0;
					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
        `MUL: begin
                wen=1;
					 alusrc=0;
 					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=1;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
		  `LW: begin
                wen=1;
					 alusrc=1;
 					 regDst=0;
					 memWrite=0;
					 memRead=1;
					 memToReg=0;
					 branch=0;
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
		  `SW: begin
                wen=0;
					 alusrc=1;
 					 regDst=1;
					 memWrite=1;
					 memRead=0;
					 memToReg=0;
					 branch=0;
                aluop=3'b000;
					 jump = 0;
					 jal = 0;
					 jr = 0;
					/*Bhavya's Note: AluOp has been taking last three bits on inst till now.
					However, for SW last three bits are 001. But we need to tell the ALU to ADD (000).
					Thus, i am passing 3'b000 to the aluop now instead.
					*/
        end
		  `BEQ: begin
                wen=0;
					 alusrc=0;
 					 regDst=1;
					 memWrite=0;
					 memRead=0;
					 memToReg=0;
					 branch=1;
					 //Bhavya's Note: aluop has no significance for this instruction. (See ALU zero)
                aluop=inst[2:0];
					 jump = 0;
					 jal = 0;
					 jr = 0;
        end
		  
		  `JUMP: begin
                wen=0;
					 alusrc=0;
 					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=0;
					 branch=0;
					 aluop=inst[2:0];
					 //Madhavan's Note: jump control signal is enabled for this instruction 
					 jump = 1;
					 jal = 0;
					 jr = 0;
        end
		  
		  `JAL: begin
                wen=1;
					 alusrc=0;
 					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=0;
					 branch=0;
					 aluop=inst[2:0];
					 //Madhavan's Note: jump control signal is enabled for this instruction 
					 jump = 1;
					 jal = 1;
					 jr = 0;
        end
		  
		  `JR: begin
                wen=0;
					 alusrc=0;
 					 regDst=0;
					 memWrite=0;
					 memRead=0;
					 memToReg=0;
					 branch=0;
					 aluop=inst[2:0];
					 //Madhavan's Note: jump control signal is enabled for this instruction 
					 jump = 0;
					 jal = 0;
					 jr = 1;
        end
		  
		
    endcase
  end
  
endmodule

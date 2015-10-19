//control unit for write enable and ALU control

`include "define.v"

module control(
  input [3:0] inst, 
  output reg wen,
  output reg alusrc,
  output reg [2:0] aluop
  );
  
  always@(*)
  begin
 
    case(inst)
	`ADD: begin
		wen=1;
		alusrc=0;
		aluop=inst[2:0];
	end
        `SUB: begin
                wen=1;
			alusrc=0;
                aluop=inst[2:0];
        end
        `AND: begin
                wen=1;
			alusrc=0;
                aluop=inst[2:0];
        end
        `XOR: begin
                wen=1;
			alusrc=0;
                aluop=inst[2:0];
        end
        `SLL: begin
                wen=1;
			alusrc=1;
                aluop=inst[2:0];
        end
        `SRL: begin
                wen=1;
			alusrc=1;
                aluop=inst[2:0];
        end
        `COM: begin
                wen=1;
			alusrc=0;
                aluop=inst[2:0];
        end
        `MUL: begin
                wen=1;
			alusrc=0;
                aluop=inst[2:0];
        end
    endcase
  end
  
endmodule

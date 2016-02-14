# ACA3001
Developing a MIPS-like microprocessor on Verilog without cache as a part of course assignment.

It has been divided into 3 parts
1. Part-a: implementing R and I type functions (BEW, LW, SW)
2. Part-b: implementing JUMP, JR, JAL, R and I type
3. Part-c: Visualise reducing in CPI by loop-rolling

The machine code for the following assembly commands can be found in define.v

`define ADD 4'b0000
`define SUB 4'b0001
`define AND 4'b0010
`define XOR  4'b0011
`define SLL 4'b0100
`define SRL 4'b0101
`define COM 4'b0110
`define MUL  4'b0111
`define LW 4'b1000
`define SW 4'b1001
`define BEQ 4'b1010 
`define NOP 4'b1111 
`define JR 4'b1011
`define JAL 4'b1101
`define JUMP 4'b1100

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:15 11/02/2023 
// Design Name: 
// Module Name:    Controller 
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
`include "macro.v"

module Controller(
    input [31:0] Instr,
	 output [4:0] ALU_op,
	 output [1:0] D2R,
	 output [1:0] width_op,
	 output [1:0] RD,
	 output [4:0] com_op,
	 output [1:0] jump,
	 output imm_ext,
	 output MW,
	 output RW,
	 output signORzero,
	 output Branch,
	 output add3000,
	 output ALU_srcA,
	 output ALU_srcB,
	 output com_write
    );
	 
	 /* macro_define */
	 `CODE_IDENTIFY
	 `OP_DEFINE

	 assign ALU_op = (add|addiu|addi|load|write|addu) ? add_op :
						   sub ? sub_op :
							ori ? or_op :
							lui ? lui_op : sll_op;
							
	 assign D2R = {ra,load};
	 
	 assign RD = {ra,R_type};
	 
	 assign com_op = beq ? beq_op : 
						  bne ? bne_op : 
						  bgezal ? bgezal_op : 5'b00000;
	 
	 assign jump = {jump2,jump1};
	 
	 assign imm_ext = ori ;
	 
	 assign MW = write; // maybe contitional
	 
	 assign RW = R_type | I_type | load | J_write | bgezal;
	 
	 assign Branch = branch;
	 
	 assign ALU_srcA = shamt;
	 
	 assign ALU_srcB = I_type | write | load;
	 
	 assign com_write = bgezal;
	 
	 assign width_op = {bytes,half};
	 
	 assign signORzero = lbu | lhu;
							
endmodule

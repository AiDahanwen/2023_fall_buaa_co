`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:39:50 11/03/2023 
// Design Name: 
// Module Name:    Compare 
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

module Compare(
    input [31:0] com_srcA,
    input [31:0] com_srcB,
    input [4:0] com_op,
	 output compare_condition
    );

	`OP_DEFINE
	assign compare_condition = (com_op == beq_op) ? (com_srcA == com_srcB) : 
										(com_op == bne_op) ? (com_srcA != com_srcB) :
										(com_op == bgezal_op) ? ($signed(com_srcA)>= 0) : 5'b00000;
	
endmodule

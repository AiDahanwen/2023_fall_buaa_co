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
										(com_op == bgezal_op) ? ($signed(com_srcA)>= $signed(0)) :
										(com_op == bslt_op) ? ((com_srcA + com_srcB) < 32'h00006000) : 1'b0;
	
	
	function [31:0]count_one(
		input [31:0] srcA
	);
	integer i;
	begin
		count_one = 0;
		for(i=0;i<32;i=i+1)begin
			count_one = count_one + srcA[i];
		end
	end
	endfunction
	
	function [31:0] find_highest_one(
		input [31:0] srcA
	);
	integer i;
	begin
		for(i=31;srcA[i]!=1'b1;i=i-1);
		find_highest_one = i;
	end
	endfunction

endmodule

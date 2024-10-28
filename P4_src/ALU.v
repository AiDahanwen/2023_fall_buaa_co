`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:41:28 11/03/2023 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
    input [4:0] ALU_op,
    input [31:0] srcA,
    input [31:0] srcB,
    output [31:0] result
    );
	 
	 `OP_DEFINE
	 
	 wire [31:0] add_res;
	 assign add_res = srcA + srcB;
	 
	 wire [31:0] sub_res;
	 assign sub_res = srcA - srcB;
	 
	 wire [31:0] or_res;
	 assign or_res = srcA | srcB;
	 
	 wire [31:0] lui_res;
	 assign lui_res = {{srcB[15:0]},{16{1'b0}}};
	 
	 wire [31:0] sll_res;
	 assign sll_res = srcB << srcA[4:0];
	 
	 assign result = (ALU_op == add_op) ? add_res :
						  (ALU_op == sub_op) ? sub_res :
						  (ALU_op == or_op) ? or_res :
						  (ALU_op == lui_op) ? lui_res :
						  (ALU_op == sll_op) ? sll_res : 
						  32'b0000_0000_0000_0000_0000_0000_0000_0000;
						  
	function [31:0] bit_adder(
		input [31:0] src
	); 
	integer i;
	begin
		bit_adder = 32'b0;
		for(i=0; i<32; i=i+1) begin
			bit_adder = bit_adder + src[i];
		end
	end
  endfunction

	function [31:0] count_zero(
    input [31:0] src
	);
    integer i;
    begin
        count_zero = 32'b0;
        for(i=0;src[i]==0;i=i+1,count_zero=count_zero+1);
    end
   endfunction
	
	function [31:0] matrix(
		input [31:0] srcA,
		input [31:0] srcB
	);
		integer i;
		begin
			matrix = 0;
			for(i=0; i<32; i=i+1) begin
				matrix = matrix + srcA*srcB;
			end
		end
	endfunction
	
	function [7:0] gray(
		input [7:0] src
	);
	
	wire [1:0] g1;
	wire [1:0] g2;
	wire [1:0] g3;
	wire [1:0] g4;
	begin
		assign g1 = src[1:0];
		assign g2 = src[3:2];
		assign g3 = src[5:4];
		assign g4 = src[7:6];
		assign gray = {g4,g3,g2,g1};
	end
	endfunction
endmodule

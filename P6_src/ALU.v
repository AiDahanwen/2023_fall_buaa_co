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
	 
	 wire [31:0] and_res;
	 assign and_res = srcA & srcB;
	 
	 wire [31:0] slt_res;
	 assign slt_res = ($signed(srcA) < $signed(srcB)) ? 32'd1 : 32'b0;
	 
	 wire [31:0] sltu_res;
	 assign sltu_res = (srcA < srcB) ? 32'd1 : 32'b0;
	 
	 wire [31:0] srl_res;
	 assign srl_res = srcB >> srcA[4:0];
	 
	 wire [31:0] sra_res;
	 assign sra_res = srcB >>> srcA[4:0];
	 
	 wire [31:0] xor_res;
	 assign xor_res = srcA ^ srcB;
	 
	 assign result = (ALU_op == add_op) ? add_res :
						  (ALU_op == sub_op) ? sub_res :
						  (ALU_op == or_op) ? or_res :
						  (ALU_op == lui_op) ? lui_res :
						  (ALU_op == sll_op) ? sll_res : 
						  (ALU_op == slt_op) ? slt_res :
						  (ALU_op == sltu_op) ? sltu_res :
						  (ALU_op == and_op) ? and_res :					 
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
        for(i=0;i<32;i=i+1) begin
				if(src[i] == 1'b0) begin
					count_zero = count_zero + 1;
				end
		  end
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
	
	function [31:0] roshift_left(
		input [31:0] srcA,
		input [31:0] srcB
	);
		reg [4:0] shamt;
		integer i;
		begin
			shamt = srcB[4:0];
			for(i=0;i<32;i=i+1) begin
				if(i<shamt) begin
					roshift_left[i] = srcA[32+i-shamt];
				end
				else begin
					roshift_left[i] = srcA[i-shamt];
				end
			end
		end
	endfunction
	
	function [31:0] roshift_right(
		input [31:0] srcA,
		input [31:0] srcB
	);
		reg [4:0] shamt;
		integer i;
		begin
			shamt = srcB[4:0];
			for(i=0;i<32;i=i+1)begin
				if(i<(32-shamt)) begin
					roshift_right[i] = srcA[i+shamt];
				end
				else begin
					roshift_right[i] = srcA[shamt+i-32];
				end
			end
		end
	endfunction
	
	function [31:0] sum_shift(
		input [31:0] srcA,
		input [31:0] srcB
	);
	integer i;
	begin
		sum_shift = 32'b0;
		for(i=0;i<32;i=i+1) begin
			sum_shift = sum_shift + roshift_left(srcA,i);
		end
	end
	endfunction
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:55:38 11/25/2023 
// Design Name: 
// Module Name:    MultDiv 
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
module MultDiv(
	 input clk,
	 input reset,
	 input start,
    input [31:0] srcA,
    input [31:0] srcB,
	 input [4:0] ALU_op,
	 output busy,
    output [31:0] multdiv_res
    );

	 `OP_DEFINE

	 reg [31:0] HI;
	 reg [31:0] LO;
	 reg [31:0] count;
	 
	 initial begin
		HI = 32'b0;
		LO = 32'b0;
		count = 32'b0;
	 end
	 
	 always@(posedge clk) begin
		if(reset) begin
			HI <= 32'b0;
			LO <= 32'b0;
			count <= 32'b0;
		end
		else if(start) begin
			case(ALU_op)
				mult_op : begin
					{HI,LO} <= $signed(srcA) * $signed(srcB);
					count <= 5;
				end
				multu_op : begin
					{HI,LO} <= srcA * srcB;
					count <= 5;
				end
				div_op : begin
					{HI,LO} <= {($signed(srcA)) % ($signed(srcB)),($signed(srcA))/($signed(srcB))};
					count <= 10;
				end
				divu_op: begin
					{HI,LO} <= {srcA % srcB,srcA / srcB};
					count <= 10;
				end
			endcase	
		end
		else begin //no reset & no mult/div
			case(ALU_op) 
				mthi_op : begin
					HI <= srcA;
				end
				mtlo_op : begin
					LO <= srcA;
				end
			endcase
			if(count != 0) begin
				count <= count - 1;
			end
		end
	 end
	
	assign multdiv_res = (ALU_op == mfhi_op) ? HI : LO;
	assign busy = (count != 0) ? 1'b1 : 1'b0;
	
endmodule

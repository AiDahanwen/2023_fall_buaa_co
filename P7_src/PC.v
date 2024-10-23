`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:59 11/03/2023 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input [31:0] next_pc,
    output reg [31:0] PC,
	 input Req,
    input reset,
    input clk,
	 input enable_PC
    );
	
	initial begin
		PC = 32'h0000_3000;
	end
	
	always@(posedge clk) begin
		if(reset) begin
			PC <= 32'h0000_3000;
		end
		else if(Req) begin
			PC <= 32'h0000_4180;
		end
		else if(enable_PC && (!Req)) begin
			PC <= next_pc;
		end
	end
	
endmodule

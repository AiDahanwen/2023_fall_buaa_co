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
    input reset,
    input clk
    );
	
	initial begin
		PC = 32'h0000_3000;
	end
	
	always@(posedge clk) begin
		if(reset) begin
			PC <= 32'h0000_3000;
		end
		else begin
			PC <= next_pc;
		end
	end
	
	
endmodule

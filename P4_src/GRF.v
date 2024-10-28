`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:57:25 11/03/2023 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
	 input [31:0] PC,
    input clk,
    input reset,
    input WE,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
	 /* 32 * registers */
	 reg [31:0] registers [31:0]; 
	 
	 /* loop */
	 integer i;
	 
	 /* initial all registers */
	 initial begin
		for(i = 0; i < 32; i = i+1) begin
			registers[i] = 0;
		end
	 end
	 
	 /* operate */
	 always @(posedge clk) begin
		if(reset) begin
			for(i = 0; i < 32; i=i+1) begin
				registers[i] = 0;
			end
		end
		else begin
			if(WE && (A3 != 5'b00000)) begin
				registers[A3] <= WD;
				$display("@%h: $%d <= %h",PC,A3,WD);
			end
		end
	 end
	 
	 /* OUTPUT */
	 assign RD1 = registers[A1];
	 assign RD2 = registers[A2];
	 
endmodule

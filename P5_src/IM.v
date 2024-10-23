`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:06 11/03/2023 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] PC_F,
    output [31:0] Instr
    );
	reg [31:0] IM[0:4095]; //from low to high
	initial begin
		$readmemh("code.txt",IM);
	end
	
	wire [31:0] PCsub;
	assign PCsub = PC_F - 32'h0000_3000;
	wire [11:0] Address;
	assign Address	= PCsub[13:2];
	
	assign Instr = IM[Address];
	
endmodule

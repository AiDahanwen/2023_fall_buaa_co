`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:02 11/08/2023 
// Design Name: 
// Module Name:    F_D_reg 
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
module F_D_reg(
		input [31:0] Instr_F,
		input [31:0] PC_F,
		input clk,
		input reset,
		input enable_D,
		output reg [31:0] Instr_D,
		output reg [31:0] PC_D
    );
	
	initial begin
		Instr_D = 0;
		PC_D = 0;
	end
	
	always@(posedge clk) begin
		if(enable_D) begin
			if(reset) begin
				Instr_D <= 0;
				PC_D <= 0;
			end
			else begin
				Instr_D <= Instr_F;
				PC_D <= PC_F;
			end
		end
		else begin
			Instr_D <= Instr_D;
			PC_D <= PC_D;
		end
	end

endmodule

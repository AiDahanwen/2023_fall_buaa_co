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
		input Req,
		input enable_D,
		input BDIn_F,
		input [4:0] F_ExcCode,
		output reg [31:0] Instr_D,
		output reg [4:0] D_ExcCode,
		output reg BDIn_D,
		output reg [31:0] PC_D
    );
	
	initial begin
		Instr_D = 0;
		PC_D = 0;
		D_ExcCode = 0;
		BDIn_D = 0;
	end
	
	always@(posedge clk) begin
		if(reset | Req) begin
			Instr_D <= 0;
			PC_D <= Req ? 32'h0000_4180 : 0;
			D_ExcCode <= 0;
			BDIn_D <= 0;
		end
		else if(enable_D) begin
			Instr_D <= Instr_F;
			PC_D <= PC_F;
			D_ExcCode <= F_ExcCode;
			BDIn_D <= BDIn_F;
		end
	end

endmodule

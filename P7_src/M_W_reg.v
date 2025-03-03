`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:57 11/08/2023 
// Design Name: 
// Module Name:    M_W_reg 
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
module M_W_reg(
		input enable_W,
		input reset,
		input clk,
		/* data */
		input [31:0] readData_M,
		input [31:0] ALU_result_M,
		input [31:0] Instr_M,
		input [31:0] PC_M,
		input [31:0] multdiv_res_M,
		input [31:0] R_Data_M,
		input compare_condition_M,
		input Req,
		input llBit_M,
		/* output */
		output reg [31:0] readData_W,
		output reg [31:0] Instr_W,
		output reg [31:0] PC_W,
		output reg [31:0] multdiv_res_W,
		output reg [31:0] R_Data_W,
		output reg compare_condition_W,
		output reg llBit_W,
		output reg [31:0] ALU_result_W
    );
	
	initial begin
		readData_W = 0;
		ALU_result_W = 0;
		Instr_W = 0;
		PC_W = 0;
		compare_condition_W = 0;
		multdiv_res_W = 0;
		R_Data_W = 0;
		llBit_W = 0;
	end
	
	always @(posedge clk) begin
		if(enable_W) begin
			if(reset || Req) begin
				readData_W <= 0;
				ALU_result_W <= 0;
				Instr_W <= 0;
				PC_W <= Req ? 32'h0000_4180 : 32'b0;
				PC_W <= 32'b0;
				compare_condition_W <= 0;
				multdiv_res_W <= 0;
				R_Data_W <= 0;
				llBit_W <= 0;
			end
			else begin
				readData_W <= readData_M;
				ALU_result_W <= ALU_result_M;
				Instr_W <= Instr_M;
				PC_W <= PC_M;
				compare_condition_W <= compare_condition_M;
				multdiv_res_W <= multdiv_res_M;
				R_Data_W <= R_Data_M;
				llBit_W <= llBit_M;
			end
		end
		else begin
			readData_W <= readData_W;
			ALU_result_W <= ALU_result_W;
			Instr_W <= Instr_W;
			PC_W <= PC_W;
			compare_condition_W <= compare_condition_W;
			multdiv_res_W <= multdiv_res_W;
			R_Data_W <= R_Data_W;
			llBit_W <= llBit_W;
		end
	end
endmodule

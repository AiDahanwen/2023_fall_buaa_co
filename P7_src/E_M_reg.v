`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:40 11/08/2023 
// Design Name: 
// Module Name:    E_M_reg 
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
module E_M_reg(
		input clk,
		input reset,
		input enable,
		input Req,
		/* data */
		input [31:0] Instr_E,
		input [31:0] ALU_result_E,
		input [31:0] writeData_E,
		input [31:0] PC_E,
		input [31:0] multdiv_res_E,
		input compare_condition_E,
		input BDIn_E,
		input [4:0] E_ExcCode,
		/* controller */
		output reg [31:0] Instr_M,
		output reg [31:0] ALU_result_M,
		output reg [31:0] PC_M,
		output reg [31:0] multdiv_res_M,
		output reg compare_condition_M,
		output reg BDIn_M,
		output reg [4:0] M_ExcCode,
		output reg [31:0] writeData_M
    );
	 
	 initial begin
		ALU_result_M = 0;
		writeData_M = 0;
		Instr_M = 0;
		PC_M = 0;
		compare_condition_M = 0;
		multdiv_res_M = 0;
		M_ExcCode = 0;
		BDIn_M = 0;
	 end
	 
	 always @(posedge clk) begin
		if(reset || Req) begin
			ALU_result_M <= 0;
			writeData_M <= 0;
			Instr_M <= 0;
			PC_M <= Req ? 32'h0000_4180 : 0;
			compare_condition_M <= 0;
			multdiv_res_M <= 0;
			M_ExcCode <= 0;
			BDIn_M <= 0;
		end
		else if(enable) begin
			ALU_result_M <= ALU_result_E;
			writeData_M <= writeData_E;
			Instr_M <= Instr_E;
			PC_M <= PC_E;
			compare_condition_M <= compare_condition_E;
			multdiv_res_M <= multdiv_res_E;
			M_ExcCode <= E_ExcCode;
			BDIn_M <= BDIn_E;
		end
	 end
endmodule

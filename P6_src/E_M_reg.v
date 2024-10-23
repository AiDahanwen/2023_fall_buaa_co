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
		/* data */
		input [31:0] Instr_E,
		input [31:0] ALU_result_E,
		input [31:0] writeData_E,
		input [31:0] PC_E,
		input [31:0] multdiv_res_E,
		input compare_condition_E,
		/* controller */
		output reg [31:0] Instr_M,
		output reg [31:0] ALU_result_M,
		output reg [31:0] PC_M,
		output reg [31:0] multdiv_res_M,
		output reg compare_condition_M,
		output reg [31:0] writeData_M
    );
	 
	 initial begin
		ALU_result_M = 0;
		writeData_M = 0;
		Instr_M = 0;
		PC_M = 0;
		compare_condition_M = 0;
		multdiv_res_M = 0;
	 end
	 
	 always @(posedge clk) begin
		if(enable) begin
			if(reset) begin
				ALU_result_M <= 0;
				writeData_M <= 0;
				Instr_M <= 0;
				PC_M <= 0;
				compare_condition_M <= 0;
				multdiv_res_M <= 0;
			end
			else begin
				ALU_result_M <= ALU_result_E;
				writeData_M <= writeData_E;
				Instr_M <= Instr_E;
				PC_M <= PC_E;
				compare_condition_M <= compare_condition_E;
				multdiv_res_M <= multdiv_res_E;
			end
		end
		else begin
			ALU_result_M <= ALU_result_M;
			writeData_M <= writeData_M;
			Instr_M <= Instr_M;
			PC_M <= PC_M;
			compare_condition_M <= compare_condition_M;
			multdiv_res_M <= multdiv_res_M;
		end
	 end

endmodule

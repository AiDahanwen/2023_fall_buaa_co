`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:16 11/08/2023 
// Design Name: 
// Module Name:    D_E_reg 
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
module D_E_reg(
		/* Input */
		input [31:0] Instr_D,
		input [31:0] RD1_D,
		input [31:0] RD2_D,
		input [31:0] imm_D,
		input [31:0] PC_D,
		input clk,
		input reset,
		input enable_E,
		input compare_condition_D,
		/** data **/
		output reg [31:0] Instr_E,
		output reg [31:0] RD1_E,
		output reg [31:0] RD2_E,
		output reg [31:0] PC_E,
		output reg compare_condition_E,
		output reg [31:0] imm_E
    );
	 
	 initial begin
		Instr_E <= 0;
		RD1_E <= 0;
		RD2_E <= 0;
		imm_E <= 0;
		PC_E <= 0;
		compare_condition_E <= 0;
	 end
	 
	 always@(posedge clk) begin
		if(enable_E) begin
			if(reset) begin
				Instr_E <= 0;
				RD1_E <= 0;
				RD2_E <= 0;
				imm_E <= 0;
				PC_E <= 0;
				compare_condition_E <= 0;
			end
			else begin
				Instr_E <= Instr_D;
				RD1_E <= RD1_D;
				RD2_E <= RD2_D;
				imm_E <= imm_D;
				PC_E <= PC_D;
				compare_condition_E <= compare_condition_D;
			end
		end
	 end /*reset & enable 的优先级？*/


endmodule

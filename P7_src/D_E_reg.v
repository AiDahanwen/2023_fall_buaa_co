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
		input start_D,
		input Req,
		input stall,
		input compare_condition_D,
		input BDIn_D,
		input [4:0] D_ExcCode,
		/** data **/
		output reg [31:0] Instr_E,
		output reg [31:0] RD1_E,
		output reg [31:0] RD2_E,
		output reg [31:0] PC_E,
		output reg start_E,
		output reg compare_condition_E,
		output reg [4:0] E_ExcCode,
		output reg BDIn_E,
		output reg [31:0] imm_E
    );
	 
	 initial begin
		Instr_E <= 0;
		RD1_E <= 0;
		RD2_E <= 0;
		imm_E <= 0;
		PC_E <= 0;
		compare_condition_E <= 0;
		E_ExcCode <= 0;
		BDIn_E <= 0;
	 end
	 
	 always@(posedge clk) begin
		if(enable_E) begin
			if(reset||stall||Req) begin
				Instr_E <= 0;
				RD1_E <= 0;
				RD2_E <= 0;
				imm_E <= 0;
				PC_E <= Req ? 32'h0000_4180 : 
				        stall ? PC_D : 32'b0;
				compare_condition_E <= 0;
				start_E <= 0;
				E_ExcCode <= 0;
				BDIn_E <= stall ? BDIn_D : 1'b0;
			end
			else begin
				Instr_E <= Instr_D;
				RD1_E <= RD1_D;
				RD2_E <= RD2_D;
				imm_E <= imm_D;
				PC_E <= PC_D;
				start_E <= start_D;
				compare_condition_E <= compare_condition_D;
				E_ExcCode <= D_ExcCode;
				BDIn_E <= BDIn_D;
			end
		end
	 end 


endmodule

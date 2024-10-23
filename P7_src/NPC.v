`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:08:50 11/03/2023 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [1:0] jump,
    input [31:0] PC_F,
	 input [31:0] PC_D,
	 input [31:0] Imm, //signExtend
	 input [31:0] ra, //
	 input [25:0] partInstr,
    input PCsrc, //in main it is input
	 input [31:0] EPC_out,
	 input eret_check,
	 input Req,
	 output [31:0] next_pc
    );
	 
	 /* PC+4 */
	 wire [31:0] pcRegular;
	 assign pcRegular = PC_F + 4;;
	 
	 /* PCbranch */
	 wire [31:0] pcBranch;
	 assign pcBranch = (Imm << 2) + PC_D + 4;
	 
	 /* pcJump */
	 wire [31:0] pcJump;
	 assign pcJump = {PC_D[31:28],partInstr,2'b00};
	 
	 /* pcBranch or pc+4 */
	 wire [31:0] pc1;
	 assign pc1 = PCsrc ? pcBranch : pcRegular;
	 
	 /*final*/
	 assign next_pc = (Req) ? 32'h0000_4180 :
							(eret_check) ? (EPC_out + 32'd4) :
							(jump == 2'b01) ? pcJump :
							(jump == 2'b10) ? ra : pc1;
	 
endmodule

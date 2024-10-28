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
    input [31:0] this_pc,
	 input [31:0] Imm, //signExtend
	 input [31:0] ra, //此处的ra只是一个代号，外部确实是RD1，因此不存在只能跳ra的bug
	 input [25:0] partInstr,
    input PCsrc, //in main it is input
	 output [31:0] next_pc
    );
	 
	 /* PC+4 */
	 wire [31:0] pcRegular;
	 assign pcRegular = this_pc + 4;
	 
	 /* PCbranch */
	 wire [31:0] pcBranch;
	 assign pcBranch = (Imm << 2) + pcRegular;
	 
	 /* pcJump */
	 wire [31:0] pcJump;
	 assign pcJump = {pcRegular[31:28],partInstr,2'b00};
	 
	 /* pcBranch or pc+4 */
	 wire [31:0] pc1;
	 assign pc1 = (PCsrc == 1) ? pcBranch : pcRegular;
	 
	 /*final*/
	 assign next_pc = (jump == 2'b01) ? pcJump :
							(jump == 2'b10) ? ra : pc1;
	 
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:15 11/02/2023 
// Design Name: 
// Module Name:    Controller 
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
`include "macro.v"
module Controller(
    input [31:0] Instr,
	 /* controller */
	 output [4:0] ALU_op,
	 output [1:0] D2R,
	 output [1:0] width_op,
	 output [4:0] RegWrite,
	 output [4:0] com_op,
	 output [1:0] jump,
	 output imm_ext,
	 output MW,
	 output RW,
	 output signORzero,
	 output Branch,
	 output ALU_srcA,
	 output ALU_srcB,
	 output com_write,
	 /* Hazard */
	 output [1:0] Tuse_A,
	 output [1:0] Tuse_B,
	 output [1:0] Tnew,
	 output useA,
	 output useB,
	 output [4:0] useReg_A,
	 output check_1, //标记特殊跳转
	 output check_2, //标记特殊访存
	 output [4:0] useReg_B
    );
	 
	 /* macro_define */
	 `CODE_IDENTIFY
	 `OP_DEFINE
	/* E */ 	
	 assign ALU_op = (add|addiu|addi|load|write|addu) ? add_op :
						  (sub|subu) ? sub_op :
						  (ori|or_) ? or_op :
							lui ? lui_op : 
							swc ? swc_op : sll_op;
	 assign ALU_srcA = shamt;
	 assign imm_ext = ori ;
	 assign ALU_srcB = I_type | write | load;
	/* W */						
	 assign D2R = {ra,load};
	 wire [1:0] RD;
	 assign RD = {ra,R_type};
	 assign RegWrite = (RD == 2'b10) ? 5'b11111 :
							 (RD == 2'b01) ? Instr[15:11]: Instr[20:16];
							 
	 assign RW = (R_type &&(!jr)) | I_type | load | J_write | bgezal | lhogez;
	 
	 /* D */
	 assign com_op = beq ? beq_op : 
						  bne ? bne_op : 
						  bgezal ? bgezal_op :
						  bonall ? bonall_op : 
						  lhogez ? lhogez_op : 5'b00000;
						  
	 assign Branch = branch;
	 assign com_write = bgezal;
	 
	 /* jump */
	 assign jump = {jump2,jump1};
	 
	 /* M */
	 assign width_op = {bytes,half};
	 assign signORzero = lbu | lhu;
	 assign MW = write; 
	 
	 /* Hazard */
	 assign Tuse_A = ((R_type && (!jr)) | I_type | write | load) ? 2'b01 :
						  (branch | jump2) ? 2'b00 : 2'b11;
	 assign Tuse_B = (write)  ? 2'b10 :
						  (R_type && (!jr)) ? 2'b01 :
						  (branchTwo) ? 2'b00 : 2'b11;
	 assign useA = R_type | I_type | write | load | jump2 | branch;
	 assign useB = (R_type && (!jr)) | write | branchTwo;
	 assign useReg_A = Instr[25:21];
	 assign useReg_B = Instr[20:16];	
	 assign Tnew = ((R_type && (!jr)) | I_type) ? 2'b10 :
						(load) ? 2'b11 : 2'b00;
	/*check*/
	 assign check_1 = bonall ? 1'b1 : 1'b0;
	 assign check_2 = lhogez ? 1'b1 : 1'b0;
	
endmodule

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
	 output RW,
	 output Branch,
	 output ALU_srcA,
	 output ALU_srcB,
	 output com_write,
	 output ctrl_start,
	 /* Hazard */
	 output [1:0] Tuse_A,
	 output [1:0] Tuse_B,
	 output [1:0] Tnew,
	 output useA,
	 output useB,
	 output useMultDiv,
	 output [2:0] op_ctrl,
	 output [4:0] useReg_A,
	 output bslt_check,
	 output check_1, //标记特殊跳转
	 output check_2, //标记特殊访存
	 output [4:0] useReg_B
    );
	 
	 /* macro_define */
	 `CODE_IDENTIFY
	 `OP_DEFINE
	/* E */ 	
	 assign ALU_op = (add|addi|load|write|addu) ? add_op :
						  (sub|subu) ? sub_op :
						  (ori|or_) ? or_op :
						   lui ? lui_op : 
						  (and_|andi) ? and_op :
						   slt ? slt_op : 
							sltu ? sltu_op : 
							mult ? mult_op : 
						   multu ? multu_op :
							div ? div_op : 
							divu ? divu_op :
							mfhi ? mfhi_op :
							mflo ? mflo_op :
							mthi ? mthi_op :
							mtlo ? mtlo_op :  sll_op;
	 assign ALU_srcA = shamt;
	 assign imm_ext = ori | andi ;
	 assign ALU_srcB = I_type | write | load;
	 assign ctrl_start = mult | multu | div | divu ;
		 
	/* W */						
	 assign D2R = {(ra|bslt),load};
	 wire [1:0] RD;
	 assign RD = {ra,R_type};
	 assign RegWrite = (RD == 2'b10) ? 5'b11111 :
							 (RD == 2'b01) ? Instr[15:11]: Instr[20:16];
							 
	 assign RW = (R_type &&(!jr)) | I_type | load | J_write | bgezal | bslt;
	 
	 /* D */
	 assign com_op = beq ? beq_op : 
						  bne ? bne_op : 
						  bgezal ? bgezal_op :
						  bslt ? bslt_op :  5'b00000;
						  
	 assign Branch = branch;
	 assign com_write = bgezal | bslt;
	 
	 /* jump */
	 assign jump = {jump2,jump1};
	 
	 /* M */
	 assign width_op = write ? {sb,sh} : 2'b11 ; //
	 assign op_ctrl = (lw|lsa) ? 3'b000 :
							lbu ? 3'b001 :
							lb ? 3'b010 :
							lhu ? 3'b011 :
							lh ? 3'b100 : 3'b000;
	 
	 /* Hazard */
	 assign Tuse_A = ((R_type && (!jr)&&(!shamt)&&(!bslt)) | I_type | write | load) ? 2'b01 :
						  (branch | jump2) ? 2'b00 : 2'b11;
	 assign Tuse_B = (write)  ? 2'b10 :
						  (R_type && (!jr)&&(!bslt)) ? 2'b01 :
						  (branchTwo) ? 2'b00 : 2'b11;
	 assign useA = (R_type &&(!shamt)) | I_type | write | load | jump2 | branch;
	 assign useB = (R_type && (!jr)) | write | branchTwo;
	 assign useReg_A = Instr[25:21];
	 assign useReg_B = Instr[20:16];	
	 assign Tnew = ((R_type && (!jr)&&(!bslt)) | I_type) ? 2'b10 :
						(load) ? 2'b11 : 2'b01;
 
	 assign useMultDiv = mult | multu | div | divu | mfhi | mflo | mthi | mtlo;
	/*check*/
	 assign check_1 = 1'b0;//清空延迟槽使用
	 assign check_2 = lsa; //条件访存使用
	 assign bslt_check = bslt; //判断bslt
	 
endmodule

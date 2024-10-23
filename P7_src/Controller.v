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
	 output eret_check,
	 output check_1, //标记特殊跳转
	 output check_2, //标记特殊访存
	 output unreserved, //非法指令
	 output lh_check,
	 output lw_check,
	 output lb_check,
	 output sw_check,
	 output sh_check,
	 output sb_check,
	 output add_sub_check,
	 output loadd,
	 output store,
	 output mfc0_check,
	 output mtc0_check,
	 output syscall_check,
	 output ll_check,
	 output sc_check,
	 output [4:0] rdReg,
	 output [4:0] useReg_B
    );
	 
	 /* macro_define */
	 `CODE_IDENTIFY
	 `OP_DEFINE
	/* E */ 	
	 assign ALU_op = (add|addi|load|write|addiu) ? add_op :
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
	 assign D2R = {ra,load};
	 wire [1:0] RD;
	 assign RD = {ra,R_type};
	 assign RegWrite = (RD == 2'b10) ? 5'b11111 :
							 (RD == 2'b01) ? Instr[15:11]: Instr[20:16];
							 
	 assign RW = (R_type &&(!jr)) | I_type | load | J_write | bgezal | mfc0 | sc;
	 
	 /* D */
	 assign com_op = beq ? beq_op : 
						  bne ? bne_op : 
						  bgezal ? bgezal_op : 5'b00000;
						  
	 assign Branch = branch;
	 assign com_write = bgezal;
	 
	 /* jump */
	 assign jump = {jump2,jump1};
	 
	 /* M */
	 assign width_op = write ? {sb,sh} : 2'b11 ; //
	 assign op_ctrl = (lw|ll) ? 3'b000 :
							lbu ? 3'b001 :
							lb ? 3'b010 :
							lhu ? 3'b011 :
							lh ? 3'b100 : 3'b000;
	 
	 /* Hazard */
	 assign Tuse_A = ((R_type && (!jr)&&(!shamt)) | I_type | write | load) ? 2'b01 :
						  (branch | jump2) ? 2'b00 : 2'b11;
	 assign Tuse_B = (write | mtc0)  ? 2'b10 :
						  (R_type && (!jr)) ? 2'b01 :
						  (branchTwo) ? 2'b00 : 2'b11;
	 assign useA = (R_type &&(!shamt)) | I_type | write | load | jump2 | branch;
	 assign useB = (R_type && (!jr)) | write | branchTwo | mtc0;
	 assign useReg_A = Instr[25:21];
	 assign useReg_B = Instr[20:16];	
	 assign Tnew = ((R_type && (!jr)) | I_type | mfc0) ? 2'b10 :
						(load|sc) ? 2'b11 : 2'b00;
 
	 assign useMultDiv = mult | multu | div | divu | mfhi | mflo | mthi | mtlo;
	/*check*/
	 assign check_1 = 1'b0;//清空延迟槽使用
	 assign check_2 = 1'b0; //条件访存使用
	 /* Exception */
	 assign unreserved = ~(add | sub | and_ | sll | addu | subu | or_ | slt | addiu |
								 sltu | mult | multu | div | divu | mfhi | mflo | mthi | mtlo |
								 ori | addi | andi | lui | addiu | sw | sh | sb | lw | lh | lb |
								 beq | bne | jal | jr | jalr | j | mfc0 | mtc0 | syscall | eret | ll | sc);
	 
	 assign lw_check = lw;
	 assign lh_check = lh;
	 assign lb_check = lb;
	 assign sw_check = sw;
	 assign sh_check = sh;
	 assign sb_check = sb;
	 assign add_sub_check = add | addi | sub;
	 assign loadd = load;
	 assign store = write;
	 assign mfc0_check = mfc0;
	 assign mtc0_check = mtc0;
	 assign eret_check = eret;
	 assign syscall_check = syscall;
	 assign rdReg = Instr[15:11];
	 assign ll_check = ll;
	 assign sc_check = sc;
	 
endmodule

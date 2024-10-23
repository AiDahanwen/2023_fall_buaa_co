`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:00 11/08/2023 
// Design Name: 
// Module Name:    Hazard_Unit 
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
module Hazard_Unit(
		/* SPECIAL STALL */
		input check_E,
		input check_M,
		/* TIME */
		input [1:0] Tuse_A_D,
		input [1:0] Tuse_B_D,
		input [1:0] Tnew_E,
		input [1:0] Tnew_M,
		input useA_D, 
		input useB_D, /* Whether use */
		input [4:0] useReg_A_D,
		input [4:0] useReg_B_D,
		input [4:0] useReg_A_E,
		input [4:0] useReg_B_E,
		input [4:0] useReg_A_M,
		input [4:0] useReg_B_M,
		input [4:0] writeReg_E,
		input [4:0] writeReg_M,
		input [4:0] writeReg_W,
		input RW_E,
		input RW_M, 
		input RW_W,//ensure it was written
		input start,
		input busy,
		input useMultDiv_D,
		/* OUTPUT */
		output [1:0] ForwardA_D,
		output [1:0] ForwardB_D,
		output [1:0] ForwardA_E,
		output [1:0] ForwardB_E,
		output ForwardB_M,
		output stall
    );
	 
	 /* Address */
	 /* D */
	 wire checkA_D_E = (RW_E != 0) && (useReg_A_D == writeReg_E) && (useReg_A_D != 0);
	 wire checkA_D_M = (RW_M != 0) && (useReg_A_D == writeReg_M) && (useReg_A_D != 0);
	 wire checkB_D_E = (RW_E != 0) && (useReg_B_D == writeReg_E) && (useReg_B_D != 0);
	 wire checkB_D_M = (RW_M != 0) && (useReg_B_D == writeReg_M) && (useReg_B_D != 0);
	 
	 /*SPECIAL_CHECK_TYPE1*/
	 /*条件访存，满足条件写一个寄存器，不满足条件写另一个寄存器
	 wire spcl_check_A_E_1 = (RW_E != 0) && ((useReg_A_D == writeReg_E)|(useReg_A_D == 5'b11111)) && (useReg_A_D != 0) && check_E;
	 wire spcl_check_B_E_1 = (RW_E != 0) && ((useReg_B_D == writeReg_E)|(useReg_B_D == 5'b11111)) && (useReg_B_D != 0) && check_E;
	 wire spcl_check_A_M_1 = (RW_M != 0) && ((useReg_A_D == writeReg_M)|(useReg_A_D == 5'b11111)) && (useReg_A_D != 0) && check_M;
	 wire spcl_check_B_M_1 = (RW_M != 0) && ((useReg_B_D == writeReg_M)|(useReg_B_D == 5'b11111)) && (useReg_B_D != 0) && check_M;
	 
	 SPECIAL_CHECK_TYPE2*/
	 /*条件访存，满足条件写一个寄存器，不满足条件不写寄存器
	 wire spcl_check_A_E_2 = (RW_E != 0) && (useReg_A_D == 5'b11111) && check_E;
	 wire spcl_check_B_E_2 = (RW_E != 0) && (useReg_B_D == 5'b11111) && check_E;
	 wire spcl_check_A_M_2 = (RW_M != 0) && (useReg_A_D == 5'b11111) && check_M;
	 wire spcl_check_B_M_2 = (RW_M != 0) && (useReg_B_D == 5'b11111) && check_M;
	 
	 SPECIAL_CHECK_TYPE3*/
	 /* 条件访存，要写的寄存器只能在最后一个阶段知道*/
	 wire spcl_check_A_E_3 = (RW_E != 0) && ((useReg_A_D != 0) && (useReg_A_D <= 16)) && (check_E);
	 wire spcl_check_B_E_3 = (RW_E != 0) && ((useReg_B_D != 0) && (useReg_B_D <= 16)) && (check_E);
	 wire spcl_check_A_M_3 = (RW_M != 0) && ((useReg_A_D != 0) && (useReg_A_D <= 16)) && (check_M);
	 wire spcl_check_B_M_3 = (RW_M != 0) && ((useReg_B_D != 0) && (useReg_B_D <= 16)) && (check_M);
	 
	 /* E */
	 wire checkA_E_M = (RW_M != 0) && (useReg_A_E == writeReg_M) && (useReg_A_E != 0);
	 wire checkA_E_W = (RW_W != 0) && (useReg_A_E == writeReg_W) && (useReg_A_E != 0);
	 wire checkB_E_M = (RW_M != 0) && (useReg_B_E == writeReg_M) && (useReg_B_E != 0);
	 wire checkB_E_W = (RW_W != 0) && (useReg_B_E == writeReg_W) && (useReg_B_E != 0);
	 
	 /* MultDiv */
	 wire stallMultDiv = useMultDiv_D && (busy|start);
	 
	 /* M */
	 wire checkB_M_W = (RW_W != 0) && (useReg_B_M == writeReg_W) && (useReg_B_M != 0);
	 
	 /* Time */
	 wire TimeA_D_E = Tuse_A_D < Tnew_E;
	 wire TimeA_D_M = Tuse_A_D < Tnew_M;
	 wire TimeB_D_E = Tuse_B_D < Tnew_E;
	 wire TimeB_D_M = Tuse_B_D < Tnew_M;
	 
	 /* Stall */
	 wire stallA_D_E = TimeA_D_E && checkA_D_E && useA_D;
	 wire stallA_D_M = TimeA_D_M && checkA_D_M && useA_D;
	 wire stallB_D_E = TimeB_D_E && checkB_D_E && useB_D;
	 wire stallB_D_M = TimeB_D_M && checkB_D_M && useB_D;
	 /* specialStall TYPE1*/
	 /*第一种条件访存的暂停
	 wire spcl_stall_A_E_1 = spcl_check_A_E_1 && TimeA_D_E && useA_D;
	 wire spcl_stall_B_E_1 = spcl_check_B_E_1 && TimeB_D_E && useB_D;
	 wire spcl_stall_A_M_1 = spcl_check_A_M_1 && TimeA_D_M && useA_D;
	 wire spcl_stall_B_M_1 = spcl_check_B_M_1 && TimeB_D_M && useB_D;
	 SPCIALSTALL TYPE2*/
	 /*第二种条件访存的暂停
	 wire spcl_stall_A_E_2 = spcl_check_A_E_2 && TimeA_D_E && useA_D;
	 wire spcl_stall_B_E_2 = spcl_check_B_E_2 && TimeB_D_E && useB_D;
	 wire spcl_stall_A_M_2 = spcl_check_A_M_2 && TimeA_D_M && useA_D;
	 wire spcl_stall_B_M_2 = spcl_check_B_M_2 && TimeB_D_M && useB_D;
	 SPECIALSTALL TYPE3
	 第三种条件访存的暂停，只要是就暂停 */
	 wire spcl_stall_A_E_3 = spcl_check_A_E_3 && TimeA_D_E && useA_D;
	 wire spcl_stall_B_E_3 = spcl_check_B_E_3 && TimeB_D_E && useB_D;
	 wire spcl_stall_A_M_3 = spcl_check_A_M_3 && TimeA_D_M && useA_D;
	 wire spcl_stall_B_M_3 = spcl_check_B_M_3 && TimeB_D_M && useB_D;
	 
	// wire spcl_stall_1 = spcl_stall_A_E_1|spcl_stall_B_E_1|spcl_stall_A_M_1|spcl_stall_B_M_1;
	// wire spcl_stall_2 = spcl_stall_A_E_2|spcl_stall_B_E_2|spcl_stall_A_M_2|spcl_stall_B_M_2;
	 wire spcl_stall_3 = spcl_stall_A_E_3|spcl_stall_B_E_3|spcl_stall_A_M_3|spcl_stall_B_M_3;
	// wire spcl_stall = spcl_stall_1|spcl_stall_2|spcl_stall_3;
	
	 /*Finall*/
	 assign stall = stallA_D_E | stallA_D_M | stallB_D_E | stallB_D_M | stallMultDiv | spcl_stall_3;
	 //assign stall = stallA_D_E | stallA_D_M | stallB_D_E | stallB_D_M |spcl_stall|| stallMultDiv;
	 
	 /* Forward */
	 /*处理条件访存的转发*/
	/* assign ForwardA_D = (checkA_D_M) ? 2'b01 :
								(checkA_D_E) ? 2'b11 : 2'b00; 
								
	 assign ForwardA_E = (checkA_E_M) ? 2'b01 : 
								(checkA_E_W) ? 2'b10 : 2'b00;
								
	 assign ForwardB_D = (checkB_D_M) ? 2'b01 :
								(checkB_D_E) ? 2'b11 : 2'b00;
								
	 assign ForwardB_E = (checkB_E_M) ? 2'b01 :
								(checkB_E_W) ? 2'b10 : 2'b00; //IF LWREV NOT FORWARD*/
								
	 assign ForwardA_D = (checkA_D_M &&(~check_M)) ? 2'b01 :
								(checkA_D_E &&(~check_E)) ? 2'b11 : 2'b00; 
								
	 assign ForwardA_E = (checkA_E_M &&(~check_M)) ? 2'b01 : 
								(checkA_E_W) ? 2'b10 : 2'b00;
								
	 assign ForwardB_D = (checkB_D_M &&(~check_M)) ? 2'b01 :
								(checkB_D_E &&(~check_E)) ? 2'b11 : 2'b00;
								
	 assign ForwardB_E = (checkB_E_M &&(~check_M)) ? 2'b01 :
								(checkB_E_W) ? 2'b10 : 2'b00; //IF LWREV NOT FORWARD*/
	 
	 assign ForwardB_M = (checkB_M_W) ? 1 : 0;
		
endmodule

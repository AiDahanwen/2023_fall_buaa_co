`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:27:49 11/03/2023 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
	 input reset,
	 input  [31:0] i_inst_rdata, //32位指令
	 input  [31:0] m_data_rdata, //被输入DM中的数据
	 output [31:0] i_inst_addr, //PC
	 output [31:0] m_data_addr, //输出DM地址
	 output [31:0] m_data_wdata, //要写入DM中的数据
	 output [3:0]  m_data_byteen, //四位字节使能
	 output [31:0] m_inst_addr, //M级PC
	 output w_grf_we, //GRF写使能信号
	 output [4:0] w_grf_addr, //待写入的寄存器地址
	 output [31:0] w_grf_wdata, //待写入数据
	 output [31:0] w_inst_addr //W级PC
    ); 
	 
	 /* Hazard Unit*/
	 wire [1:0] ForwardA_D;
	 wire [1:0] ForwardB_D;
	 wire [1:0] ForwardA_E;
	 wire [1:0] ForwardB_E;
	 wire stall;
	 wire useA_D;
	 wire useB_D;
	 wire [4:0] useReg_A_D;
	 wire [4:0] useReg_B_D;
	 wire [1:0] Tnew_E;
	 wire [1:0] Tnew_M;
	 wire RW_M;
	 wire RW_W;
	 wire RW_E;
	 wire [4:0] useReg_A_M;
	 wire [4:0] useReg_B_M;
	 wire [4:0] writeReg_M;
	 wire [4:0] writeReg_W;
	 wire [4:0] writeReg_E;
	 wire [1:0] Tuse_A_D;
	 wire [1:0] Tuse_B_D;
	 wire [4:0] useReg_A_E;
	 wire [4:0] useReg_B_E;
	 wire ForwardB_M;
	 wire check_E;
	 wire chekc_M;
	 wire start_E;
	 wire busy;
	 wire useMultDiv_D;
	
	 Hazard_Unit hazard_mips (
    .Tuse_A_D(Tuse_A_D), 
    .Tuse_B_D(Tuse_B_D), 
    .Tnew_E(Tnew_E), 
    .Tnew_M(Tnew_M), 
    .useA_D(useA_D), 
    .useB_D(useB_D), 
    .useReg_A_D(useReg_A_D), 
    .useReg_B_D(useReg_B_D), 
    .useReg_A_E(useReg_A_E), 
    .useReg_B_E(useReg_B_E), 
    .useReg_A_M(useReg_A_M), 
    .useReg_B_M(useReg_B_M), 
    .writeReg_E(writeReg_E), 
    .writeReg_M(writeReg_M), 
    .writeReg_W(writeReg_W), 
	 .check_E(check_E),
	 .check_M(check_M),
    .RW_E(RW_E), 
    .RW_M(RW_M), 
    .RW_W(WE), 
	 .start(start_E),
	 .busy(busy),
	 .useMultDiv_D(useMultDiv_D),
    .ForwardA_D(ForwardA_D), //转发到D阶段
    .ForwardB_D(ForwardB_D), 
    .ForwardA_E(ForwardA_E), //转发到E阶段
    .ForwardB_E(ForwardB_E), 
    .ForwardB_M(ForwardB_M), 
	 .stall(stall)
    );
	 
	/* F phase */

	/* PC */
	wire [1:0] jump_D;
	wire [31:0] next_pc;
	wire [31:0] PC_F;
	PC pc_mips (
    .next_pc(next_pc), 
    .PC(PC_F), 
    .reset(reset), 
    .clk(clk), 
    .enable_PC(!stall)
    );
	 
	/* IM */ 
	wire [31:0] Instr_F;
	assign i_inst_addr = PC_F;
	assign Instr_F = i_inst_rdata;
	 
	 /* F_D_REG */
	 wire [31:0] Instr_D;
	 wire [31:0] PC_D;
	 wire delay_flush;
	 F_D_reg D_mips (
    .Instr_F(Instr_F), 
	 .PC_F(PC_F),
    .clk(clk), 
    .reset(reset | delay_flush), 
    .enable_D(!stall), 
    .Instr_D(Instr_D), 
	 .PC_D(PC_D)
    );
	 
	 /* D PHASE *///每个阶段选择性的输出信号，不用全部输出连线
	 /*controller_D */
	 wire [4:0] writeReg_D;
	 wire [4:0] com_op_D;
	 wire RW_D;
	 wire Branch_D;
	 wire com_write_D;
	 wire check_1_D;
	 wire start_D;
	 wire bslt_check;
	 Controller controller_D (
    .Instr(Instr_D),  
    .RegWrite(writeReg_D), 
    .com_op(com_op_D), 
	 .jump(jump_D),
    .RW(RW_D), 
    .Branch(Branch_D), 
    .com_write(com_write_D), 
    .Tuse_A(Tuse_A_D), 
    .Tuse_B(Tuse_B_D),  
    .useA(useA_D), 
    .useB(useB_D), 
	 .ctrl_start(start_D),
	 .bslt_check(bslt_check),
    .useReg_A(useReg_A_D), 
    .useReg_B(useReg_B_D),
	 .useMultDiv(useMultDiv_D)
    );
	 
	 /*compare*/
	 wire compare_condition_D;
	 wire [31:0] Forward_srcA;
	 wire [31:0] Forward_srcB;
	
	 assign Forward_srcA = (ForwardA_D == 2'b01) ? WD_M :
								  (ForwardA_D == 2'b11) ? WD_E : RD1_D;
	 assign Forward_srcB = (ForwardB_D == 2'b01) ? WD_M :
							     (ForwardB_D == 2'b11) ? WD_E : RD2_D;
							 
	 Compare compare_mips (
    .com_srcA(Forward_srcA), 
    .com_srcB(Forward_srcB), 
    .com_op(com_op_D), 
    .compare_condition(compare_condition_D)
    );
	 
	 /*清空延迟槽*/
	 assign delay_flush = check_1_D && ~stall && ~compare_condition_D;
	 
	 /* PCsrc */
	 wire PCsrc;
	 assign PCsrc = Branch_D & compare_condition_D;

	 /*GRF*/
	 wire [31:0] RD1_D;
	 wire [31:0] RD2_D;
	 wire [4:0] A1;
	 wire [4:0] A2;
	 wire [4:0] A3;
	 wire [31:0] WD;
	 wire [31:0] PC_W;
	 assign A1 = useReg_A_D;
	 assign A2 = useReg_B_D;
	 assign A3 = writeReg_W;
	 wire com_write_W;
	 wire compare_condition_W;
	 //assign WE = RW_W;
	 
	 assign WE = RW_W && ((!com_write_W) | compare_condition_W);	
	 
	 GRF grf_mips (
    .A1(A1), 
    .A2(A2), 
    .A3(A3), //A3即为要写的寄存器
    .WD(WD), 
    .PC(PC_W), 
    .clk(clk), 
    .reset(reset), 
    .WE(WE), 
    .RD1(RD1_D), 
    .RD2(RD2_D)
    );
		
	 /* npc */
	 wire [31:0] sign_imm;
	 assign sign_imm = {{16{Instr_D[15]}},Instr_D[15:0]};
	 wire [25:0] partInstr;
	 assign partInstr = Instr_D[25:0];
	 wire [31:0] jumpReg;
	 assign jumpReg = bslt_check ? (Forward_srcA + Forward_srcB) : Forward_srcA;
	
	 NPC npc_mips(
     .jump(jump_D),
	  .PC_F(PC_F),
     .PC_D(PC_D), 
     .Imm(sign_imm), 
     .ra(jumpReg), 
	  .bslt(bslt_check),
     .partInstr(partInstr),
     .PCsrc(PCsrc), 
     .next_pc(next_pc)
     );
		
	 /*D_E_REG*/
	 wire [31:0] Instr_E;
	 wire [31:0] RD1_E;
	 wire [31:0] RD2_E;
	 wire [31:0] imm_E;
	 wire [31:0] PC_E;
	 wire compare_condition_E;
	 
	 D_E_reg E_mips (
	 .RD1_D(Forward_srcA),
	 .RD2_D(Forward_srcB),
    .Instr_D(Instr_D),
	 .PC_D(PC_D),
	 .compare_condition_D(compare_condition_D),
	 .start_D(start_D),
    .clk(clk), 
    .reset(reset | stall), 
    .enable_E(1'b1),
    .Instr_E(Instr_E), 
	 .RD1_E(RD1_E),
	 .RD2_E(RD2_E),
	 .PC_E(PC_E),
	 .start_E(start_E),
	 .compare_condition_E(compare_condition_E)
    );

	 
	 /* E PHASE */
	 /*controller*/
	 
	 wire [4:0] ALU_op_E;
	 wire ALU_srcA_E;
	 wire ALU_srcB_E;
	 wire imm_ext_E;
	 wire [1:0] Tnew_ori_E;
	 wire RW_E_ori;
	// assign RW_E = RW_E_ori;
	 assign RW_E = RW_E_ori && ((!com_write_E) | compare_condition_E);	
	 
	 assign Tnew_E = (Tnew_ori_E == 3) ? 2'b10 :
					     (Tnew_ori_E == 2) ? 2'b01 :
			    	     (Tnew_ori_E == 1) ? 2'b00 : 2'b00;
						  
	 wire [1:0] D2R_E;
	 assign WD_E = (D2R_E == 2'b10) ? (PC_E + 8) : 32'bz;
	
	Controller controller_E(
    .Instr(Instr_E), 
	 .RegWrite(writeReg_E),
    .ALU_op(ALU_op_E),  
    .ALU_srcA(ALU_srcA_E), 
	 .imm_ext(imm_ext_E),
    .ALU_srcB(ALU_srcB_E),  
    .useA(useA_E), 
    .useB(useB_E), 
    .useReg_A(useReg_A_E), 
    .useReg_B(useReg_B_E),
	 .RW(RW_E_ori),
	 .D2R(D2R_E),
	 .com_write(com_write_E),
	 .check_2(check_E),
	 .Tnew(Tnew_ori_E)
    );
	 
	 /*imm*/
	 assign imm_E = (imm_ext_E == 1) ? {16'b0,Instr_E[15:0]} :
					  {{16{Instr_E[15]}},Instr_E[15:0]};
	 
	 /* ALU */
	 wire [31:0] ALU_result_E;
	 wire [31:0] srcA_fore;
	 wire [31:0] srcA;
	 wire [31:0] srcB_fore;
	 wire [31:0] srcB;
	 wire [4:0] shamt;
	 wire [31:0] WD_M;
	 assign shamt = Instr_E[10:6];
	 assign srcA_fore = (ForwardA_E == 2'b01) ? (WD_M) : 
					        (ForwardA_E == 2'b10) ? WD : RD1_E;
	 assign srcA = (ALU_srcA_E == 1) ? shamt : srcA_fore;
	 assign srcB_fore = (ForwardB_E == 2'b01) ? (WD_M) :
						     (ForwardB_E == 2'b10) ? WD : RD2_E;
	 assign srcB = (ALU_srcB_E == 1) ? imm_E : srcB_fore;				
	 
	 ALU alu_mips (
    .ALU_op(ALU_op_E), 
    .srcA(srcA), 
    .srcB(srcB), 
    .result(ALU_result_E)
    );
	 
	 wire [31:0] multdiv_res_E;
	 MultDiv multdiv (
    .clk(clk), 
    .reset(reset), 
    .start(start_E), 
    .srcA(srcA), 
    .srcB(srcB), 
    .ALU_op(ALU_op_E), 
    .busy(busy), 
    .multdiv_res(multdiv_res_E)
    );
	 
	 /* E_M_REG */
	 wire [31:0] Instr_M;
	 wire [31:0] writeData_M_ori; //sw类指令
	 wire [31:0] ALU_result_M;
	 wire [31:0] PC_M;
	 wire compare_condition_M;
	 wire [31:0] multdiv_res_M; 
	 
	 E_M_reg M_mips (
    .clk(clk), 
    .reset(reset), 
    .enable(1'b1), 
    .Instr_E(Instr_E), 
	 .compare_condition_E(compare_condition_E),
	 .PC_E(PC_E),
    .ALU_result_E(ALU_result_E), 
	 .multdiv_res_E(multdiv_res_E),
    .writeData_E(srcB_fore), 
    .Instr_M(Instr_M), 
    .ALU_result_M(ALU_result_M), 
	 .PC_M(PC_M),
	 .compare_condition_M(compare_condition_M),
	 .multdiv_res_M(multdiv_res_M),
    .writeData_M(writeData_M_ori)
    );
	 
	 /* M PHASE */
	 /* controller_M */
	 wire [1:0] width_op_M;
	 wire MW_M;
	 wire signORzero_M;
	 wire com_write_M;
	 wire useMultDiv_M;
	 wire [1:0] Tnew_ori_M;
	 assign Tnew_M = (Tnew_ori_M == 3) ? 2'b01 :
						  (Tnew_ori_M == 2) ? 2'b00 : 2'b0;
						   
	 wire [1:0] D2R_M;
	 assign WD_M = (D2R_M == 2'b10) ? (PC_M + 8) : 
						(useMultDiv_M) ? (multdiv_res_M) : ALU_result_M;
	 
	 wire RW_M_ori;
	 //assign RW_M = RW_M_ori;
	 assign RW_M = RW_M_ori && ((!com_write_M) | compare_condition_M);	
	 
	 wire [2:0] op_ctrl_M;
	 Controller controller_M (
    .Instr(Instr_M), 
    .width_op(width_op_M),   
    .Tnew(Tnew_ori_M), 
    .useA(useA_M), 
    .useB(useB_M), 
    .useReg_A(useReg_A_M), 
    .useReg_B(useReg_B_M),
	 .D2R(D2R_M),
	 .useMultDiv(useMultDiv_M),
	 .RW(RW_M_ori),
	 .op_ctrl(op_ctrl_M),
	 .com_write(com_write_M),
	 .check_2(check_M),
	 .RegWrite(writeReg_M)
    );
	 /* DM */
	 wire [31:0] readData_M;//√
	 wire [31:0] writeData_M;//√
	 assign writeData_M = (ForwardB_M == 1'b1) ? WD : writeData_M_ori;
	 wire [1:0] addr_low;
	 assign addr_low = ALU_result_M[1:0];
	 
	 DM_Read dmread (
    .m_data_rdata(m_data_rdata), //读到的数据 
    .addr_low(addr_low), //地两位地址
    .op_ctrl(op_ctrl_M), //controller生成
    .pro_data(readData_M) //readData_M是最终写入寄存器的值
    );
	 
	 DM_Write dmwrite (
    .addr_low(addr_low), 
    .width_op(width_op_M), //controller生成
    .m_data_byteen(m_data_byteen), //输出
    .m_raw_wdata(writeData_M), //要写入内存的数据，来自寄存器
    .m_data_wdata(m_data_wdata) //最终写入内存中的数据
    );

	 
	 /* M_W_REG */
	 wire [31:0] readData_W;
	 wire [31:0] Instr_W;
	 wire [31:0] ALU_result_W;
	 wire [31:0] multdiv_res_W;
	 M_W_reg W_mips (
	 .Instr_M(Instr_M),
	 .PC_M(PC_M),
    .enable_W(1'b1), 
    .reset(reset), 
    .clk(clk), 
	 .compare_condition_M(compare_condition_M),
    .readData_M(readData_M), 
    .ALU_result_M(ALU_result_M), 
	 .multdiv_res_M(multdiv_res_M),
    .Instr_W(Instr_W), 
    .readData_W(readData_W), 
	 .PC_W(PC_W),
	 .compare_condition_W(compare_condition_W),
	 .multdiv_res_W(multdiv_res_W),
    .ALU_result_W(ALU_result_W)
    );
	
	/* WRITEBACK PHASE */
	/* controller_W */
	 wire [1:0] D2R_W;
	 wire [4:0] com_op_W;
	 wire [4:0] writeReg_W_ori;
	 wire useMultDiv_W;
	Controller controller_W (
    .Instr(Instr_W), 
    .D2R(D2R_W),  
    .RegWrite(writeReg_W_ori),   
    .RW(RW_W),
	 .check_2(check_W),
	 .com_op(com_op_W),
	 .useMultDiv(useMultDiv_W),
	 .com_write(com_write_W)
    );
	 
	 wire compare_condition_WW;
	 wire [31:0] com_srcB_W;

	 Compare Compare_W (
    .com_srcA(readData_W), 
    .com_srcB(com_srcB_W), 
    .com_op(com_op_W), 
    .compare_condition(compare_condition_WW) //和流水下来的compare区分
    );
	 
	 reg [31:0] caluReg;
	 wire [31:0] tempReg;
	 assign tempReg = (caluReg + 16) >> 1;
	 assign writeReg_W = check_W ? tempReg[4:0] : writeReg_W_ori;

	// assign writeReg_W = (check_W && compare_condition_WW) ? Instr_W[20:16] :
								//(check_W && !compare_condition_WW) ? 5'b11111 : writeReg_W_ori;
	 
	 /*以下是条件访存的第三种类型*/
	 //wire [4:0] spcl_RD;
	 //assign spcl_RD = {1'b0,readData_W[3:0]};
	 //assign writeReg_W = check_W ? spcl_RD : writeReg_W_ori;
	 //wire [31:0] rt_ext;
	 //assign rt_ext = {27'b0,Instr_W[20:16]};
	 
	 /*以下是条件访存的第一种类型,第二种类型的WD还是一样的，但是writeReg的话需要改成0号寄存器*/
	 wire [31:0] WD_ori;
	 assign WD_ori = (D2R_W == 2'b01) ? (readData_W) :
			           (D2R_W == 2'b10) ? (PC_W + 8) : 
						  (useMultDiv_W) ? multdiv_res_W : ALU_result_W;
	assign WD = WD_ori;
	// assign WD = (check_W && compare_condition_WW) ? readData_W : 
				   // (check_W && !compare_condition_WW) ? (PC_W + 4) : WD_ori;

    /*output*/
	 assign m_data_addr = ALU_result_M;
	 assign m_inst_addr = PC_M;
	 assign w_grf_we = WE;
	 assign w_grf_addr = writeReg_W;
	 assign w_grf_wdata = WD;
	 assign w_inst_addr = PC_W;
	 
	 
	 integer i;
	 always@(*)
	 begin
			caluReg = 32'b0;
			for(i=0;i<31;i=i+2) begin
				caluReg = caluReg + readData_W[i+1] - readData_W[i];
			end
	 end
	 
	 //{hi,lo} <= $signed({hi,lo}) - $signed($signed(64'd0)+$signed(srcA) * $signed(srcB));
	 
endmodule

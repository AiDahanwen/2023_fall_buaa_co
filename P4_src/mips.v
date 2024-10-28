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
    input reset
    );
	
	/* PC */ 
	wire [31:0] PC;
	wire [31:0] next_pc;
	PC pc_mips (
    .next_pc(next_pc),  // the name in() is the wire connected to the port
    .PC(PC), 
    .reset(reset), 
    .clk(clk)
    );
	 
	/* IM */
	wire [31:0] Instr;
	IM im_mips (
    .PC(PC), 
    .Instr(Instr)
    );
	 
	 /* controller */
	 wire [4:0] ALU_op;
	 wire [1:0] D2R;
	 wire [1:0] width_op;
	 wire [1:0] RD;
	 wire [4:0] com_op;
	 wire [1:0] jump;
	 wire imm_ext;
	 wire MW;
	 wire RW;
	 wire signORzero;
	 wire Branch;
	 wire add3000;
	 wire ALU_srcA;
	 wire ALU_srcB;
	 wire com_write;
	 Controller controller_mips (
    .Instr(Instr), 
    .ALU_op(ALU_op), 
    .D2R(D2R), 
    .width_op(width_op), 
    .RD(RD), 
    .com_op(com_op), 
    .jump(jump), 
    .imm_ext(imm_ext), 
    .MW(MW), 
    .RW(RW), 
    .signORzero(signORzero), 
    .Branch(Branch), 
    .add3000(add3000), 
    .ALU_srcA(ALU_srcA), 
    .ALU_srcB(ALU_srcB), 
    .com_write(com_write)
    );

	/* divide Instr*/
	wire [4:0] A1;
	wire [4:0] A2;
	wire [4:0] A3;
	wire [4:0] rd;
	wire [4:0] rt;
	wire [15:0] Imm;
	wire [4:0] shamt;
	wire [25:0] partInstr;
	wire [31:0] signedImm;
	wire [31:0] zeroImm;
	wire [31:0] signedShamt;
	
	assign A1 = Instr[25:21];
	assign A2 = Instr[20:16];
	assign rt = Instr[20:16];
	assign rd = Instr[15:11];
	assign Imm = Instr[15:0];
	assign signedImm = {{16{Imm[15]}},Imm};
	assign zeroImm = {{16{1'b0}},Imm};
	assign shamt = Instr[10:6];
	assign signedShamt = {{27{shamt[4]}},shamt};
	
	assign A3 = (RD == 2'b01) ? rd :
					(RD == 2'b10) ? 5'b11111 : rt;
	//$display Regaddr
	
	 /* ALU */
	 wire [31:0] srcA;
	 wire [31:0] srcB;
	 wire [31:0] extend_imm;
	 wire [31:0] result;
	 assign extend_imm = (imm_ext == 1) ? zeroImm : signedImm;
	 assign srcA = (ALU_srcA == 1) ? signedShamt : RD1;
	 assign srcB = (ALU_srcB == 1) ? extend_imm : RD2;
	 ALU alu_mips (
    .ALU_op(ALU_op), 
    .srcA(srcA), 
    .srcB(srcB), 
    .result(result)
    );
	
	
	/*Compare*/
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [31:0] com_srcA;
	wire [31:0] com_srcB;
	assign com_srcA = RD1;
	assign com_srcB = RD2;
	wire compare_condition;
	Compare compare_mips (
    .com_srcA(com_srcA), 
    .com_srcB(com_srcB), 
    .com_op(com_op), 
    .compare_condition(compare_condition)
    );
	 
	
	/* GRF */
	wire [31:0] WD;
	//wire [31:0] readdata_1;
	//assign readdata_1 = (readdata[1:0] == 2'b00)? readdata : 32'b0;
	assign WD = (D2R == 2'b01) ? readData : 
					(D2R == 2'b10) ? (PC + 32'h0000_0004) : result;
	wire WE_R;
	assign WE_R = RW & ( (!com_write) | compare_condition);
	
	GRF grf_mips(
    .A1(A1), 
    .A2(A2), 
    .A3(A3), 
    .WD(WD), 
    .PC(PC), 
    .clk(clk), 
    .reset(reset), 
    .WE(WE_R), 
    .RD1(RD1), 
    .RD2(RD2)
    );
	 
	 /*DM*/
	 wire [31:0] Address;
	 wire [31:0] writeData;
	 wire WE_M;
	 wire [31:0] readData;
	 assign WE_M = MW;
	 assign Address = result;
	 assign writeData = RD2;
	 DM dm_mips (
	 .PC(PC),
    .Address(Address), 
    .writeData(writeData), 
    .width_op(width_op), 
    .clk(clk), 
    .reset(reset), 
    .WE(WE_M), 
    .readData(readData)
    );
	 
	 /* NPC */
	 wire[31:0] this_pc;
	 assign this_pc = PC;
	 wire [31:0] ra;
	 assign ra = RD1;
	 assign partInstr = Instr[25:0];
	 wire PCsrc;
	 assign PCsrc = compare_condition & Branch;
	 NPC npc_mips (
    .jump(jump), 
    .this_pc(this_pc), 
    .Imm(signedImm), 
    .ra(ra), 
    .partInstr(partInstr), 
    .PCsrc(PCsrc), 
    .next_pc(next_pc)
    );
	 
	 function Equal(
		input [31:0] lb_data
	 );
	 integer i;
	 reg [4:0] sum;
	 begin
		sum = 5'b0;
		for(i=0;i<8;i=i+1) begin
			sum = sum + lb_data[i];
		end
		Equal = (sum==5'b00100);
	 end
	 endfunction
endmodule

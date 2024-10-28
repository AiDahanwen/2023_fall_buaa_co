`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:53:36 11/04/2023 
// Design Name: 
// Module Name:    print_info 
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
module print_info(
    input [31:0] Instr,
    input clk,
    input [31:0] PC,
    input [31:0] next_pc,
    input compare_condition,
    input [31:0] RD1,
    input [31:0] RD2
    );
	 
	 `CODE_IDENTIFY
	 
	wire [15:0] imm;
	wire [4:0] rd;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [25:0] addr;
	assign addr = Instr[25:0];
	assign rd = Instr[15:11];
	assign rs = Instr[25:21];
	assign rt = Instr[20:16];
	assign imm = Instr[15:0];
	
	always@(posedge clk) begin
		if(sll) begin
			if(Instr == 0) begin
				$display("\nI%h: nop",PC);
			end
		end
		if(add) begin
			$display("\nI%h: add $%0d,$%0d,$%0d",PC,rd,rt,rs);
		end
		if(sub) begin
			$display("\nI%h: sub $%0d,$%0d,$%0d",PC,rd,rt,rs);
		end
		if(lw) begin
			$display("\nI%h: lw $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(sw) begin
			$display("\nI%h: sw $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(addi) begin
			$display("\nI%h: addi $%0d,$%0d,%0d",PC,rt,rs,imm);
		end
		if(addiu) begin
			$display("\nI%h: addiu $%0d,$%0d,%0d",PC,rt,rs,imm);
		end
		if(ori) begin
			$display("\nI%h: ori $%0d,$%0d,%0d",PC,rt,rs,imm);
		end
		if(lui) begin
			$display("\nI%h: lui $%0d,%0d",PC,rt,imm);
		end
		if(beq) begin
			$display("\nI%h: beq $%0d,$%0d,%0d",PC,rs,rt,imm);
		end
		if(jal) begin
			$display("\nI%h: jal %h",PC,addr);
		end
		if(jr) begin
			$display("\nI%h: jr $%0d",PC,rs);
		end
		if(lh) begin
			$display("\nI%h: lh $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(lhu) begin
			$display("\nI%h: lhu $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(lb) begin
			$display("\nI%h: lb $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(lbu) begin
			$display("\nI%h: lbu $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(sb) begin
			$display("\nI%h: sb $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(sh) begin
			$display("\nI%h: sh $%0d,%0d($%0d)",PC,rt,imm,rs);
		end
		if(bne) begin
			$display("\nI%h: bne $%0d,$%0d,%h",PC,rs,rt,imm);
		end
		if(bgezal) begin
			$display("\nI%h: bgezal $%0d,%h",PC,rs,imm);
		end
		if(j) begin
			$display("\nI%h: j %h",PC,imm);
		end
		if(branch) begin  //条件跳转看能否跳转的提示信息
			if(compare_condition) begin
				$display("PC <= %h",next_pc);
			end
			else begin
				$display("PC <x %h",next_pc);
			end
		end
		if((R_type | beq) && (rt!=0)) begin //打印rt【16-20】
			$display("$%d = %h",rt,RD2);
		end
		if(R_type | write | load | (I_type && !lui) | branch | jr)begin //rs[21:25],不管什么跳转都会有rs，实际上就是打印A1
			$display("$%d = %h",rs,RD1); //base
		end
		if(write|load) begin
			$display("$%d = %h",rt,RD2);
		end
	end

endmodule

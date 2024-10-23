`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:59:44 12/01/2023 
// Design Name: 
// Module Name:    CP0 
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
`define IM SR[15:10] //中断屏蔽，1是允许中断，0是禁止中断
`define EXL SR[1] //1代表开始处理异常，不允许再中断，否则允许中断
`define IE SR[0] //全局中断使能
`define BD Cause[31] //是否是延迟槽中指令出现异常
`define IP Cause[15:10] //记录哪些硬件中断有效
`define ExcCode Cause[6:2] //记录当前发生的是什么异常

module CP0(
	input clk,
	input reset,
	input [4:0] A1, //读CP0寄存器编号
	input [4:0] A2, //写CP0寄存器编号
	input [31:0] W_Data, //要写入CP0寄存器的数据
	input [4:0] ExcCodeIn, //中断/异常的类型
	input [31:0] PC_M, //M级PC
	input [5:0] HWInt, //6个设备的中断信号
	input WE_cp0, //CP0写入使能
	input BDIn, //是否是延迟槽指令
	input EXLClr, //复位EXL
	input ll_check,
	output [31:0] EPC_out, //EPC输出
	output [31:0] R_Data, //从CP0里读出的寄存器
	output reg llBit,
	output Req //中断请求
    );
	 
	 reg [31:0] SR; //12
	 reg [31:0] Cause; //13
	 reg [31:0] EPC; //14
	 
	 wire [15:10] im = SR[15:10];
	 wire exl = SR[1];
	 wire ie = SR[0];
	 wire bd = Cause[31];
	 wire [15:10] ip = Cause[15:10];
	 wire [6:2] exccode = Cause[6:2];
	  
	 wire IntReq; //异常来自外部的io控制器
	 assign IntReq = (|(HWInt && `IM)) && (!`EXL) && `IE;
	 
	 wire ExcReq; //异常来自内部指令
	 assign ExcReq = (|ExcCodeIn) && (!`EXL);
	
	 assign Req = IntReq | ExcReq; //最终的中断请求信号
	 
	 initial begin
		SR = 32'b0;
		Cause = 32'b0;
		EPC = 32'b0;
		llBit = 1'b0;
	 end
	 
	 always@(posedge clk) begin
		if(reset) begin
			SR <= 32'b0;
			Cause <= 32'b0;
			EPC <= 32'b0;
			llBit <= 1'b0;
		end
		else if(Req) begin
			`EXL <= 1'b1;
			 EPC <= BDIn ? (PC_M - 32'd4) : PC_M;
			`ExcCode <= IntReq ? 5'd0 : ExcCodeIn; //异常和中断同时发生则中断优先
			`BD <= BDIn;
		end
		else begin
			`IP <= HWInt;
			if(ll_check) begin
				llBit <= 1'b1;
			end
			if(WE_cp0) begin
				case(A2)
					5'd12 : begin
						`IM <= W_Data[15:10];
						`EXL <= W_Data[1];
						`IE <= W_Data[0];
					end
					5'd14 : begin
						EPC <= W_Data;
					end
				endcase
			end
			if(EXLClr) begin
				`EXL <= 1'b0;
				llBit <= 1'b0;
			end
		end
	 end
	 
	 assign EPC_out = EPC;
	 assign R_Data = (A1 == 5'd12) ? SR : 
						  (A1 == 5'd13) ? Cause : 
						  (A1 == 5'd14) ? EPC : 32'd0;
	 
endmodule

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
`define IM SR[15:10] //�ж����Σ�1�������жϣ�0�ǽ�ֹ�ж�
`define EXL SR[1] //1����ʼ�����쳣�����������жϣ����������ж�
`define IE SR[0] //ȫ���ж�ʹ��
`define BD Cause[31] //�Ƿ����ӳٲ���ָ������쳣
`define IP Cause[15:10] //��¼��ЩӲ���ж���Ч
`define ExcCode Cause[6:2] //��¼��ǰ��������ʲô�쳣

module CP0(
	input clk,
	input reset,
	input [4:0] A1, //��CP0�Ĵ������
	input [4:0] A2, //дCP0�Ĵ������
	input [31:0] W_Data, //Ҫд��CP0�Ĵ���������
	input [4:0] ExcCodeIn, //�ж�/�쳣������
	input [31:0] PC_M, //M��PC
	input [5:0] HWInt, //6���豸���ж��ź�
	input WE_cp0, //CP0д��ʹ��
	input BDIn, //�Ƿ����ӳٲ�ָ��
	input EXLClr, //��λEXL
	input ll_check,
	output [31:0] EPC_out, //EPC���
	output [31:0] R_Data, //��CP0������ļĴ���
	output reg llBit,
	output Req //�ж�����
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
	  
	 wire IntReq; //�쳣�����ⲿ��io������
	 assign IntReq = (|(HWInt && `IM)) && (!`EXL) && `IE;
	 
	 wire ExcReq; //�쳣�����ڲ�ָ��
	 assign ExcReq = (|ExcCodeIn) && (!`EXL);
	
	 assign Req = IntReq | ExcReq; //���յ��ж������ź�
	 
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
			`ExcCode <= IntReq ? 5'd0 : ExcCodeIn; //�쳣���ж�ͬʱ�������ж�����
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

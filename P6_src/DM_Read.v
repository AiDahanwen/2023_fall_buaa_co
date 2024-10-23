`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:56:50 11/25/2023 
// Design Name: 
// Module Name:    DM_Read 
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
module DM_Read(
	input  [31:0] m_data_rdata, //读到的初始数据
	input  [1:0] addr_low, //低两位地址
	input  [2:0] op_ctrl,//决定lb/lh以及有无符号
	output [31:0] pro_data //扩展后的数据
    );
	
	wire [7:0]  byte1;
	wire [7:0]  byte2;
	wire [7:0]  byte3;
	wire [7:0]  byte4;
	wire [31:0] lb_1;
	wire [31:0] lb_2;
	wire [31:0] lb_3;
	wire [31:0] lb_4;
	wire [31:0] lbu_1;
	wire [31:0] lbu_2;
	wire [31:0] lbu_3;
	wire [31:0] lbu_4;
	wire [31:0] lh_1;
	wire [31:0] lh_2;
	wire [31:0] lhu_1;
	wire [31:0] lhu_2;
	
	/*byte*/
	assign byte1 = m_data_rdata[7:0];
	assign byte2 = m_data_rdata[15:8];
	assign byte3 = m_data_rdata[23:16];
	assign byte4 = m_data_rdata[31:24];
	
	/*different kinds*/
	assign lbu_1 = {24'b0,byte1};
	assign lbu_2 = {24'b0,byte2};
 	assign lbu_3 = {24'b0,byte3};
	assign lbu_4 = {24'b0,byte4};
	assign lb_1 = {{24{byte1[7]}},byte1};
	assign lb_2 = {{24{byte2[7]}},byte2};
	assign lb_3 = {{24{byte3[7]}},byte3};
	assign lb_4 = {{24{byte4[7]}},byte4};
	
	assign lhu_1 = {16'b0,byte2,byte1};
	assign lhu_2 = {16'b0,byte4,byte3};
	assign lh_1 = {{16{byte2[7]}},byte2,byte1};
	assign lh_2 = {{16{byte4[7]}},byte4,byte3};


	/*simplify*/
	wire [31:0] half_u;
	wire [31:0] byte_u;
	wire [31:0] half_s;
	wire [31:0] byte_s;
	assign half_u = (addr_low[1] == 1'b0) ? lhu_1 : lhu_2;
	assign byte_u = (addr_low == 2'b00) ? lbu_1 :
						 (addr_low == 2'b01) ? lbu_2 :
						 (addr_low == 2'b10) ? lbu_3 : lbu_4;
   assign half_s = (addr_low[1] == 1'b0) ? lh_1 : lh_2;
	assign byte_s = (addr_low == 2'b00) ? lb_1 :
						 (addr_low == 2'b01) ? lb_2 :
						 (addr_low == 2'b10) ? lb_3 : lb_4;
	
	/*result*/
	assign pro_data = (op_ctrl == 3'b000) ? m_data_rdata :
							(op_ctrl == 3'b001) ? byte_u :
							(op_ctrl == 3'b010) ? byte_s :
							(op_ctrl == 3'b011) ? half_u:
							(op_ctrl == 3'b100) ? half_s : 32'b0;

endmodule

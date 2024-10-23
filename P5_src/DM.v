`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:27:03 11/03/2023 
// Design Name: 
// Module Name:    DM 
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
module DM(
	 input [31:0] PC,
    input [31:0] Address,
    input [31:0] writeData, //传进来要写进去的
	 input [1:0] width_op,   //宽度
    input clk,
	 input signORzero,
    input reset,
	 input WE, //condition_write
    output [31:0] readData
    );

	 reg [31:0] DM[0:3071];
	 
	 wire [1:0] op1;
	 assign op1 = Address[1:0]; //one byte
	 wire op2;
	 assign op2 = Address[1];//half word
	 
	 wire [11:0] addr ;
	 assign addr = Address[13:2];//address
	 wire [31:0] read;
	 assign read = DM[addr];
	 
	 /* writedata divide*/
	 wire [7:0] wgroup1;
	 wire [15:0] wgroup2;
	 assign wgroup1 = writeData[7:0];
	 assign wgroup2 = writeData[15:0];
	 
	 /*ReadData divide*/
	 wire [7:0] rgroup1;
	 wire [7:0] rgroup2;
	 wire [7:0] rgroup3;
	 wire [7:0] rgroup4;
	 assign rgroup1 = read[7:0];
	 assign rgroup2 = read[15:8];
	 assign rgroup3 = read[23:16];
	 assign rgroup4 = read[31:24];
	 
	 /*lb,lbu*/
	 wire [7:0] lb_ori;
	 wire [31:0] lb_signext;
	 wire [31:0] lb_zeroext;
	 wire [31:0] lb_read;
	 assign lb_ori = (op1 == 2'b00) ? rgroup1 :
						  (op1 == 2'b01) ? rgroup2 :
						  (op1 == 2'b10) ? rgroup3 : rgroup4;
	 assign lb_signext = {{24{lb_ori[7]}},lb_ori};
	 assign lb_zeroext = {{24{1'b0}},lb_ori};
	 assign lb_read = (signORzero == 1) ? lb_zeroext : lb_signext;
	 
	 /*lh.lhu*/
	 wire [15:0] lh_ori;
	 wire [31:0] lh_signext;
	 wire [31:0] lh_zeroext;
	 wire [31:0] lh_read;
	 assign lh_ori = (op2 == 1) ? {rgroup4,rgroup3} : {rgroup2,rgroup1};
	 assign lh_signext = {{16{lh_ori[15]}},lh_ori};
	 assign lh_zeroext = {16'b0,lh_ori};
	 assign lh_read = (signORzero == 1) ? lh_zeroext : lh_signext;
							 
	 /*sb*/
	 wire [31:0] sb1;
	 wire [31:0] sb2;
	 wire [31:0] sb3;
	 wire [31:0] sb4;
	 wire [31:0] sb_write;
	 assign sb1 = {rgroup4,rgroup3,rgroup2,wgroup1};
	 assign sb2 = {rgroup4,rgroup3,wgroup1,rgroup1};
	 assign sb3 = {rgroup4,wgroup1,rgroup2,rgroup1};
	 assign sb4 = {wgroup1,rgroup3,rgroup2,rgroup1};
	 assign sb_write = (op1 == 2'b00) ? sb1 :
							 (op1 == 2'b01) ? sb2 :
							 (op1 == 2'b10) ? sb3 : sb4;
	 /*sh*/
	 wire [31:0] sh1;
	 wire [31:0] sh2;
	 wire [31:0] sh_write;
	 assign sh1 = {rgroup4,rgroup3,wgroup2};
	 assign sh2 = {wgroup2,rgroup2,rgroup1};
	 assign sh_write = (op2 == 1) ? sh2 : sh1;
	 
	 /*final_read*/
	 assign readData = (width_op == 2'b01) ? lh_read :
							 (width_op == 2'b10) ? lb_read : read;
	 
	 /*final_write*/
	 wire [31:0] write;
	 assign write = (width_op == 2'b01) ? sh_write :
						 (width_op == 2'b10) ? sb_write : writeData;
	 
	 /* loop */
	 integer i;
	 
	 initial begin
		for(i = 0; i < 3072; i=i+1) begin
			DM[i] = 32'h0000_0000;
		end
	 end
	 
	 always@(posedge clk) begin
		if(reset) begin
			for(i = 0; i < 3072; i=i+1) begin
				DM[i] = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
			end
		end
		else if(WE) begin
			DM[addr] <= write;
			$display("%d@%h: *%h <= %h",$time,PC, Address, write);
		end
	 end
	 
endmodule

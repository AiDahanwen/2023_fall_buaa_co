`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:56:34 11/25/2023 
// Design Name: 
// Module Name:    DM_Write 
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
module DM_Write(
	input  [1:0] addr_low,
	input  [1:0] width_op,
	output [3:0]  m_data_byteen,
	input  [31:0] m_raw_wdata, //¼Ä´æÆ÷rtÖÐµÄÖµ
	output [31:0] m_data_wdata
    );
	
	wire [1:0] addr1 = addr_low;
	wire addr2 = addr_low[1];
	
	assign m_data_byteen = (width_op == 2'b00) ? (4'b1111) :
								  (width_op == 2'b01 && addr2 == 1'b1) ? (4'b1100) :
								  (width_op == 2'b01 && addr2 == 1'b0) ? (4'b0011) : 
								  (width_op == 2'b10 && addr1 == 2'b00) ? (4'b0001) :
								  (width_op == 2'b10 && addr1 == 2'b01) ? (4'b0010) :
								  (width_op == 2'b10 && addr1 == 2'b10) ? (4'b0100) :
								  (width_op == 2'b10 && addr1 == 2'b11) ? (4'b1000) : 4'b0000;
	
	wire [7:0] byte1;
	wire [7:0] byte2;
	assign byte1 = m_raw_wdata[7:0];
	assign byte2 = m_raw_wdata[15:8];
	
	assign m_data_wdata = (m_data_byteen == 4'b1111) ? m_raw_wdata :
								 (m_data_byteen == 4'b1100) ? {byte2,byte1,16'b0} :
								 (m_data_byteen == 4'b0011) ? {16'b0,byte2,byte1} :
								 (m_data_byteen == 4'b0001) ? {24'b0,byte1} :
								 (m_data_byteen == 4'b0010) ? {16'b0,byte1,8'b0} :
								 (m_data_byteen == 4'b0100) ? {8'b0,byte1,16'b0} :
								 (m_data_byteen == 4'b1000) ? {byte1,24'b0} : 32'b0;
								
endmodule

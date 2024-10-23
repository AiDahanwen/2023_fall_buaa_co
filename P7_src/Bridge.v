`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:00:00 12/02/2023 
// Design Name: 
// Module Name:    Bridge 
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

module Bridge(
  //实际上修改的就是DM那一段，load和store类都需要修改
 //processorAddr->M级地址
 //processorWritedata -> dmwrite
 //processorWriteByte_En -> byteen_M
 //processorReadData -> 输入进cpu
   input  [31:0] processAddr,
	input  [31:0] processWriteData,
	input   [3:0] processByteen,
	input Req,
	output [31:0] processReadData,
	output  [5:0] HWInt,
	
	input  [31:0] m_data_rdata, //从外界DM中获取的
	output [31:0] m_data_addr,
	output [31:0] m_data_wdata,
	output  [3:0] m_data_byteen,
	
	input  [31:0] T0_Dout,
	input         T0_IRQ,
	output [31:2] T0_Addr,
	output [31:0] T0_Din,
	output        T0_we,
	
	input  [31:0] T1_Dout,
	input         T1_IRQ,
	output [31:2] T1_Addr,
	output [31:0] T1_Din,
	output        T1_we,
	
	input         interrupt,
	output [31:0] m_int_addr,
	output [3:0]  m_int_byteen
    );
	 
	/* choose which device */
	wire [2:0] device_sel;
	assign device_sel = ((processAddr >= `DM_BEGIN) && (processAddr <= `DM_END)) ? `DM_sel :
	                    ((processAddr >= `T0_BEGIN) && (processAddr <= `T0_END)) ? `T0_sel :
							  ((processAddr >= `T1_BEGIN) && (processAddr <= `T1_END)) ? `T1_sel :
							  ((processAddr >= `INT_BEGIN) && (processAddr <= `INT_END)) ? `INT_sel : 3'b000;
	 
	/* choose readdata */
	assign processReadData = (device_sel == `DM_sel) ? m_data_rdata :
									 (device_sel == `T0_sel) ? T0_Dout :
									 (device_sel == `T1_sel) ? T1_Dout : 32'b0;
									 
	/* HWInt */
	assign HWInt = {3'b0,interrupt,T1_IRQ,T0_IRQ};
	
	/* DM */
	assign m_data_addr = processAddr;
	assign m_data_wdata = processWriteData;
	assign m_data_byteen = ((device_sel == `DM_sel)&&(!Req))? processByteen : 4'b0;
	
	/* T0 */
	assign T0_Addr = processAddr[31:2];
	assign T0_we = (device_sel == `T0_sel) && (|processByteen);
	assign T0_Din = processWriteData;
	
	/* T1 */
	assign T1_Addr = processAddr[31:2];
	assign T1_we = (device_sel == `T1_sel) && (|processByteen);
	assign T1_Din = processWriteData;
	
	/* INT */
	assign m_int_addr = processAddr;
	assign m_int_byteen = (device_sel == `INT_sel) ? processByteen : 4'b0;
	
endmodule

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
	 input interrupt, //外部中断信号
	 output [31:0] macroscopic_pc,//宏观PC
	 
	 output [31:0] i_inst_addr, //PC
	 input  [31:0] i_inst_rdata, //32位指令
	 
	 output [31:0] m_data_addr, //输出DM地址
	 input  [31:0] m_data_rdata, //从DM中读到的数据，注意DM是外设
	 output [31:0] m_data_wdata, //要写入DM中的数据
	 output [3:0]  m_data_byteen, //四位字节使能
	 
	 output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号 
	 
	 output [31:0] m_inst_addr, //M级PC
	 
	 output w_grf_we, //GRF写使能信号
	 output [4:0] w_grf_addr, //待写入的寄存器地址
	 output [31:0] w_grf_wdata, //待写入数据
	 
	 output [31:0] w_inst_addr //W级PC
    ); 
	 
	 wire [31:2] T0_Addr;
	 wire T0_we;
	 wire [31:0] T0_Din;
	 wire [31:0] T0_Dout;
	 wire T0_IRQ;
	 
	 TC T0 (
    .clk(clk), 
    .reset(reset), 
    .Addr(T0_Addr), 
    .WE(T0_we), 
    .Din(T0_Din), 
    .Dout(T0_Dout), 
    .IRQ(T0_IRQ)
    );
	 
	 wire [31:2] T1_Addr;
	 wire T1_we;
	 wire [31:0] T1_Din;
	 wire [31:0] T1_Dout;
	 wire T1_IRQ;
	 
	 TC T1 (
    .clk(clk), 
    .reset(reset), 
    .Addr(T1_Addr), 
    .WE(T1_we), 
    .Din(T1_Din), 
    .Dout(T1_Dout), 
    .IRQ(T1_IRQ)
    );
	 
	 
	 wire [31:0] processAddr;
	 wire [31:0] processWriteData;
	 wire [31:0] processReadData;
	 wire [3:0]  processByteen;
	 wire [5:0]  HWInt;
	 wire Req;
	 
	 Bridge bridge (
    .processAddr(processAddr), 
    .processWriteData(processWriteData), 
    .processByteen(processByteen), 
    .processReadData(processReadData), 
    .HWInt(HWInt), 
    .m_data_rdata(m_data_rdata), 
    .m_data_addr(m_data_addr), 
    .m_data_wdata(m_data_wdata), 
    .m_data_byteen(m_data_byteen), 
	 .Req(Req),
    .T0_Dout(T0_Dout), 
    .T0_IRQ(T0_IRQ), 
    .T0_Addr(T0_Addr), 
    .T0_Din(T0_Din), 
    .T0_we(T0_we), 
    .T1_Dout(T1_Dout), 
    .T1_IRQ(T1_IRQ), 
    .T1_Addr(T1_Addr), 
    .T1_Din(T1_Din), 
    .T1_we(T1_we), 
    .interrupt(interrupt), 
    .m_int_addr(m_int_addr), 
    .m_int_byteen(m_int_byteen)
    );
	 
	 
	CPU cpu (
    .clk(clk), 
    .reset(reset), 
    .i_inst_rdata(i_inst_rdata), 
    .i_inst_addr(i_inst_addr), 
    .HWInt(HWInt), 
    .processReadData(processReadData), 
    .processWriteData(processWriteData), 
    .processByteen(processByteen), 
    .processAddr(processAddr), 
    .m_inst_addr(m_inst_addr), 
    .w_grf_we(w_grf_we), 
    .w_grf_addr(w_grf_addr), 
    .w_grf_wdata(w_grf_wdata), 
    .w_inst_addr(w_inst_addr), 
	 .Req_check(Req),
    .macroscopic_pc(macroscopic_pc)
    );
	
endmodule

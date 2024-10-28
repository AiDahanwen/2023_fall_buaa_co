`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:46:04 11/04/2023
// Design Name:   mips
// Module Name:   D:/Xilinxx/project/P4_CPU/mips_tb.v
// Project Name:  P4_CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "print_info.v"

module mips_tb;

	// Inputs
	reg clk;
	reg reset;
	wire [31:0] Instr = uut.Instr;
	reg probeclk;
	wire compare_condition;
	
	print_info print_info_uut (
    .Instr(uut.Instr), 
    .clk(probeclk), 
    .PC(uut.PC), 
    .next_pc(uut.next_pc),
	 .compare_condition(uut.compare_condition),
    .RD1(uut.RD1), 
    .RD2(uut.RD2) 
    );
		

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);

	always begin
		#3 probeclk = ~probeclk;
		#1 clk = ~clk;
	end
      
	integer i;
	
	initial begin
		$display("\nstart:");
		i = 0;
		clk = 0;
		reset = 0;
		probeclk = 0;
		#800;
		$display("\nFinished!\ncheckGRF:");
		for(i = 0; i < 32; i=i+1) begin
			$display("\t$%0d = %h",i[4:0],uut.grf_mips.registers[i]);
		end
		$display ("\ncheckDM:");
		for(i = 0; i < 32; i=i+1) begin
			$display("\t*%d = %h",i[4:0],uut.dm_mips.DM[i]);
		end		
		#10000;
		$finish;
	end
	
endmodule


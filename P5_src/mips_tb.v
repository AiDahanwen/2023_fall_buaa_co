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

module mips_tb;

	// Inputs
	reg clk;
	reg reset;
	reg probeclk;
	wire compare_condition;
	

		

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);
	//reg[7:0] periodCount;
	
	always begin
		//#1 probeclk = ~probeclk;
		//#1;
		//if(probeclk) begin
			//if(reset) begin
				//$display("reseting");
			//end
			//else if(uut.Instr_F != 32'bX) begin
				//periodCount = periodCount + 1;
				//$display("\nPeriod #%d",periodCount);
				//$write("\nC instr: 0x%h,",uut.Instr_F);
				//$display("\tPC: 0x%h, ",uut.PC);
				
				//$write("\nD instr: 0x%h,",uut.Instr_D);
				//`PRINT_INFOR(CtrlD)
				//if(`CtrlD.jump != 0) begin
					//$display("\n%d",`CtrlD.jump);
				//end
			//end
				//$write("\nE");
				//`PRINT_INFOR(`CtrlE)
				
				//$write("\nM");
				//`PRINT_INFOR(`CtrlM)
				
				//$write("\nW");
				//`PRINT_INFOR(`CtrlW)
			//end
		//end
		
		#3 clk = ~clk;
	end
      
	integer i;
	
	initial begin
		$display("\nstart:");
		i = 0;
		clk = 0;
		reset = 0;
		#100;
		//probeclk = 0;
		//periodCount = 0;
		//$display("\nFinished!\ncheckGRF:");
		//for(i = 0; i < 32; i=i+1) begin
			//$display("\t$%0d = %h",i[4:0],uut.grf_mips.registers[i]);
		//end
		//$display ("\ncheckDM:");
		//for(i = 0; i < 32; i=i+1) begin
			//$display("\t*%0d = %h",i[4:0],uut.dm_mips.DM[i]);
		//end		
		
		//$finish;
	end
	
endmodule


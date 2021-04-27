`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:50:50 07/26/2020
// Design Name:   Mips_core
// Module Name:   D:/issseee/misips/mips/tb_mips.v
// Project Name:  mips
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mips_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_mips;

	// Inputs
	reg clock;
	 wire clock_out ; 
    wire [31:0] result_alu ;
	  wire [31:0] Read_data1 ;
	  wire [31:0] Read_data2;
	  wire [31:0] final_write_data ;
	  wire[31:0] pc_next ; 
	  wire [31:0] cur_pc ; 
	  wire [31:0] instruction ; 
	  reg reset ;
	//	reg[31:0] instruction_memory[31:0] ; 
		
	

	// Instantiate the Unit Under Test (UUT)
	Mips_core uut ( clock , clock_out , result_alu , Read_data1 , Read_data2 , final_write_data , pc_next , cur_pc , reset , instruction   );
	
	

	  initial begin  
           clock = 0;  
           forever #10 clock = ~clock;  
      end  
      initial begin  
           // Initialize Inputs  
           //$monitor ("register 3=%d, register 4=%d", reg3,reg4); 
#5			  
           reset = 1;  
           // Wait 30 ns for global reset to finish  
           #30;  
     reset = 0;  
           // Add stimulus here  
      end  
      
endmodule


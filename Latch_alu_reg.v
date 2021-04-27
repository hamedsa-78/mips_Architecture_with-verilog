`timescale 1ns / 1ps

module Latch_alu_reg( input [31:0] result_alu , input zero , input clock , output reg[31:0] funal_alu , output reg z );
  
	always @(posedge clock ) begin
	
		funal_alu <= result_alu ;
		z <= zero ;
	
	end


endmodule

`timescale 1ns / 1ps

module bank_reg(input [4:0] src1 , input [4:0] src2 ,  input [4:0] dst , input [31:0] Data , input reg_write , input clock ,  
                  output [31:0] data1 , output [31:0] data2 , input reset
    );
	 
	 reg [31:0] Bank [31:0] ;
	 
	 
	 assign data1 = Bank[src1] ;
	 assign data2 = Bank[src2] ;
	 

	 
	 always @ (posedge clock or posedge reset) begin
	 if (reset)begin
	 	 Bank[0] <= 32'd0;
		 end

	 else if (reg_write) 
	   Bank[dst] <= Data ;
	 
	 end
	 
	 


endmodule

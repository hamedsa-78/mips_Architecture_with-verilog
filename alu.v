`timescale 1ns / 1ps
module alu(       
      input          [31:0]     a,          //src1  
      input          [31:0]     b,          //src2  
      input          [3:0]     alu_control,     //function sel  
      output     reg     [31:0]     result,          //result       
      output zero 
   ); 

	
		always @ (*) 
		
		begin
		
			case (alu_control)
			
	   4'b0000: result = a & b;   
      4'b0001: result = a | b; 
      4'b0010: result = a + b; 
      4'b0110: result = a - b; 
		
		 4'b0111: result = (a > b ) ?  b : a ; 
		 
		 4'b1100: result =  ~ (a ^ b ) ; 
		 
		 4'b0011: result =  a ;    // JR
		 
		
      
     // default:result = a + b; // add 
			
			endcase
		
		end
		
		assign zero = (result == 0  ) ? 1'b1 : 1'b0 ; 

endmodule

`timescale 1ns / 1ps

module sign_extend(input [15:0] a , input clock ,  output reg [31:0] b
    );
	 
	 always @ (posedge clock ) begin
	 
	  b <=  (a[15]) ? {{16{1'b1}} , a } : {{16{1'b0}} , a };
	
		end

endmodule


/*module sign_extend(input [15:0] a , input clock ,  output  [31:0] b
    );
	 
	  assign b =  (a[15]) ? {{16{1'b1}} , a } : {{16{1'b0}} , a };
	
		

endmodule
*/
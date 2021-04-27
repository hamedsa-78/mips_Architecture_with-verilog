`timescale 1ns / 1ps

module data_memory( input [31:0]  adress , input [31:0]  write_data, input clock , input mem_write ,  input mem_read , 
						output reg [31:0] data , input reset
    );
	 
	 	 reg [31:0] data_memory [127:0] ;

	//	assign data = (mem_read) ? data_memory[adress] : 32'd0;
		
		 always @ (posedge clock or posedge reset ) 
		begin
		if (reset)
		data_memory[13] <= 32'd3 ;
		
		
			else if (mem_write) 
	     data_memory[adress[6:0]] <= write_data ;
		  
		 else if (mem_read  ) 
		  data <= data_memory[adress[6:0]];
	
		end
	 
		

endmodule

`timescale 1ns / 1ps

module Mips_core( input clock , output clock_out , output wire [31:0] result_alu ,  output wire [31:0] Read_data1  ,
 output wire [31:0] Read_data2 ,
	output  wire [31:0] final_write_data , output wire [31:0] pc_next ,   output reg [31:0] current_pc  , input reset , 
		output wire [31:0] instruction
    );
	
	 //ozcha
	// reg [31:0] current_pc = 32'd0 ;
	// wire[31:0] next_pc ; 
	 wire[31:0] pc1 ;
	 wire[31:0] sign_data ; 
	 wire[31:0] pc2;
	 
	 // Intruction
	
   // Parse instruction
	wire [5:0] funct;
	wire [4:0] rs, rt, rd, shamt;
	wire [25:0] address;
	wire [15:0] immediate;
	wire [5:0] opcode;
	 // Parse instruction

	 always @ (posedge clock_out or posedge reset) 
	 begin
	 if (reset)
	 current_pc <= 0 ;
	 
	 else
	 current_pc <= pc_JR ; 
	 end
	 

	 
	 
	 //output wire clock_out ; 
	 
	 clock_divider  clk ( clock , clock_out ) ;
	 
	// reg [31:0] data_memory [0:6] ;
	// wire [31:0] instruction_memory [31:0] ;
	 
	//assign instruction_memory[0] = 32'b000010_00000_00000_0000000000000101 ;   //jump instriction
	 
		//assign instruction_memory[0] = 32'b001000_00000_00001_0000000000001010 ;   
		//assign instruction_memory[1] = 32'b000000_00001_00000_00000_00000_001000 ; // JR
		
	/*assign instruction_memory[0] = 32'b001000_00000_00001_0000000000000011 ;
	assign instruction_memory[1] = 32'b001000_00000_00010_0000000000000011 ;   //  these 3 line describe add instruction
	assign instruction_memory[2] = 32'b000000_00001_00010_00011_00000_011000 ;*/
		
			//assign instruction_memory[3] = 32'b100011_00010_00001_0000000000001010 ; 	
				// these two line describe load and beq instruction .
			//assign instruction_memory[4] = 32'b000100_00001_00010_0000000000010100 ;
			
			
			
		//assign instruction_memory[0] = 32'b000011_00000_00000_0000000000001010 ;   // jump to memory 10 and store 1 (next_pc) 
		// these two line describe the jal instruction	.									// into $31

	//	assign instruction_memory[10] = 32'b000000_11111_00000_00000_00000_001000 ;  // back to memory 1 
	
	reg[31:0] instruction_memory[31:0] ;
	
		initial begin 
		$readmemb("instruction.mem", instruction_memory);
	    end


	  
	 
	 assign instruction = instruction_memory[current_pc[4:0] ]  ;

	 
//controls
    wire RegDst;
	 wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUop;
    wire MemWrite;
    wire ALUsrc;		
    wire RegWrite;
	 wire Jump ; 
	 wire jr ;
	 wire JAL ;
//controls  
           
	  wire [4:0]  reg_wr2 ; 
	  
	  wire[4:0] miany ; 
	  wire[4:0] JAL_specefic ; 
	  assign JAL_specefic = 5'd31 ;
	  
	  
	//	mux2_1         wr_mux (instruction[20:16] , instruction[15:11] , RegDst  , reg_wr2) ;  
	
	assign miany = (RegDst) ?   instruction[15:11] : instruction[20:16]  ; //shesis to mux
	assign reg_wr2 = (JAL)  ?   JAL_specefic :  miany  ;						  //shesis to mux

	wire[31:0] JAL_write_data ; 
		
	mux2_1    p_JAL   ( final_write_data , pc1 , JAL , JAL_write_data ) ;

	

	   adder  		     pc_plus_1( current_pc ,  pc1 ) ;
	  
	  sign_extend    sign ( instruction[15:0] , clock ,  sign_data) ;
	 
	  adder32  		  pc_32 ( pc1 , sign_data , pc2) ; 
	 
	 inst_parser     parse(instruction , opcode ,rs , rt , rd , shamt , funct , immediate , adress ) ;
	 
	 control      control_unit (opcode , RegDst , Branch , MemRead , MemtoReg , ALUop , MemWrite , ALUsrc , RegWrite , Jump , JAL) ;

	 
	 
 bank_reg  Regsisters ( instruction [25:21] , instruction [20:16] , reg_wr2 , JAL_write_data  ,   RegWrite & ~jr , clock , Read_data1 , Read_data2 ,reset ) ;
	 
	 
	 
	 

	wire [31:0] for_src2_alu ;
	
	wire [31:0] Result_alu ;
	wire Zero ;
	

	wire zero ;
	


	mux2_1 SRC2_ALU ( Read_data2 , sign_data , ALUsrc , for_src2_alu) ;
	
	wire [3:0] cont_alu ; 
	
	
	
	alu   Alu (  Read_data1 , for_src2_alu , cont_alu , Result_alu , Zero ) ;
	
	//module Latch_alu_reg( input [31:0] result_alu , input zero , input clock , output reg[31:0] funal_alu , output reg z );

	Latch_alu_reg  lutch (Result_alu , Zero , clock , result_alu ,  zero ) ;

 
	ALU_control contrat  ( ALUop , instruction[5:0] , cont_alu , jr) ;
	 


	 
	 wire [31:0] data_Date_memory ;
	 data_memory   Date_mem ( result_alu , Read_data2 , clock , MemWrite , MemRead , data_Date_memory , reset ) ;

		 
	 wire [31:0] jump_adress ; 
	 wire [31:0] pc_next_j ;
	 wire [31:0] pc_JR ;

	 
	 
	 assign jump_adress =  {pc_next[31:28] , 00 , instruction[25:0] } ;
	// assign jump_adress =  {pc_next[31:28] ,  instruction[25:0]  , 00 } ;
	
	 mux2_1  ff ( result_alu , data_Date_memory , MemtoReg , final_write_data ) ;
	 
	
	 
	 mux2_1  p_counter ( pc1 , pc2 , (zero & Branch ) ,  pc_next ) ;
	 
	 mux2_1  p_jump    ( pc_next , jump_adress , Jump , pc_next_j ) ;
	 
	 mux2_1  p_JR     ( pc_next_j , result_alu , jr , pc_JR ) ;

	 
	 
	 


endmodule

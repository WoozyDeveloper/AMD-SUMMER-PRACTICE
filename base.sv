`ifndef MEM_BASE_OBJ
`define MEM_BASE_OBJ
/*
	Base object that can be filled with input and output data
*/

class mem_base_obj;
    
    //input data
    reg [31:0] Din;
    reg [2:0] mode_in;
    reg [2:0] chip_en;
    reg [1:0] rw;
    reg reset;
    reg clk;

    //output data
    reg [31:0] Dout;
    reg full;
    reg empty;
  
  	//addr
  	reg [7:0] addr;
endclass
`endif
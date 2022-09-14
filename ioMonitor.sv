`include "base.sv"
`include "memInterface.sv"
`include "memScoreboard.sv"

/*
    Class that monitors the input and the output. It creates a base object, fills it with data and sends
  it to the scoreboard. 
*/


`ifndef MEM_IO_MONITOR
`define MEM_IO_MONITOR

class mem_io_monitor;
  mem_base_obj mem_obj;//Base object where we store the data that will be sent to the scoreboard
  mem_scoreboard mem_sb;//The scoreboard
  reg[7:0] cont = 0;
  mem_scoreboard scoreboard;

  virtual mem_interface_input input_ports;//input interface
  virtual mem_interface_output output_ports;//output interface

  //Contructor that stores the received data inside the object
  function new (mem_scoreboard sb, virtual mem_interface_input i_ports, virtual mem_interface_output o_ports);
      begin
        this.mem_sb = sb;           //scoreboard
      	this.input_ports = i_ports; //input interface
        this.output_ports = o_ports;//output interface
      end
    endfunction

    task monitor();
        begin
          /*
              is_buffer -> 0 if the mode isn't buffer
                        -> 1 if the mode is buffer

              Used to identify the mode of our RTL to make sure that we don't create an 
            object twice (or print the input/output data twice)

          */
          integer is_buffer = 0;
          while(1) 
          begin
                    if(input_ports.mode_in == 3'b001 && input_ports.chip_en == 3'b001) //if it is BUFFER
                    begin
                        is_buffer = 1;//set the flag to 1 (the mode is BUFFER)
                        $display("MOD BUFFER");
                        
                        mem_obj = new();//create a new base object and fill it with data

                        //take data from the input interface and put it in our base object
                        mem_obj.Din = input_ports.Din;
                        mem_obj.mode_in = input_ports.mode_in;
                        mem_obj.chip_en = input_ports.chip_en;
                        mem_obj.rw = input_ports.rw;
                        mem_obj.reset = input_ports.reset;

                        
                            
                        $display("input_monitor buff : Data : %d | Chip : %b", input_ports.Din, input_ports.chip_en);
                        $display("Output_monitor buff : Data : %x", output_ports.Dout);
                    end
                    else begin//if it is not BUFFER
                        is_buffer = 0;
                    end
              	
                    @(posedge input_ports.clk);//write the data
                    if(input_ports.rw == 2'b01 && !is_buffer)
                    begin
                        mem_obj = new();//create the object and fill it with input data
                        $display("input_monitor : DataIn : %x | Chip : %b", input_ports.Din, input_ports.chip_en);
                            
                      	//take data from the input interface and put it in our base object
                        mem_obj.Din = input_ports.Din;
                        mem_obj.mode_in = input_ports.mode_in;
                        mem_obj.chip_en = input_ports.chip_en;
                        mem_obj.rw = input_ports.rw;
                        mem_obj.reset = input_ports.reset;
                    
                        //send to scoreboard  
                        mem_sb.post_input(mem_obj);
                    end
                    
              		@(negedge input_ports.clk);//read the data
                    if(input_ports.rw == 2'b10 && !is_buffer)
                    begin
                       	mem_obj = new();//create the object and fill it with input data
                       	$display("Output_monitor : DataOut : %x", output_ports.Dout);

                      	//take data from the input interface and put it in our base object
                        mem_obj.Dout  = output_ports.Dout;
                        mem_obj.full  = output_ports.full;
                        mem_obj.empty = output_ports.empty;
                        
                        //send to scoreboard
                        mem_sb.post_output(mem_obj);
                    end
            end
        end
    endtask
endclass

`endif

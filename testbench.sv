`include "memInterface.sv"
`include "base.sv"
`include "ioMonitor.sv"
`include "memScoreboard.sv"


module tb_mem_cell;

    reg [31:0] Din;
    reg [2:0] mode_in;
    reg [2:0] chip_en;
    reg [1:0] rw;
    reg reset;
    reg clk;
    wire [31:0] Dout;
    wire full;
    wire empty;
  

  mem_interface_input i_ports(clk,Din,mode_in,chip_en,rw,reset);//input interface
  mem_interface_output o_ports(clk,Dout,full,empty);//output interface
  
  
  mem_cell #(.WIDTH(8)) DUT (i_ports.Din, i_ports.mode_in, i_ports.chip_en, i_ports.rw, i_ports.reset, i_ports.clk, o_ports.Dout, o_ports.full, o_ports.empty);//design

  mem_io_monitor io_monitor = new(i_ports,o_ports);//input/output monitor

//   in_monitor = new(i_ports);
//   out_monitor = new(o_ports);

    initial begin

      	$dumpvars(0, tb_mem_cell);
		$dumpfile("my.vcd");
		
      	//clock
        clk = 0;
        forever
            #5 clk = ~clk;
    end
    initial begin
      $display("STARTING TESTBENCH");
      
      
      fork
        //thread1 will run the monitor
        io_monitor.monitor();

        
        //thread2 will change values in the input interface
        begin
          
          //FIFO
          i_ports.reset = 0;
          #15
          i_ports.reset = 1;
          #10
          i_ports.reset = 0;

          #10
          i_ports.Din = 1;
          i_ports.rw = 1;
          i_ports.mode_in = 2;
          i_ports.chip_en = 2;

          #10
          i_ports.Din = 2;

          #10
          i_ports.Din = 3;

          #10
          i_ports.rw = 2;

          #10
          i_ports.rw = 2;
          #10
          i_ports.rw = 2;
          
          
          
          
          
          //LIFO
          i_ports.reset = 0;
          #10
          i_ports.reset = 1;
          #10
          i_ports.reset = 0;
 		  i_ports.rw = 1;
          i_ports.mode_in = 4;
          i_ports.chip_en = 4;
          #10
          i_ports.Din = 1;
         

          #10
          i_ports.Din = 2;

          #10
          i_ports.Din = 3;

          #10
          i_ports.rw = 2;

          #10
          i_ports.rw = 2;
          #10
          i_ports.rw = 2;

          
          
          
          
          
          //BUFFER
          i_ports.reset = 0;
          #10
          i_ports.reset = 1;
          i_ports.rw = 1;
          i_ports.reset = 0;
		  i_ports.mode_in = 1;
          i_ports.chip_en = 1;
			i_ports.Din = 1;
          #10
          
          
          #10
          i_ports.Din = 2;

          #10
          i_ports.Din = 3;
          
          
          
          #10
          //mode != chip_en
          i_ports.rw = 1;
          i_ports.reset = 0;
          #10
          i_ports.reset = 1;
          #10
          i_ports.reset = 0;

          #10
          i_ports.Din = 1;
          
          i_ports.mode_in = 2;
          i_ports.chip_en = 4;

          #10
          i_ports.Din = 2;

          #10
          i_ports.Din = 3;

          #10
          i_ports.rw = 2;

          #10
          i_ports.rw = 2;
          #10
          i_ports.rw = 2;

          #50
          $finish;
        end
      join
    end
endmodule
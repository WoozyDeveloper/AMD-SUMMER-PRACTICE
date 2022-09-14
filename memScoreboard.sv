`include "base.sv"

`ifndef MEM_SB
`define MEM_SB

class mem_scoreboard;
  integer size;
  mailbox m_box;
  
  function new();
    begin
      size = 0;
    end
  endfunction
  
  task post_input(mem_base_obj)
  
  task addItem(bit [7:0] data);
    begin
      if(size == 4'b1111)
        begin
          $write("%dns : ERROR : Over flow detected, current occupancy %d\n", $time, size);
        end
      else begin
        m_box.put(data);
        size++;
      end
    end
  endtask
  
  task compareItem(bit [7:0] data);
    begin
      bit [7:0] d_data;
      if(size == 0)
        begin
          $write("%dns : ERROR : Under flow detected\n", $time);
        end
      else begin
        m_box.get(d_data);
        if(data != d_data)
          begin
            $write("%dns : ERROR : Data mismatch, Expected %x Got %x\n", $time, d_data, data );
          end
        size--;
      end
    end
  endtask
endclass

`endif
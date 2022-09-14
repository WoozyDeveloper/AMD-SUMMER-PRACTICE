`ifndef MEM_PORTS
`define MEM_PORTS

interface mem_interface_input (input wire clk,
                               output logic [31:0] Din,
                               output logic [2:0] mode_in,
                               output logic [2:0] chip_en,
                               output logic [1:0] rw,
    						   output logic reset
                              );
endinterface

interface mem_interface_output (input wire clk,
                               	input logic [31:0] Dout,
                                input logic full,
                                input logic empty
                               );
endinterface

`endif
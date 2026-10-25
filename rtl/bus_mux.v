`timescale  1ns/1ps

module bus_mux #(parameter WIDTH = 8) (
    input  wire [WIDTH-1:0] r0, r1, r2, r3,
    input  wire [1:0]       source_sel,
    output wire [WIDTH-1:0] bus_out
);
    assign bus_out = (source_sel == 2'b00) ? r0 : 
                     (source_sel == 2'b01) ? r1 :
                     (source_sel == 2'b10) ? r2 : r3;
endmodule
`timescale  1ns/1ps

module logic_unit(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [1:0] sel, // {AND,OR,XOR,NOT} {alusel[2], alusel[0]}
    output wire [7:0] result
);

    bus_mux bus(
        .r0(a & b), .r1(a | b), .r2(a ^ b), .r3(~a),
        .source_sel(sel), .bus_out(result)
    );

endmodule
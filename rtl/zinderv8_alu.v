`timescale  1ns/1ps

module zinderv8_alu(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [3:0] alu_sel,
    output wire [7:0] result,
    output wire [3:0] cr // {N,Z,V,C} flags
);

    wire arith_c, shift_c, arith_v;
    wire [7:0] arith_result, logic_result, shift_result;

    arith_unit u_arith(
        .a(a),
        .b(b),
        .sel({alu_sel[3], alu_sel[0]}),
        .carry(arith_c),
        .overflow(arith_v),
        .result(arith_result)
    );

    logic_unit u_logic(
        .a(a),
        .b(b),
        .sel({alu_sel[2], alu_sel[0]}),
        .result(logic_result)
    );

    shift_unit u_shift(
        .a(a),
        .sel(alu_sel[0]),
        .carry(shift_c),
        .result(shift_result)
    );

    bus_mux result_mux(
        .r0(arith_result), .r1(logic_result), .r2(logic_result), .r3((alu_sel[3] == 1'b1) ? 4'b0 : shift_result),
        .source_sel({alu_sel[2], alu_sel[1]}),
        .bus_out(result)
    );

    bus_mux #(.WIDTH(1)) carry_mux(
        .r0(arith_c), .r1(1'b0), .r2(1'b0), .r3((alu_sel[3] == 1'b1) ? 1'b0 : shift_c),
        .source_sel({alu_sel[2], alu_sel[1]}),
        .bus_out(cr[0])
    );
    
    /*{NZV}*/
    assign cr[3:1] = {
        result[7], 
        result == 8'h00 , 
        (alu_sel[2:1] == 2'b00) ? arith_v : 1'b0
    };

endmodule
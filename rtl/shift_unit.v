module shift_unit(
    input wire [7:0] a,
    input wire sel, // 0: shl, 1: shr
    output wire [7:0] result,
    output wire carry
);
    
    assign {carry, result} =  (sel == 1'b0) ? {a, 1'b0} : {a[0], a >> 1};

endmodule
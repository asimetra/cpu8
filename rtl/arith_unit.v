module arith_unit(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [1:0] sel, // {1|b, sub|add}
    output wire [7:0] result,
    output wire carry,
    output wire overflow
);

    wire [7:0] rval;

    assign overflow = sel[0]
    ? ((a[7] != rval[7]) && (result[7] != a[7]))
    : ((a[7] == rval[7]) && (result[7] != a[7]));
    assign rval = (sel[1] == 1'b0) ? b : 8'b1;
    // carry: ADD/INC carry-out, SUB/DEC carry-out of a + ~b + 1 (1 = no borrow)
    assign {carry,result} =  a + (sel[0] == 1'b0 ? rval : {~rval} + 1);

endmodule
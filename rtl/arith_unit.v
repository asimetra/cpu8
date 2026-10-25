`timescale  1ns/1ps

module arith_unit(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [1:0] sel, // {1|b, sub|add}
    output wire [7:0] result,
    output wire carry,
    output wire overflow
);

    wire [7:0] rval;

    bus_mux bmux(
        .r0(b), .r1(~b), .r2(8'b1), .r3(8'hFE),
        .source_sel(sel),
        .bus_out(rval)
    );

    /* CF (bit 0) Carry flag — Set if an arithmetic operation generates a carry or 
    a borrow out of the mostsignificant bit of the result; 
    cleared otherwise. This flag indicates an overflow condition for unsigned-integer arithmetic. 
    It is also used in multiple-precision arithmetic.
    Don't associate the CF with the sign bit, in a subtraction CF is set whenever the minuend, 
    treated as unsigned, is less than the subtrahend */
    assign {carry,result} =  a + rval + sel[0];

    /* Overflow: adding two numbers of the same sign must not change the sign.
       For subtraction the adder adds a + ~b + 1 (the +1 is sel[0], carry-in),
       so the sign checked is rval's, i.e. ~b, not -b:
         b = -128: -b would be 1000 0000 (+128 does not fit), so -1 - (-128) would
                   look like (-) + (-) = (+) and falsely set overflow.
                   ~b = 0111 1111 is positive: (-) + (+) cannot overflow.
         b = 0:    ~b = 1111 1111 has the wrong sign (0 is not negative),
                   but it never causes a false overflow:
                   a positive: (+) + (-) cannot overflow;
                   a negative: (-) + (-) stays negative, since a - 0 = a. */
    assign overflow = (a[7] == rval[7]) && (result[7] != a[7]);

endmodule
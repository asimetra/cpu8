`timescale 1ns/1ps

// zinderv8_alu: sinav icin tek modul, kagida yazilacak hali
module zinderv8_alu(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [3:0] alu_sel,
    output reg  [7:0] result,
    output wire [3:0] cr            // {N, Z, V, C}
);
    wire [7:0] nb = ~b;             // 8 bitte sabitle (asagidaki nota bak)
    reg c, v;

    always @(*) begin
        c = 1'b0;
        v = 1'b0;
        case (alu_sel)
            4'b0000: begin {c, result} = a + b;      v = (a[7] == b[7])  && (result[7] != a[7]); end // ADD
            4'b0001: begin {c, result} = a + nb + 1; v = (a[7] == nb[7]) && (result[7] != a[7]); end // SUB
            4'b1000: begin {c, result} = a + 1;      v = ~a[7] &  result[7]; end                     // INC
            4'b1001: begin {c, result} = a + 8'hFF;  v =  a[7] & ~result[7]; end                     // DEC
            4'b0010: result = a & b;                                                                 // AND
            4'b0011: result = a | b;                                                                 // OR
            4'b0100: result = a ^ b;                                                                 // XOR
            4'b0101: result = ~a;                                                                    // NOT
            4'b0110: {c, result} = {a, 1'b0};                                                        // SHL
            4'b0111: {c, result} = {a[0], a >> 1};                                                   // SHR
            default: result = 8'h00;
        endcase
    end

    assign cr = {result[7], result == 8'h00, v, c};
endmodule

`timescale  1ns/1ps

module register8 (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire[7:0] D, // [msb:lsb]
    output reg[7:0] Q
);

    always @(posedge clk) begin
        if (reset) begin
            Q <= 8'b0; // range'base value
        end else if (enable)  begin
            Q <= D;
        end
    end

endmodule
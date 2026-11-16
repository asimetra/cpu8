`timescale  1ns/1ps

module register8 #(parameter WIDTH = 8) (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire[WIDTH-1:0] D, // [msb:lsb]
    output reg[WIDTH-1:0] Q
);

    always @(posedge clk) begin
        if (reset) begin
            Q <= 0;
        end else if (enable)  begin
            Q <= D;
        end
    end

endmodule

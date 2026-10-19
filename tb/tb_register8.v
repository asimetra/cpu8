`timescale  1ns/1ps

module tb_register8;

    reg clk, reset, enable;
    reg[7:0] D;
    wire[7:0] Q;

    register8 dut(
        .clk(clk),
        .D(D),
        .enable(enable),
        .reset(reset),
        .Q(Q)
    );

    always #5 clk = ~clk;

    integer error = 0;

    initial begin
        $dumpfile("tb_register8.vcd"); // value change dump
        $dumpvars(0, tb_register8); // if depth is zero every module var dump

        clk = 0;
        reset = 1;
        enable = 0;
        D = 8'h00;

        // reset=1: Q is cleared
        @(negedge clk);
        if (Q !== 8'h00) begin
            $display("FAIL: after reset Q=%h, expected 00", Q);
            error = error + 1;
        end

        // reset=0, enable=1: Q takes D
        reset = 0;
        enable = 1;
        D = 8'h03;
        @(negedge clk);
        if (Q !== 8'h03) begin
            $display("FAIL: after enable Q=%h, expected 03", Q);
            error = error + 1;
        end

        // enable=0: Q holds even though D changes
        enable = 0;
        D = 8'hA5;
        @(negedge clk);
        if (Q !== 8'h03) begin
            $display("FAIL: after hold Q=%h, expected 03", Q);
            error = error + 1;
        end

        // reset=1 wins over enable=1
        reset = 1;
        enable = 1;
        @(negedge clk);
        if (Q !== 8'h00) begin
            $display("FAIL: after reset with enable Q=%h, expected 00", Q);
            error = error + 1;
        end

        if (error == 0) $display("PASS");
        else $display("FAIL: %0d errors", error);

        $finish;
    end

endmodule

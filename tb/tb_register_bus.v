`timescale  1ns/1ps

module tb_register_bus;

    reg clk, reset, load;
    reg[1:0] source_sel, dest_sel;
    reg[7:0] data_in;

    register_bus dut(
        .clk(clk),
        .reset(reset),
        .load(load),
        .source_sel(source_sel),
        .dest_sel(dest_sel),
        .data_in(data_in)
    );

    always #5 clk = ~clk;

    integer error = 0;

    initial begin
        $dumpfile("tb_register_bus.vcd");
        $dumpvars(0, tb_register_bus);

        clk = 0;
        reset = 1;
        load = 0;
        source_sel = 2'b00;
        dest_sel = 2'b00;
        data_in = 8'h00;

        // reset: every register is cleared
        @(negedge clk);
        if (dut.q0 !== 8'h00 || dut.q1 !== 8'h00 || dut.q2 !== 8'h00 || dut.q3 !== 8'h00) begin
            $display("FAIL: after reset q0=%h q1=%h q2=%h q3=%h, expected all 00",
                     dut.q0, dut.q1, dut.q2, dut.q3);
            error = error + 1;
        end

        // load=1: R2 <- 55
        reset = 0;
        load = 1;
        dest_sel = 2'b10;
        data_in = 8'h55;
        @(negedge clk);
        if (dut.q2 !== 8'h55) begin
            $display("FAIL: after R2 <- 55 q2=%h, expected 55", dut.q2);
            error = error + 1;
        end

        // load=1: R1 <- 22
        dest_sel = 2'b01;
        data_in = 8'h22;
        @(negedge clk);
        if (dut.q1 !== 8'h22) begin
            $display("FAIL: after R1 <- 22 q1=%h, expected 22", dut.q1);
            error = error + 1;
        end

        // load=0: R0 <- R2 (the example from the sheet)
        load = 0;
        source_sel = 2'b10;
        dest_sel = 2'b00;
        @(negedge clk);
        if (dut.q0 !== 8'h55) begin
            $display("FAIL: after R0 <- R2 q0=%h, expected 55", dut.q0);
            error = error + 1;
        end

        // load=0: R3 <- R1, and the others keep their values
        source_sel = 2'b01;
        dest_sel = 2'b11;
        @(negedge clk);
        if (dut.q3 !== 8'h22) begin
            $display("FAIL: after R3 <- R1 q3=%h, expected 22", dut.q3);
            error = error + 1;
        end
        if (dut.q0 !== 8'h55 || dut.q1 !== 8'h22 || dut.q2 !== 8'h55) begin
            $display("FAIL: R0..R2 changed: q0=%h q1=%h q2=%h, expected 55 22 55",
                     dut.q0, dut.q1, dut.q2);
            error = error + 1;
        end

        if (error == 0) $display("PASS");
        else $display("FAIL: %0d errors", error);

        $finish;
    end

endmodule

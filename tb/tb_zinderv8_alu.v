`timescale  1ns/1ps

module tb_zinderv8_alu;

    reg [7:0]   a, b;
    reg [3:0]   alu_sel;

    wire [7:0]  result;
    wire [3:0]  cr;

    integer error = 0;

    zinderv8_alu dut(
        .a(a),
        .b(b),
        .alu_sel(alu_sel),
        .result(result),
        .cr(cr)
    );

    initial begin
        $dumpfile("tb_zinderv8_alu.vcd");
        $dumpvars(0, tb_zinderv8_alu);

        a = 8'h7F;
        b = 8'h01;
        alu_sel = 4'b0000; /*ADD*/
        #5;
        if (result == 8'h80 && cr == 4'b1010) begin
            $display("PASS: ADD with overflow");
        end else begin
            $display("FAIL: ADD with overflow, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h80;
        b = 8'h01;
        alu_sel = 4'b0001; /*SUB*/
        #5;
        if (result == 8'h7F && cr == 4'b0011) begin
            $display("PASS: SUB with overflow");
        end else begin
            $display("FAIL: SUB with overflow, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'hF0;
        b = 8'h0F;
        alu_sel = 4'b0010; /*AND*/
        #5;
        if (result == 8'h00 && cr == 4'b0100) begin
            $display("PASS: AND with zero");
        end else begin
            $display("FAIL: AND with zero, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h05;
        b = 8'h03;
        alu_sel = 4'b0000; /*ADD*/
        #5;
        if (result == 8'h08 && cr == 4'b0000) begin
            $display("PASS: ADD normal");
        end else begin
            $display("FAIL: ADD normal, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h05;
        b = 8'h03;
        alu_sel = 4'b0001; /*SUB*/
        #5;
        if (result == 8'h02 && cr == 4'b0001) begin
            $display("PASS: SUB normal, no borrow");
        end else begin
            $display("FAIL: SUB normal, no borrow, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'hF0;
        b = 8'h0F;
        alu_sel = 4'b0011; /*OR*/
        #5;
        if (result == 8'hFF && cr == 4'b1000) begin
            $display("PASS: OR with negative");
        end else begin
            $display("FAIL: OR with negative, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h0F;
        b = 8'h05;
        alu_sel = 4'b0100; /*XOR*/
        #5;
        if (result == 8'h0A && cr == 4'b0000) begin
            $display("PASS: XOR normal");
        end else begin
            $display("FAIL: XOR normal, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h0F;
        b = 8'h00;
        alu_sel = 4'b0101; /*NOT*/
        #5;
        if (result == 8'hF0 && cr == 4'b1000) begin
            $display("PASS: NOT with negative");
        end else begin
            $display("FAIL: NOT with negative, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h81;
        b = 8'h00;
        alu_sel = 4'b0110; /*SHL*/
        #5;
        if (result == 8'h02 && cr == 4'b0001) begin
            $display("PASS: SHL with shift carry");
        end else begin
            $display("FAIL: SHL with shift carry, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h81;
        b = 8'h00;
        alu_sel = 4'b0111; /*SHR*/
        #5;
        if (result == 8'h40 && cr == 4'b0001) begin
            $display("PASS: SHR with shift carry");
        end else begin
            $display("FAIL: SHR with shift carry, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'hFF;
        b = 8'h00;
        alu_sel = 4'b1000; /*INC*/
        #5;
        if (result == 8'h00 && cr == 4'b0101) begin
            $display("PASS: INC with zero, carry");
        end else begin
            $display("FAIL: INC with zero, carry, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h00;
        b = 8'h00;
        alu_sel = 4'b1001; /*DEC*/
        #5;
        if (result == 8'hFF && cr == 4'b1000) begin
            $display("PASS: DEC with negative");
        end else begin
            $display("FAIL: DEC with negative, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

        a = 8'h12;
        b = 8'h34;
        alu_sel = 4'b1111; /*ALU_NONE*/
        #5;
        if (result == 8'h00 && cr == 4'b0100) begin
            $display("PASS: ALU_NONE");
        end else begin
            $display("FAIL: ALU_NONE, result=%h, cr=%b", result, cr);
            error = error + 1;
        end

    end

endmodule;
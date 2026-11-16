`timescale  1ns/1ps

module tb_zinderv8_datapath;

    reg        clk, reset;
    reg [2:0]  bus_sel;
    reg        pc_load, pc_inc, ar_load, ir_load, dr_load, ac_load, ac_alu_load, cr_load;
    reg [3:0]  alu_sel;
    reg [7:0]  from_memory;

    wire [7:0] address;
    wire [7:0] to_memory;

    integer error = 0;

    zinderv8_datapath dut(
        .clk(clk),
        .reset(reset),
        .bus_sel(bus_sel),
        .pc_load(pc_load),
        .pc_inc(pc_inc),
        .ar_load(ar_load),
        .ir_load(ir_load),
        .dr_load(dr_load),
        .ac_load(ac_load),
        .ac_alu_load(ac_alu_load),
        .cr_load(cr_load),
        .alu_sel(alu_sel),
        .from_memory(from_memory),
        .address(address),
        .to_memory(to_memory)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_zinderv8_datapath.vcd");
        $dumpvars(0, tb_zinderv8_datapath);

        clk = 0;
        reset = 1;
        bus_sel = 3'b000;
        pc_load = 0;
        pc_inc = 0;
        ar_load = 0;
        ir_load = 0;
        dr_load = 0;
        ac_load = 0;
        ac_alu_load = 0;
        cr_load = 0;
        alu_sel = 4'b0000;
        from_memory = 8'h00;

        @(negedge clk);
        reset = 0;
        if (dut.pc === 8'h00 && dut.ar === 8'h00 && dut.ir === 8'h00 &&
            dut.dr === 8'h00 && dut.ac === 8'h00 && dut.cr === 4'b0000) begin
            $display("PASS: Reset");
        end else begin
            $display("FAIL: Reset, pc=%h ar=%h ir=%h dr=%h ac=%h cr=%b",
                     dut.pc, dut.ar, dut.ir, dut.dr, dut.ac, dut.cr);
            error = error + 1;
        end

        from_memory = 8'h10;
        bus_sel = 3'b100;
        pc_load = 1;
        @(negedge clk);
        pc_load = 0;
        if (dut.pc === 8'h10) begin
            $display("PASS: Memory -> PC");
        end else begin
            $display("FAIL: Memory -> PC, pc=%h", dut.pc);
            error = error + 1;
        end

        bus_sel = 3'b000;
        ar_load = 1;
        @(negedge clk);
        ar_load = 0;
        if (dut.ar === 8'h10) begin
            $display("PASS: PC -> AR");
        end else begin
            $display("FAIL: PC -> AR, ar=%h", dut.ar);
            error = error + 1;
        end

        from_memory = 8'h05;
        bus_sel = 3'b100;
        dr_load = 1;
        @(negedge clk);
        dr_load = 0;
        if (dut.dr === 8'h05) begin
            $display("PASS: Memory -> DR");
        end else begin
            $display("FAIL: Memory -> DR, dr=%h", dut.dr);
            error = error + 1;
        end

        bus_sel = 3'b010;
        ac_load = 1;
        @(negedge clk);
        ac_load = 0;
        if (dut.ac === 8'h05) begin
            $display("PASS: DR -> AC");
        end else begin
            $display("FAIL: DR -> AC, ac=%h", dut.ac);
            error = error + 1;
        end

        alu_sel = 4'b0000;
        ac_alu_load = 1;
        cr_load = 1;
        @(negedge clk);
        ac_alu_load = 0;
        cr_load = 0;
        if (dut.ac === 8'h0A && dut.cr === 4'b0000) begin
            $display("PASS: AC + DR -> AC");
        end else begin
            $display("FAIL: AC + DR -> AC, ac=%h cr=%b", dut.ac, dut.cr);
            error = error + 1;
        end

        alu_sel = 4'b0010;
        ac_alu_load = 1;
        cr_load = 1;
        @(negedge clk);
        ac_alu_load = 0;
        cr_load = 0;
        if (dut.ac === 8'h00 && dut.cr === 4'b0100) begin
            $display("PASS: AC AND DR -> AC, Z flag");
        end else begin
            $display("FAIL: AC AND DR -> AC, Z flag, ac=%h cr=%b", dut.ac, dut.cr);
            error = error + 1;
        end

        alu_sel = 4'b0001;
        ac_alu_load = 1;
        cr_load = 1;
        @(negedge clk);
        ac_alu_load = 0;
        cr_load = 0;
        if (dut.ac === 8'hFB && dut.cr === 4'b1000) begin
            $display("PASS: AC - DR -> AC");
        end else begin
            $display("FAIL: AC - DR -> AC, ac=%h cr=%b", dut.ac, dut.cr);
            error = error + 1;
        end

        alu_sel = 4'b0101;
        ac_alu_load = 1;
        cr_load = 1;
        @(negedge clk);
        ac_alu_load = 0;
        cr_load = 0;
        if (dut.ac === 8'h04 && dut.cr === 4'b0000) begin
            $display("PASS: NOT AC -> AC");
        end else begin
            $display("FAIL: NOT AC -> AC, ac=%h cr=%b", dut.ac, dut.cr);
            error = error + 1;
        end

        pc_inc = 1;
        @(negedge clk);
        pc_inc = 0;
        if (dut.pc === 8'h11) begin
            $display("PASS: PC + 1 -> PC");
        end else begin
            $display("FAIL: PC + 1 -> PC, pc=%h", dut.pc);
            error = error + 1;
        end

        from_memory = 8'hA7;
        bus_sel = 3'b100;
        ir_load = 1;
        @(negedge clk);
        ir_load = 0;
        if (dut.ir === 8'hA7) begin
            $display("PASS: Memory -> IR");
        end else begin
            $display("FAIL: Memory -> IR, ir=%h", dut.ir);
            error = error + 1;
        end

        if (address === dut.ar && to_memory === dut.ac) begin
            $display("PASS: Memory interface");
        end else begin
            $display("FAIL: Memory interface, address=%h (ar=%h), to_memory=%h (ac=%h)",
                     address, dut.ar, to_memory, dut.ac);
            error = error + 1;
        end

        if (error == 0) $display("PASS");
        else $display("FAIL: %0d errors", error);

        $finish;
    end

endmodule

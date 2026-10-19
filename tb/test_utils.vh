// Shared testbench helpers. Use inside a testbench module:
//
//   `include "test_utils.vh"
//   module tb_register8;
//     `TB_INIT(tb_register8)         // error counter + build/tb_register8.vcd
//     ...
//     `CHECK(q, 8'hA5, "load")       // compares with !==, so x/z count as wrong
//     ...
//     `TB_DONE                       // PASS line, or $fatal so make sees FAIL
//   endmodule

`ifndef TEST_UTILS_VH
`define TEST_UTILS_VH

`define TB_INIT(name) \
    integer tb_errors = 0; \
    initial begin \
        $dumpfile(`"name.vcd`"); \
        $dumpvars(0, name); \
    end

// Icarus substitutes macro arguments inside string literals too, so the
// parameter names must not appear in the message text.
`define CHECK(_act, _exp, _msg) \
    begin \
        if ((_act) !== (_exp)) begin \
            $display("FAIL @%0t %s: got %h, expected %h", $time, _msg, _act, _exp); \
            tb_errors = tb_errors + 1; \
        end \
    end

`define TB_DONE \
    begin \
        if (tb_errors == 0) $display("ALL CHECKS PASSED"); \
        else $fatal(1, "%0d check(s) failed", tb_errors); \
        $finish; \
    end

`endif

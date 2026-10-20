`timescale  1ns/1ps

module register_bus (
    input wire[1:0] source_sel, dest_sel,
    input wire[7:0] data_in,
    input wire load,
    input wire reset,
    input wire clk
);
    wire[3:0] en;
    wire[7:0] q0, q1, q2, q3;
    wire[7:0] d, source_out;
    
    assign d = load ? data_in : source_out;
    assign en = 1 << dest_sel;

    register8 r0(.clk(clk), .reset(reset), .enable(en[0]), .D(d), .Q(q0));
    register8 r1(.clk(clk), .reset(reset), .enable(en[1]), .D(d), .Q(q1));
    register8 r2(.clk(clk), .reset(reset), .enable(en[2]), .D(d), .Q(q2));
    register8 r3(.clk(clk), .reset(reset), .enable(en[3]), .D(d), .Q(q3));

    bus_mux  s_mux(
        .r0(q0), .r1(q1), .r2(q2), .r3(q3),
        .source_sel(source_sel),
        .bus_out(source_out)
    );

endmodule
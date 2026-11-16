`timescale  1ns/1ps

module  zinderv8_datapath(
    input wire clk,
    input wire reset,
    
    input  wire [2:0] bus_sel,
    input  wire       pc_load,
    input  wire       pc_inc,
    input  wire       ar_load,
    input  wire       ir_load,
    input  wire       dr_load,
    input  wire       ac_load,
    input  wire       ac_alu_load,
    input  wire       cr_load,
    input  wire [3:0] alu_sel,

    input wire  [7:0] from_memory,
    output wire [7:0] address,
    output wire[7:0] to_memory
);

    wire [7:0] pc, ar, ir, dr, ac;
    wire [3:0] cr;

    reg  [7:0] bus;
    wire [7:0] alu_result;
    wire [3:0] alu_cr;

    assign address = ar;
    assign to_memory = ac;

    register8 u_pc(
        .clk(clk),
        .reset(reset),
        .enable(pc_load | pc_inc),
        .D(pc_inc ? pc + 8'd1 : bus),
        .Q(pc)
    );

    register8 u_ar(
        .clk(clk),
        .reset(reset),
        .enable(ar_load),
        .D(bus),
        .Q(ar)
    );

    register8 u_ir(
        .clk(clk),
        .reset(reset),
        .enable(ir_load),
        .D(bus),
        .Q(ir)
    );

    register8 u_dr(
        .clk(clk),
        .reset(reset),
        .enable(dr_load),
        .D(bus),
        .Q(dr)
    );

    register8 u_ac(
        .clk(clk),
        .reset(reset),
        .enable(ac_load | ac_alu_load),
        .D(ac_alu_load ? alu_result : bus),
        .Q(ac)
    );

    register8 #(.WIDTH(4)) u_cr(
        .clk(clk),
        .reset(reset),
        .enable(cr_load),
        .D(alu_cr),
        .Q(cr)
    );

    always @(*) begin
        case (bus_sel)
            3'b000:  bus = pc;
            3'b001:  bus = ar;
            3'b010:  bus = dr;
            3'b011:  bus = ac;
            3'b100:  bus = from_memory;
            default: bus = 8'h00;
        endcase
    end

    zinderv8_alu u_alu(
        .a(ac),
        .b(dr),
        .alu_sel(alu_sel),
        .result(alu_result),
        .cr(alu_cr)
    );

endmodule;
`timescale 1ns / 1ps

module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );
    
wire [9:0] PC_out;
wire [9:0] mux1_out;
wire [9:0] PC_in;
assign pc_plus4 = PC_out+4;
// write your code here
instruction_mem imem (
    .read_addr(PC_out),
    .data(instr)
);

mux2 #(.mux_width(10)) m1 (
    .a(PC_out+10'd4),
    .b(branch_address),
    .sel(branch_taken),
    .y(mux1_out)
);

mux2 #(.mux_width(10)) m2 (
    .a(mux1_out),
    .b(jump_address),
    .sel(jump),
    .y(PC_in)
);

pipe_reg_en #(.WIDTH(10)) PC (
    .clk(clk),
    .reset(reset),
    .en(en),
    .flush(1'b0),
    .d(PC_in),
    .q(PC_out)
);

endmodule

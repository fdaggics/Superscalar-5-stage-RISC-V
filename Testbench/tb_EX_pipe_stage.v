`timescale 1ns / 1ps

module tb_EX_pipe_stage;

// Testbench uses the same signal widths as the EX_pipe_stage
reg [31:0] id_ex_instr;
reg [31:0] reg1, reg2;
reg [31:0] id_ex_imm_value;
reg [31:0] ex_mem_alu_result;
reg [31:0] mem_wb_write_back_result;
reg id_ex_alu_src;
reg [1:0] id_ex_alu_op;
reg [1:0] Forward_A, Forward_B;
wire [31:0] alu_in2_out, alu_result;

// Instantiate the EX_pipe_stage
EX_pipe_stage uut (
    .id_ex_instr(id_ex_instr),
    .reg1(reg1),
    .reg2(reg2),
    .id_ex_imm_value(id_ex_imm_value),
    .ex_mem_alu_result(ex_mem_alu_result),
    .mem_wb_write_back_result(mem_wb_write_back_result),
    .id_ex_alu_src(id_ex_alu_src),
    .id_ex_alu_op(id_ex_alu_op),
    .Forward_A(Forward_A),
    .Forward_B(Forward_B),
    .alu_in2_out(alu_in2_out),
    .alu_result(alu_result)
);

// Clock is not necessary for this module as there are no sequential elements

// Test sequence
initial begin
    $dumpfile("Bin/tb_EX_pipe_stage.vcd"); // Specify the VCD file name
    $dumpvars(0, tb_EX_pipe_stage); // Dump variables from the testbench

    // Initialize Inputs
    id_ex_instr = 32'b0;
    reg1 = 32'b0;
    reg2 = 32'b0;
    id_ex_imm_value = 32'b0;
    ex_mem_alu_result = 32'b0;
    mem_wb_write_back_result = 32'b0;
    id_ex_alu_src = 1'b0;
    id_ex_alu_op = 2'b0;
    Forward_A = 2'b0;
    Forward_B = 2'b0;

    // Apply different test vectors
    // Set up instruction and control signals to test ALU operation
    // Test forward logic by changing Forward_A and Forward_B
    // Provide values for ex_mem_alu_result and mem_wb_write_back_result to test forwarding

    // Test case 1: Simple ALU operation without forwarding
    #10;
    id_ex_instr = 32'b00100000000000010000000000000110; // Replace with actual instruction bits
    reg1 = 32'd2;
    reg2 = 32'd42;
    id_ex_imm_value = 32'd6;
    id_ex_alu_src = 1'b1; // Select reg2 as ALU input
    id_ex_alu_op = 2'b00; // Set ALU operation, e.g., add
    Forward_A = 2'b00;
    Forward_B = 2'b00;

    // End simulation
    #100;
    $finish;
end

// Optionally, monitor changes
initial begin
    $monitor("Time=%t, ALU input 2=%d, ALU result=%d",
             $time, alu_in2_out, alu_result);
end

endmodule

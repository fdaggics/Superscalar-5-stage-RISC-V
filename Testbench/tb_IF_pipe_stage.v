`timescale 1ns / 1ps

module tb_IF_pipe_stage;

// Testbench uses the same signal widths as the IF_pipe_stage
reg clk, reset, en, branch_taken, jump;
reg [9:0] branch_address, jump_address;
wire [9:0] pc_plus4;
wire [31:0] instr;

// Instantiate the IF_pipe_stage
IF_pipe_stage uut (
    .clk(clk),
    .reset(reset),
    .en(en),
    .branch_address(branch_address),
    .jump_address(jump_address),
    .branch_taken(branch_taken),
    .jump(jump),
    .pc_plus4(pc_plus4),
    .instr(instr)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    $dumpfile("Bin/tb_IF_pipe_stage.vcd"); // Specify the VCD file name
    $dumpvars(0, tb_IF_pipe_stage); // Dump variables from the testbench
    // Initialize Inputs
    clk = 0;
    reset = 1;
    en = 0;
    branch_taken = 0;
    jump = 0;
    branch_address = 0;
    jump_address = 0;

    // Wait for global reset to finish
    #10;
    reset = 0;
    en = 1;
    #50;
    jump_address = 10'd4;
    // jump = 1;
    #10;
    jump = 0;


    // End simulation
    #100;
    $finish;
end

// Optionally, monitor changes
initial begin
    $monitor("Time=%t, PC_plus4=%d, Instr=%h, Branch=%b, Jump=%b, BranchAddr=%d, JumpAddr=%d", 
             $time, pc_plus4, instr, branch_taken, jump, branch_address, jump_address);
end

endmodule

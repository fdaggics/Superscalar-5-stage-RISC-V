`timescale 1ns / 1ps

module tb_ID_pipe_stage;

// Testbench uses the same signal widths as the ID_pipe_stage
reg clk, reset;
reg [9:0] pc_plus4;
reg [31:0] instr;
reg mem_wb_reg_write;
reg [4:0] mem_wb_write_reg_addr;
reg [31:0] mem_wb_write_back_data;
reg Data_Hazard;
reg Control_Hazard;
wire [31:0] reg1, reg2;
wire [31:0] imm_value;
wire [9:0] branch_address, jump_address;
wire branch_taken;
wire [4:0] destination_reg;
wire mem_to_reg, mem_read, mem_write, alu_src, reg_write, jump;
wire [1:0] alu_op;

// Instantiate the ID_pipe_stage
ID_pipe_stage uut (
    .clk(clk),
    .reset(reset),
    .pc_plus4(pc_plus4),
    .instr(instr),
    .mem_wb_reg_write(mem_wb_reg_write),
    .mem_wb_write_reg_addr(mem_wb_write_reg_addr),
    .mem_wb_write_back_data(mem_wb_write_back_data),
    .Data_Hazard(Data_Hazard),
    .Control_Hazard(Control_Hazard),
    .reg1(reg1),
    .reg2(reg2),
    .imm_value(imm_value),
    .branch_address(branch_address),
    .jump_address(jump_address),
    .branch_taken(branch_taken),
    .destination_reg(destination_reg),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .jump(jump)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    $dumpfile("Bin/tb_ID_pipe_stage.vcd"); // Specify the VCD file name
    $dumpvars(0, tb_ID_pipe_stage); // Dump variables from the testbench
    // Initialize Inputs
    clk = 0;
    reset = 1;
    pc_plus4 = 0;
    instr = 0;
    mem_wb_reg_write = 0;
    mem_wb_write_reg_addr = 0;
    mem_wb_write_back_data = 0;
    Data_Hazard = 0;
    Control_Hazard = 0;

    // Wait for global reset to finish
    #10;
    reset = 0;

    // Apply some instructions and hazards
    #50;
    instr = 32'hXXXXXXXX; // Replace XXXXXXXX with actual instruction code
    // Set up other control signals as necessary for your tests
    #10;

    // Apply more test cases as needed
    // ...

    // End simulation
    #100;
    $finish;
end

// Optionally, monitor changes
initial begin
    $monitor("Time=%t, pc_plus4=%d, instr=%h, reg1=%d, reg2=%d, imm_value=%d, branch_address=%d, jump_address=%d, branch_taken=%b, destination_reg=%d, mem_to_reg=%b, alu_op=%b, mem_read=%b, mem_write=%b, alu_src=%b, reg_write=%b, jump=%b", 
             $time, pc_plus4, instr, reg1, reg2, imm_value, branch_address, jump_address, branch_taken, destination_reg, mem_to_reg, alu_op, mem_read, mem_write, alu_src, reg_write, jump);
end

endmodule

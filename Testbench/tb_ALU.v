`timescale 1ns / 1ps

module tb_ALU;

reg [31:0] a, b;
reg [3:0] alu_control;
wire zero;
wire [31:0] alu_result;

// Instantiate the ALU module
ALU uut (
    .a(a),  
    .b(b), 
    .alu_control(alu_control),
    .zero(zero), 
    .alu_result(alu_result)
);

initial begin
    $dumpfile("Bin/tb_ALU.vcd"); // Specify the VCD file name
    $dumpvars(0, tb_ALU); // Dump variables from the testbench
    // Existing test vectors and $finish command

    // Initialize inputs
    a = 0; b = 0; alu_control = 0;
    
    // Apply test vectors
    // Test ADD operation
    #10 a = 32'd10; b = 32'd20; alu_control = 4'b0010; // Expected result: 30
    #10 if (alu_result == 32'd30) $display("Success: ADD operation");
    else $display("Failure: ADD operation, Expected: 30, Got: %d", alu_result);

    #10 a = 32'd15; b = 32'd25; alu_control = 4'b0110; // Test SUB operation, expected result: -10
    #10 if (alu_result == 32'd4294967286) $display("Success: SUB operation"); // 4294967286 is the unsigned equivalent of -10
    else $display("Failure: SUB operation, Expected: -10, Got: %d", alu_result);

    #10 a = 32'd5; b = 32'd3; alu_control = 4'b0101;   // Test MULT operation, expected result: 15
    #10 if (alu_result == 32'd15) $display("Success: MULT operation");
    else $display("Failure: MULT operation, Expected: 15, Got: %d", alu_result);

    #10 a = 32'd100; b = 32'd25; alu_control = 4'b1011; // Test DIV operation, expected result: 4
    #10 if (alu_result == 32'd4) $display("Success: DIV operation");
    else $display("Failure: DIV operation, Expected: 4, Got: %d", alu_result);

    #10 $finish; // Terminate simulation
end

initial begin
    $monitor("Time=%g, Control=%b, A=%d, B=%d, Result=%d, Zero=%b", $time, alu_control, a, b, alu_result, zero);
end

endmodule

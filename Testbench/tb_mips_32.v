`timescale 1ns / 1ps

module tb_mips_32;

reg clk;
reg reset;
wire [31:0] result;

// Instantiate the MIPS module
mips_32 uut (
    .clk(clk), 
    .reset(reset),  
    .result(result)
);

// Clock generation
always #10 clk = ~clk; // 50MHz clock

// Test sequence
initial begin
    $dumpfile("Bin/tb_mips_32.vcd"); // Specify the VCD file name
    $dumpvars(0, tb_mips_32);
    clk = 0;
    reset = 1;
    
    // Reset the processor
    #20 reset = 0;

    // Add test cases here
    // ...

    #500; // Run simulation for some time
    $finish;
end

// Optionally, monitor changes
initial begin
    $monitor("Time=%t, Result=%d", $time, result);
end

endmodule

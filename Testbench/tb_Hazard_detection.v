`timescale 1ns / 1ps

module tb_Hazard_detection;

// Declare inputs as regs and outputs as wires
reg id_ex_mem_read;
reg [4:0] id_ex_destination_reg;
reg [4:0] if_id_rs, if_id_rt;
reg branch_taken, jump;
wire Data_Hazard, IF_Flush;

// Instantiate the Unit Under Test (UUT)
Hazard_detection uut (
    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_destination_reg(id_ex_destination_reg),
    .if_id_rs(if_id_rs),
    .if_id_rt(if_id_rt),
    .branch_taken(branch_taken),
    .jump(jump),
    .Data_Hazard(Data_Hazard),
    .IF_Flush(IF_Flush)
);

reg expected_Data_Hazard = 1'b0; // Assuming a hazard is detected
reg expected_IF_Flush = 1'b0; // No branch or jump, so no flush expected

initial begin
    $dumpfile("Bin/tb_Hazard.vcd"); // Specify the VCD file name
    $dumpvars(0, tb_Hazard_detection);
    // Initialize Inputs
    id_ex_mem_read = 0;
    id_ex_destination_reg = 0;
    if_id_rs = 0;
    if_id_rt = 0;
    branch_taken = 0;
    jump = 0;
    
    // Wait for global reset
    #10;
    
    // Add stimulus here
    // Example test case
    id_ex_mem_read = 1;
    id_ex_destination_reg = 5;
    if_id_rs = 5;
    if_id_rt = 3; // No hazard with rt in this case
    branch_taken = 0;
    jump = 0;
    
    // Expected values (assuming expected logic is corrected)
    // Note: Adjust these based on your understanding of expected behavior

    
    #10; // Wait for the logic to process
    if_id_rs = 3;
    if_id_rt = 5;
    #10;
    if_id_rs = 2;
    if_id_rt = 4;
    jump = 1;
    #10;
    // Check results
    if (Data_Hazard === expected_Data_Hazard && IF_Flush === expected_IF_Flush) begin
        $display("Success: Expected and actual results match.");
    end else begin
        $display("Mismatch: Data_Hazard expected %b, got %b; IF_Flush expected %b, got %b", 
                 expected_Data_Hazard, Data_Hazard, expected_IF_Flush, IF_Flush);
    end
end

endmodule

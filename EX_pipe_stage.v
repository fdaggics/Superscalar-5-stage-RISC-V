`timescale 1ns / 1ps

module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    
    // Write your code here
        
    wire [31:0] m1_out;
    wire [31:0] m2_out;
    wire [31:0] m3_out;
    wire [3:0] alu_control;

    assign alu_in2_out = m2_out;

    mux4 #(.mux_width(32)) m1 (
        .a(reg1),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .d(0),
        .sel(Forward_A),
        .y(m1_out)
    );

    mux4 #(.mux_width(32)) m2 (
        .a(reg2),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .d(0),
        .sel(Forward_B),
        .y(m2_out)
    );

    mux2 #(.mux_width(32)) m3 (
        .a(m2_out),
        .b(id_ex_imm_value),
        .sel(id_ex_alu_src),
        .y(m3_out)
    );

    ALU alu1 (
        .a(m1_out),
        .b(m3_out),
        .alu_control(alu_control),
        .alu_result(alu_result)
    );

    ALUControl alu_control_unit (
        .ALUOp(id_ex_alu_op),
        .Function(id_ex_instr[5:0]),
        .ALU_Control(alu_control)
    );
       
endmodule

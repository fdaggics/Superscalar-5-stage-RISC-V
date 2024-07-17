`timescale 1ns / 1ps


module ID_pipe_stage(
    input  clk, reset,
    input  [9:0] pc_plus4,
    input  [31:0] instr,
    input  mem_wb_reg_write,
    input  [4:0] mem_wb_write_reg_addr,
    input  [31:0] mem_wb_write_back_data,
    input  Data_Hazard,
    input  Control_Hazard,
    output [31:0] reg1, reg2,
    output [31:0] imm_value,
    output [9:0] branch_address,
    output [9:0] jump_address,
    output branch_taken,
    output [4:0] destination_reg, 
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,  
    output mem_write,
    output alu_src,
    output reg_write,
    output jump
    );
    
    wire reg_dst;
    wire [6:0] ctrl_out;
    wire ctrl_branch;
    wire [31:0] sign_extended;
    wire [6:0] m1_out;

    assign jump_address = instr[25:0] << 2;
    assign branch_taken = ctrl_branch && (reg1 == reg2);
    assign sign_extended = {{16{instr[15]}}, instr[15:0]};
    assign branch_address = pc_plus4 + (sign_extended[9:0]<<2);
    assign imm_value = sign_extended;

    control ctrl (
        .reset(reset),
        .opcode(instr[31:26]),
        .reg_dst(reg_dst),
        .mem_to_reg(ctrl_out[6]),
        .alu_op(ctrl_out[5:4]),
        .mem_read(ctrl_out[3]),
        .mem_write(ctrl_out[2]),
        .alu_src(ctrl_out[1]),
        .reg_write(ctrl_out[0]),
        .branch(ctrl_branch),
        .jump(jump)
    );

    mux2 #(.mux_width(7)) m1 (
        .a(ctrl_out),
        .b(7'b0),
        .sel(Control_Hazard || ~(Data_Hazard)),
        .y(m1_out)
    );

    assign mem_to_reg = m1_out[6];
    assign alu_op = m1_out[5:4];
    assign mem_read = m1_out[3];
    assign mem_write = m1_out[2];
    assign alu_src = m1_out[1];
    assign reg_write = m1_out[0];

    mux2 #(.mux_width(5)) m2 (
        .a(instr[20:16]),
        .b(instr[15:11]),
        .sel(reg_dst),
        .y(destination_reg)
    );

    register_file registers (
        .clk(clk),
        .reset(reset),
        .reg_write_en(mem_wb_reg_write),
        .reg_write_dest(mem_wb_write_reg_addr),
        .reg_write_data(mem_wb_write_back_data),
        .reg_read_addr_1(instr[25:21]),
        .reg_read_addr_2(instr[20:16]),
        .reg_read_data_1(reg1),
        .reg_read_data_2(reg2)
    );
    // write your code here 
    // Remember that we test if the branch is taken or not in the decode stage. 	
       
endmodule

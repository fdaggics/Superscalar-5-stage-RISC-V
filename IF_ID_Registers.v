`timescale 1ns/1ps

module IF_ID_Registers(
    input [9:0] pc_plus4,
    input [31:0] instr,
    input clk, reset, en, flush, 
    output [9:0] if_id_pc_plus4,
    output [31:0] if_id_instr
);

wire [41:0] q; 

pipe_reg_en #(.WIDTH(42)) in_reg (
    .clk(clk),
    .reset(reset),
    .en(en),
    .flush(flush),
    .d({pc_plus4, instr}), 
    .q(q) 
);

assign if_id_pc_plus4 = q[41:32]; 
assign if_id_instr = q[31:0];

endmodule

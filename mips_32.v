`timescale 1ns / 1ps


module mips_32(
    input clk, reset,  
    output[31:0] result
    );
    
// define all the wires here. You need to define more wires than the ones you did in Lab2
// assign result = 1;
// assign en = 1;

// IF stage wires
wire [9:0] branch_address;
wire [9:0] jump_address;
wire en;
assign en = Data_Hazard;
wire branch_taken;
wire jump;

// IF/ID register wires
wire [9:0] pc_plus4;
wire [31:0] instr;
wire flush;
wire [41:0] if_id_q;
wire [9:0] if_id_pc_plus4;
wire [31:0] if_id_instr;

// ID stage wires
wire [4:0] mem_wb_write_reg_addr;
assign mem_wb_write_reg_addr = mem_wb_destination_reg;
wire [31:0] mem_wb_write_back_data;
wire Data_Hazard;
wire Control_Hazard;
assign Control_Hazard = flush;
wire [31:0] reg1;
wire [31:0] reg2;
wire [31:0] imm_value;
// wire [9:0] branch_address;
// wire [9:0] jump_address;
// wire branch_taken;
wire [4:0] destination_reg;
wire mem_to_reg;
wire [1:0] alu_op;
wire mem_read;
wire mem_write;
wire alu_src;
wire reg_write;
// wire jump;

// ID/EX registers wires
wire [139:0] id_ex_q;
wire [31:0] id_ex_instr;
wire [31:0] id_ex_reg1;
wire [31:0] id_ex_reg2;
wire [31:0] id_ex_imm_value;
wire [4:0] id_ex_destination_reg;
wire id_ex_mem_to_reg;
wire [1:0] id_ex_alu_op;
wire id_ex_mem_read;
wire id_ex_mem_write;
wire id_ex_alu_src;
wire id_ex_reg_write;

// EX stage wires
wire [31:0] alu_in2_out;
wire [31:0] alu_result;

// EX/MEM register wires
wire [31:0] ex_mem_alu_result;
wire [104:0] ex_mem_q;
wire [31:0] ex_mem_instr;
wire [4:0] ex_mem_destination_reg;
wire [31:0] ex_mem_alu_in2_out;
wire ex_mem_mem_to_reg;
wire ex_mem_mem_read;
wire ex_mem_mem_write;
wire ex_mem_reg_write;

// data memory
wire [31:0] mem_read_data;

// MEM/WB register wires
wire [70:0] mem_wb_q;
wire [31:0] mem_wb_alu_result;
wire [31:0] mem_wb_mem_read_data;
wire mem_wb_mem_to_reg;
wire mem_wb_reg_write;
wire [4:0] mem_wb_destination_reg;

// Forwarding Unit wires
wire [1:0] Forward_A;
wire [1:0] Forward_B;

// Build the pipeline as indicated in the lab manual

///////////////////////////// Instruction Fetch    
    // Complete your code here      
IF_pipe_stage IF_unit (
// inputs
	.clk(clk),
	.reset(reset),
	.branch_address(branch_address),
	.jump_address(jump_address),
	.en(en),
	.branch_taken(branch_taken),
	.jump(jump),
// outputs
	.pc_plus4(pc_plus4),
	.instr(instr)
);
        
///////////////////////////// IF/ID registers
    // Complete your code here
pipe_reg_en #(.WIDTH(42)) if_id_regs (
	.clk(clk),
	.reset(reset),
	.en(en),
	.flush(flush),
	.d({pc_plus4, instr}),
	.q(if_id_q)
);
assign if_id_pc_plus4 = if_id_q[41:32];
assign if_id_instr = if_id_q[31:0];

///////////////////////////// Instruction Decode 
	// Complete your code here
ID_pipe_stage id_pipe_stage (
// inputs
	.clk(clk),
	.reset(reset),
	.pc_plus4(if_id_pc_plus4),
	.instr(if_id_instr),
	.mem_wb_reg_write(mem_wb_reg_write),
	.mem_wb_write_reg_addr(mem_wb_write_reg_addr),
	.mem_wb_write_back_data(write_back_data),
	.Data_Hazard(Data_Hazard),
	.Control_Hazard(Control_Hazard),
// outputs
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
             
///////////////////////////// ID/EX registers 
	// Complete your code here
pipe_reg #(.WIDTH(140)) id_ex_regs (
// inputs
	.clk(clk),
	.reset(reset),
	.d({if_id_instr, 
		reg1, 
		reg2, 
		imm_value, 
		destination_reg, 
		mem_to_reg, 
		alu_op, 
		mem_read, 
		mem_write, 
		alu_src, 
		reg_write}),
// outputs
	.q(id_ex_q)
);
assign id_ex_instr = id_ex_q[139:108];
assign id_ex_reg1 = id_ex_q[107:76];
assign id_ex_reg2 = id_ex_q[75:44];
assign id_ex_imm_value = id_ex_q[43:12];
assign id_ex_destination_reg = id_ex_q[11:7];
assign id_ex_mem_to_reg = id_ex_q[6];
assign id_ex_alu_op = id_ex_q[5:4];
assign id_ex_mem_read = id_ex_q[3];
assign id_ex_mem_write = id_ex_q[2]; 
assign id_ex_alu_src = id_ex_q[1];
assign id_ex_reg_write = id_ex_q[0];


///////////////////////////// Hazard_detection unit
	// Complete your code here    
Hazard_detection hazard_detection_unit (
// inputs
	.id_ex_mem_read(id_ex_mem_read),
	.id_ex_destination_reg(id_ex_destination_reg),
	.if_id_rs(if_id_instr[25:21]),
	.if_id_rt(if_id_instr[20:16]),
	.branch_taken(branch_taken),
	.jump(jump),
// outputs
	.Data_Hazard(Data_Hazard),
	.IF_Flush(flush)
);
           
///////////////////////////// Execution    
	// Complete your code here
EX_pipe_stage ex_pip_stage (
//inputs
	.id_ex_instr(id_ex_instr),
	.reg1(id_ex_reg1),
	.reg2(id_ex_reg2),
	.id_ex_imm_value(id_ex_imm_value),
	.ex_mem_alu_result(ex_mem_alu_result),
	.mem_wb_write_back_result(write_back_data),
	.id_ex_alu_src(id_ex_alu_src),
	.id_ex_alu_op(id_ex_alu_op),
	.Forward_A(Forward_A),
	.Forward_B(Forward_B),
// outputs
	.alu_in2_out(alu_in2_out),
	.alu_result(alu_result)

);
        
///////////////////////////// Forwarding unit
	// Complete your code here 
EX_Forwarding_unit forwarding_unit (
// inputs
	.ex_mem_reg_write(ex_mem_reg_write),
	.ex_mem_write_reg_addr(ex_mem_destination_reg),
	.id_ex_instr_rs(id_ex_instr[25:21]),
	.id_ex_instr_rt(id_ex_instr[20:16]),
	.mem_wb_reg_write(mem_wb_reg_write),
	.mem_wb_write_reg_addr(mem_wb_destination_reg),
// outputs 
	.Forward_A(Forward_A),
	.Forward_B(Forward_B)
);
     
///////////////////////////// EX/MEM registers
	// Complete your code here 
pipe_reg #(.WIDTH(105)) ex_mem_regs (
	.clk(clk),
	.reset(reset),
	.d({id_ex_instr, 
		id_ex_destination_reg,
		alu_result,
		alu_in2_out,
		id_ex_mem_to_reg,
		id_ex_mem_read,
		id_ex_mem_write,
		id_ex_reg_write}),
	.q(ex_mem_q)
);
assign ex_mem_instr        = ex_mem_q[104:73]; // 32 bits for instruction
assign ex_mem_destination_reg = ex_mem_q[72:68]; // 5 bits for destination register
assign ex_mem_alu_result   = ex_mem_q[67:36]; // 32 bits for ALU result
assign ex_mem_alu_in2_out  = ex_mem_q[35:4]; // 32 bits for the second ALU input
assign ex_mem_mem_to_reg   = ex_mem_q[3]; // 1 bit for the mem_to_reg control signal
assign ex_mem_mem_read     = ex_mem_q[2]; // 1 bit for the mem_read control signal
assign ex_mem_mem_write    = ex_mem_q[1]; // 1 bit for the mem_write control signal
assign ex_mem_reg_write    = ex_mem_q[0]; // 1 bit for the reg_write control signal

    
///////////////////////////// memory    
	// Complete your code here
data_memory data_mem (
// inputs
	.clk(clk),
	.mem_access_addr(ex_mem_alu_result),
	.mem_write_data(ex_mem_alu_in2_out),
	.mem_write_en(ex_mem_mem_write),
	.mem_read_en(ex_mem_mem_read),
// outputs
	.mem_read_data(mem_read_data)
);

///////////////////////////// MEM/WB registers  
	// Complete your code here
pipe_reg #(.WIDTH(71)) mem_wb_regs (
	.clk(clk),
	.reset(reset),
	.d({
		ex_mem_alu_result,
		mem_read_data,
		ex_mem_mem_to_reg,
		ex_mem_reg_write,
		ex_mem_destination_reg
	}),
	.q(mem_wb_q)
);
assign mem_wb_alu_result = mem_wb_q[70:39];       // 32 bits for ALU result
assign mem_wb_mem_read_data = mem_wb_q[38:7];     // 32 bits for memory read data
assign mem_wb_mem_to_reg = mem_wb_q[6];           // 1 bit for mem_to_reg control signal
assign mem_wb_reg_write = mem_wb_q[5];            // 1 bit for reg_write control signal
assign mem_wb_destination_reg = mem_wb_q[4:0];    // 5 bits for destination register

///////////////////////////// writeback    
	// Complete your code here
wire [31:0] write_back_data;
assign write_back_data = mem_wb_mem_to_reg ? mem_wb_mem_read_data : mem_wb_alu_result;
assign result = write_back_data;

    
endmodule

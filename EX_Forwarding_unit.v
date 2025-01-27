`timescale 1ns / 1ps


module EX_Forwarding_unit(
    input ex_mem_reg_write,
    input [4:0] ex_mem_write_reg_addr,
    input [4:0] id_ex_instr_rs,
    input [4:0] id_ex_instr_rt,
    input mem_wb_reg_write,
    input [4:0] mem_wb_write_reg_addr,
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B
    );
    
    always @(*)  
    begin
        if(
            ex_mem_reg_write 
            && ex_mem_write_reg_addr != 0
            && ex_mem_write_reg_addr == id_ex_instr_rs
        ) 
            Forward_A = 2'b10;

        else if(
            mem_wb_reg_write 
            && (mem_wb_write_reg_addr != 5'b00000) 
            && (~(ex_mem_reg_write &&(ex_mem_write_reg_addr != 5'b00000) && (ex_mem_write_reg_addr == id_ex_instr_rs))) 
            && (mem_wb_write_reg_addr == id_ex_instr_rs)
        )
            Forward_A = 2'b01;
        else
            Forward_A = 2'b00;

        if(
            mem_wb_reg_write
            && ex_mem_write_reg_addr != 0
            && !(ex_mem_reg_write && ex_mem_write_reg_addr!=0 && ex_mem_write_reg_addr==id_ex_instr_rt) 
            && mem_wb_write_reg_addr == id_ex_instr_rt
        )
            Forward_B = 2'b01;
        else if(
            ex_mem_reg_write
            && ex_mem_write_reg_addr != 0
            && id_ex_instr_rt == ex_mem_write_reg_addr
        )
            Forward_B = 2'b10;
        else 
            Forward_B = 2'b00;
// 	// Write your code here that calculates the values of Forward_A and Forward_B
    end 

endmodule
// `timescale 1ns / 1ps


// module EX_Forwarding_unit(
//     input ex_mem_reg_write,
//     input [4:0] ex_mem_write_reg_addr,
//     input [4:0] id_ex_instr_rs,
//     input [4:0] id_ex_instr_rt,
//     input mem_wb_reg_write,
//     input [4:0] mem_wb_write_reg_addr,
//     output reg [1:0] Forward_A,
//     output reg [1:0] Forward_B
//     );
    
//     always @(*)  
//     begin
// 	// Write your code here that calculates the values of Forward_A and Forward_B
// 	if (ex_mem_reg_write && (ex_mem_write_reg_addr != 5'b00000) && (ex_mem_write_reg_addr == id_ex_instr_rs))
// 	begin
// 	   assign Forward_A = 2'b10;
// 	end
	
// 	else if(mem_wb_reg_write && (mem_wb_write_reg_addr != 5'b00000) && (~(ex_mem_reg_write &&(ex_mem_write_reg_addr != 5'b00000) 
// 	   && (ex_mem_write_reg_addr == id_ex_instr_rs))) && (mem_wb_write_reg_addr == id_ex_instr_rs))
// 	begin
// 	   assign Forward_A = 2'b01;
// 	end
	
// 	else 
// 	begin
// 	   assign Forward_A = 2'b00;
// 	end
	
// 	if(ex_mem_reg_write && (ex_mem_write_reg_addr != 5'b00000) && (ex_mem_write_reg_addr == id_ex_instr_rt))
// 	begin
// 	   assign Forward_B = 2'b10;
//     end

//     else if(mem_wb_reg_write && (mem_wb_write_reg_addr != 5'b00000) &&(~(ex_mem_reg_write && (ex_mem_write_reg_addr != 5'b00000) 
// 	   && (ex_mem_write_reg_addr == id_ex_instr_rt))) && (mem_wb_write_reg_addr == id_ex_instr_rt))
// 	begin
// 	   assign Forward_B = 2'b01;
// 	end
	
// 	else
// 	begin
// 	   assign Forward_B = 2'b00;
// 	end
//     end 

// endmodule

alu:
	iverilog -o Testbench/alu_test.vvp ALU.v Testbench/tb_ALU.v
	vvp Testbench/alu_test.vvp

IF:
	iverilog -o Testbench/if_pipe_stage_test.vvp IF_pipe_stage.v instruction_mem.v mux.v pipe_reg_en.v Testbench/tb_IF_pipe_stage.v 
	vvp Testbench/if_pipe_stage_test.vvp

ID:
	iverilog -o Testbench/id_pipe_stage_test.vvp ID_pipe_stage.v control.v mux.v register_file.v Testbench/tb_ID_pipe_stage.v 
	vvp Testbench/id_pipe_stage_test.vvp

EX:
	iverilog -o Testbench/tb_EX_pipe_stage.vvp EX_pipe_stage.v ALU.v ALUControl.v mux4.v mux.v Testbench/tb_EX_pipe_stage.v 
	vvp Testbench/tb_EX_pipe_stage.vvp

Hazard:
	iverilog -o Testbench/hazard_detection_test.vvp Hazard_detection.v Testbench/tb_Hazard_detection.v 
	vvp Testbench/hazard_detection_test.vvp

mips:
	iverilog -o Testbench/mips_32_test.vvp mips_32.v control.v register_file.v EX_Forwarding_unit.v data_memory.v EX_pipe_stage.v mux4.v ALU.v ALUControl.v IF_pipe_stage.v ID_pipe_stage.v instruction_mem.v mux.v pipe_reg_en.v pipe_reg.v Hazard_detection.v Testbench/tb_mips_32.v
	vvp Testbench/mips_32_test.vvp

grading:
	iverilog -o Testbench/mips_32_grading.vvp mips_32.v control.v register_file.v EX_Forwarding_unit.v data_memory.v EX_pipe_stage.v mux4.v ALU.v ALUControl.v IF_pipe_stage.v ID_pipe_stage.v instruction_mem.v mux.v pipe_reg_en.v pipe_reg.v Hazard_detection.v Testbench/tb_mips_32_grading.v
	vvp Testbench/mips_32_grading.vvp
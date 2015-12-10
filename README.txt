Final Project EECE 3324 Computer Architecture
Chris Kenyon and Brandon Nguyen


This simulation should be run from the project file. The project files should be altered first to reference appropriate file paths rather than the absolute paths that are present from our local machines.

Modules to be compiled are contained in:
 alu.v
 aluCtrl.v
 CPU.v
 ctrlUnit.v
 leftshift2_32b.v
 memory.v
 mux2_1.v
 mux5b2_1.v
 mux32b2_1.v
 reg_32.v
 reg_file.v
 signextender.v

The testbench to be run is CPU_tb.v. The simulation should be run for at least 3 us, as the 149 instructions should run for 2980 ns before reaching the HLT instruction which will stop ($stop call).

Waveform results can be seen in three parts from 'CPU Values.png', 'CPU Values 2.png', and 'CPU Values 3.png'

Expected register results:

R0: 0x00000000 		R1: 0x00000000
R2: 0x00000000 		R3: 0x00000000
R4: 0x00000000 		R5: 0x00000000
R6: 0x00000000 		R7: 0x00000000
R8: 0x00000028 		R9: 0x00000000
R10: 0xfffffff0 	R11: 0x00000015
R12: 0x00000015 	R13: 0x00000001
R14: 0x00000000 	R15: 0x00000000
R16: 0x00000000 	R17: 0x00000009
R18: 0x00000005 	R19: 0x00000009
R20: 0x00000000 	R21: 0x00000000
R22: 0x00000000 	R23: 0x00000000
R24: 0x00000000 	R25: 0x00000000
R26: 0x00000000 	R27: 0x00000000
R28: 0x00000000 	R29: 0x00000000
R30: 0x00000000 	R31: 0x00000000

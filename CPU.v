// FIX
// Chris Kenyon
// CPU

module CPU(reset, PC, instruction, dataAddress, dataIn, MemRead, MemWrite, dataOut, clk);
	// inputs
	input [31:0] instruction, dataIn, dataOut;
	input clk, reset;
	// outputs
	output MemRead, MemWrite;
	output reg[31:0] dataAddress = 0, PC = 'h3000;
	// control
	wire RegDst, Jump, Branch, MemtoReg, ALUsrc, RegWrite, zero;
	wire [4:0] writeReg;
	wire [3:0] operation;
	wire [1:0] ALUop;
	wire [31:0] nextPC, readData1, readData2, writeData, aluInput, signExtend, extendedAndShifted,
	      nextInstAddr, ALUresult, branchAddress, jumpComponent, PCplusFour;
	reg [5:0] opcode, funct;
	reg [31:0] jumpAddress;
	
	// muxes
	mux5b2_1  mux_writeRegister(instruction[15:11], instruction[20:16], RegDst, writeReg);
	mux32b2_1 mux_writeData(dataOut, ALUresult, MemtoReg, writeData);
	mux32b2_1 mux_PC(jumpAddress, nextInstAddr, Jump, nextPC);
	mux32b2_1 mux_ALU(signExtend, readData2, ALUsrc, aluInput);
	mux32b2_1 mux_branch(branchAddress, PCplusFour, zero&&Branch, nextInstAddr);

	// regfile
	reg_file regFile(reset, RegWrite, clk, instruction[25:21], instruction[20:16], writeReg, writeData, readData1, readData2);

	// controlunit
	controlunit controlUnit(opcode, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUsrc, RegWrite, ALUop);
					
	//ALU
	alu alu(ALUresult, zero, operation, readData1, aluInput);
  alu_control aluControl(ALUop, funct, operation);
  
	// bit operations
	signextender signExtender(instruction[15:0], signExtend);
	leftshift2_32b shiftLeftSignExtend(signExtend, extendedAndShifted);
  leftshift2_32b shiftLeftJump(instruction[25:0], jumpComponent);
  
	assign dataIn = readData2;
	assign branchAddress = extendedAndShifted + PCplusFour;
	assign PCplusFour = PC + 4;
	
	always@(reset)
	begin
	  dataAddress = 0;
	  PC = 'h3000;
	end
	
	always@(negedge clk)
	  PC = nextPC;
	always@(ALUresult)
	  dataAddress = ALUresult;  
	always@(PCplusFour or jumpComponent)
	  jumpAddress = {PCplusFour[31:28], jumpComponent[27:0]};
	  
	always@(instruction) begin
	  // Get the opcode from 31 - 26 of the instruction
	  opcode <= instruction[31:26]; 
	  funct <= instruction[5:0];
	  // End simulation
	  if(instruction == 8'hFC00000)
	    $stop;
	end
  
endmodule

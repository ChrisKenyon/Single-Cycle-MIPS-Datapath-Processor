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
	      nextInstAddr, ALUresult, branchAddress, PCplusFour;
	wire [27:0] jumpComponent;
	reg [5:0] opcode, funct;
	reg [31:0] jumpAddress;
	
	// muxes
	mux5b2_1  mux_writeRegister(instruction[15:11], instruction[20:16], RegDst, writeReg);
	mux32b2_1 mux_writeData(dataOut, ALUresult, MemtoReg, writeData);
	mux32b2_1 mux_PC(jumpAddress, nextInstAddr, Jump, nextPC);
	mux32b2_1 mux_ALU(signExtend, readData2, ALUsrc, aluInput);
	mux32b2_1 mux_branch(branchAddress, PCplusFour, zero&&Branch, nextInstAddr);

	// reg file
	reg_file regFile(reset, RegWrite, clk, instruction[25:21], instruction[20:16], writeReg, writeData, readData1, readData2);

	// control unit
	controlunit controlUnit(opcode, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUsrc, RegWrite, ALUop);
					
	// ALU
	alu alu(ALUresult, zero, operation, readData1, aluInput);
  alu_control aluControl(ALUop, funct, operation);
  
	// bit operations
	signextender signExtender(instruction[15:0], signExtend);
	leftshift2_32b shiftLeftSignExtend(signExtend, extendedAndShifted);
  leftshift2_32b shiftLeftJump(instruction[25:0], jumpComponent); // This is a size mismatch that will have the first 4 bits unknown. Inconsequential.
  
  // assignments
	assign dataIn = readData2;
	assign branchAddress = extendedAndShifted + PCplusFour;
	assign PCplusFour = PC + 4;
	
	always@(reset)
	begin
	  // when reset, set the initial data address back to 0 and the PC back to 0x3000
	  dataAddress = 0;
	  PC = 'h3000;
	end
	
	// update the PC at the clock
	always@(negedge clk)
	  PC = nextPC;
	// assign dataAddress to be the ALU result
	always@(ALUresult)
	  dataAddress = ALUresult;  
	// construct the address for jumping everytime the pc or jumpcomponent changes
	always@(PCplusFour or jumpComponent)
	  jumpAddress = {PCplusFour[31:28], jumpComponent};
	  
	always@(instruction) begin
	  
	  // opcode and funct can be grabbed from the instruction on every change
	  opcode <= instruction[31:26]; 
	  funct <= instruction[5:0];

	  // The simulation should stop when the halt instruction is loaded
	  if(instruction == 8'hFC00000)
	    $stop;
	end
  
endmodule

// FIX
// Chris Kenyon
// CPU Test bench

`timescale 1ns / 100ps

module CPU_tb;
  wire[31:0] instruction, dataOut, dataIn, instructionAddress, dataAddress;
  wire MemRead, MemWrite;
  reg clk, reset;

Memory memory(instructionAddress, instruction, dataAddress, dataIn, MemRead, MemWrite, dataOut);  
CPU cpu(reset, instructionAddress, instruction, dataAddress, dataIn, MemRead, MemWrite, dataOut, clk);

initial begin
  clk = 0;
  reset= 0;
  #5
  reset = 1;
  #5
  reset = 0;
  
  $display("instruction ",instruction);
  //ALUresult = 0;
end

always
  #10 clk =!clk;

endmodule

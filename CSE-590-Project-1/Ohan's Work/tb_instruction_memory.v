`timescale 1ns / 1ps
module tb_instruction_memory();
    reg [15:0] pc_address;
    wire [15:0] instructions;
    instruction_memory uut (.pc_address(pc_address), .instructions(instructions));
    initial begin
        $display("Instruction Memory Test");
        pc_address = 16'h0000; // Index 0
        #10;
        $display("PC Address: %h | Instruction: %b", pc_address, instructions);
        pc_address = 16'h0002; // Index 1
        #10;
        $display("PC Address: %h | Instruction: %b", pc_address, instructions);
        $display("Done");
        $finish;
    end
endmodule
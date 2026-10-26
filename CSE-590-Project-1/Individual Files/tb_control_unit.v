`timescale 1ns / 1ps
module tb_control_unit();
    reg [3:0] opcode;
    wire regwrite;
    wire alusrc;
    wire memwrite;
    wire memtoreg;
    wire beq;
    wire bne;
    wire jump;
    wire [2:0] aluop;
    control_unit uut (.opcode(opcode), .regwrite(regwrite), .alusrc(alusrc), .memwrite(memwrite), .memtoreg(memtoreg), .beq(beq), .bne(bne), .jump(jump), .aluop(aluop));
    initial begin
        $display("Control Unit Start");
        opcode = 4'b0000; #10; // Testing R-type Instructions
        $display("Opcode 0000 (R-type): regwrite=%b, alusrc=%b, aluop=%b", regwrite, alusrc, aluop);
        opcode = 4'b0001; #10; // Testing Load Word
        $display("Opcode 0001 (lw): regwrite=%b, alusrc=%b, memtoreg=%b, aluop=%b", regwrite, alusrc, memtoreg, aluop);
        opcode = 4'b0010; #10; // Testing Store Word
        $display("Opcode 0010 (sw): memwrite=%b, regwrite=%b (Expected 0)", memwrite, regwrite);
        opcode = 4'b0011; #10; // Testing AddImmediate
        $display("Opcode 0011 (addi): regwrite=%b, alusrc=%b", regwrite, alusrc);
        opcode = 4'b0100; #10; // Testing Branch Equal
        $display("Opcode 0100 (beq): beq=%b, aluop=%b", beq, aluop);
        opcode = 4'b0101; #10; // Testing Branch Not Equal
        $display("Opcode 0101 (bne): bne=%b, aluop=%b", bne, aluop);
        opcode = 4'b0110; #10; // Testing Jump
        $display("Opcode 0110 (jmp): jump=%b", jump);
        $display("Done");
        $finish;
    end
endmodule
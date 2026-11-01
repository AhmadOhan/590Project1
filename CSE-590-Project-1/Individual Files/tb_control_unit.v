`timescale 1ns / 1ps
module tb_control_unit();
    reg [3:0] opcode;
    reg [3:0] func;
    wire regwrite;
    wire alusrc;
    wire memwrite;
    wire memtoreg;
    wire beq;
    wire bne;
    wire jump;
    wire [2:0] aluop;
    control_unit uut (.opcode(opcode), .func(func), .regwrite(regwrite), .alusrc(alusrc), .memwrite(memwrite), .memtoreg(memtoreg), .beq(beq), .bne(bne), .jump(jump), .aluop(aluop));
    initial begin
        $display("Control Unit Start");
        opcode = 4'b0000; #10;
        opcode = 4'b0000; func = 4'b0000; #10; // add
        $display("R-type (add): aluop=%b (Expected 000)", aluop);
        func = 4'b0001; #10; // sub
        $display("R-type (sub): aluop=%b (Expected 001)", aluop);
        func = 4'b0010; #10; // sll
        $display("R-type (sll): aluop=%b (Expected 010)", aluop);
        func = 4'b0011; #10; // and 
        $display("R-type (and): aluop=%b (Expected 011)", aluop);
        opcode = 4'b0001; #10; // lw
        $display("Opcode 0001 (lw): regwrite=%b, alusrc=%b, memtoreg=%b, aluop=%b", regwrite, alusrc, memtoreg, aluop);
        opcode = 4'b0010; #10; // sw
        $display("Opcode 0010 (sw): memwrite=%b, regwrite=%b (Expected 0)", memwrite, regwrite);
        opcode = 4'b0011; #10; // addi
        $display("Opcode 0011 (addi): regwrite=%b, alusrc=%b", regwrite, alusrc);
        opcode = 4'b0100; #10; // beq
        $display("Opcode 0100 (beq): beq=%b, aluop=%b", beq, aluop);
        opcode = 4'b0101; #10; // bne
        $display("Opcode 0101 (bne): bne=%b, aluop=%b", bne, aluop);
        opcode = 4'b0110; #10; // jmp
        $display("Opcode 0110 (jmp): jump=%b", jump);
        $display("Done");
        $finish;
    end
endmodule
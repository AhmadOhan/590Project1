`timescale 1ns / 1ps
module tb_branch_jump_pc();
    reg [15:0] current;
    reg [15:0] in;
    reg zero;
    reg bne;
    reg beq;
    reg jump;
    wire return_flag;
    wire [15:0] next;
    branch_jump_pc uut (
        .current(current),
        .in(in),
        .zero(zero),
        .bne(bne),
        .beq(beq),
        .jump(jump),
        .return(return_flag),
        .next(next));
    initial begin
        $display("Branch and Jump Test:");
        current = 16'h0010; in = 4'b0010; zero = 1'b1; beq = 1'b1; bne = 1'b0; jump = 1'b0; //testing BEQ: zero = 1, immediate = +2
        #10;
        $display("BEQ Taken | next = %h (Expected: 0014), return = %b (Expected: 1)", next, return_flag);
        zero = 1'b0;
        #10;
        $display("BEQ Not Taken | next = %h (Expected: 0012), return = %b (Expected: 0 (or branch condition false))", next, return_flag); //testing BEQ not taken zero = 0, immediate = +2
        current = 16'h0010; in = 16'h0004; zero = 1'b0; beq = 1'b0; bne = 1'b0; jump = 1'b1; //Jmp, offset = 4, sll 1 so its 8, address + 2 + 8 
        #10;
        $display("JMP | next = %h (Expected: 001A), return = %b (Expected: 1)", next, return_flag); //jump return 1
        $display("Done");
        $finish;
    end
endmodule
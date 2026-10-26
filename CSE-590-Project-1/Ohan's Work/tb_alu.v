`timescale 1ns / 1ps
module tb_alu();
    reg [15:0] rs;
    reg [15:0] rd;
    reg [2:0] alu_operation;
    wire [15:0] results;
    alu uut ( .rs(rs), .rd(rd), .alu_operation(alu_operation), .results(results));
    initial begin
        $display("ALU Test");
        rs = 16'd12; rd = 16'd4; alu_operation = 3'b000; #10;
        $display("ADD: %d + %d = %d (Expected: 16)", rs, rd, results); //16
        rs = 16'd20; rd = 16'd7; alu_operation = 3'b001; #10;
        $display("SUB: %d - %d = %d (Expected: 13)", rs, rd, results);//13
        rs = 16'd3; rd = 16'd2; alu_operation = 3'b010; #10;
        $display("SLL: %d << %d = %d (Expected: 12)", rs, rd, results);//12
        rs = 16'h0F0F; rd = 16'h3333; alu_operation = 3'b011; #10;
        $display("AND: %h & %h = %h (Expected: 0303)", rs, rd, results);//0303
        $display("Finished");
        $finish;
    end
endmodule
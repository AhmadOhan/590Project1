`timescale 1ns / 1ps
module tb_multiplexers();
    reg [15:0] input0;
    reg [15:0] input1;
    reg select;
    wire [15:0] result;
    multiplexers uut (.input0(input0), .input1(input1), .select(select), .result(result));
    initial begin
        $display("Multiplexers Start");
        input0 = 16'h1111;//initial setup
        input1 = 16'h9999;
        select = 0;
        #10;
        $display("Select = 0 | Result = %h (Expected: 1111)", result); //should return 1111
        select = 1;
        #10;
        $display("Select = 1 | Result = %h (Expected: 9999)", result); //shold return 9999
        $display("Multiplexers Done");
        $finish;
    end
endmodule
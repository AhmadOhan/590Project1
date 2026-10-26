`timescale 1ns / 1ps
module tb_program_counter();
    reg clock;
    reg reset;
    reg write;
    reg [15:0] next;
    wire [15:0] out;
    program_counter uut (.clock(clock), .reset(reset), .write(write), .next(next), .out(out));
    always #5 clock = ~clock;
    initial begin
        clock = 0;
        reset = 1;
        write = 0;
        next = 16'h0000;
        #12;
        $display("PC Started");
        $display("Time=%0t | Reset active | out = %h (Expected: 0000)", $time, out);
        reset = 0;
        write = 1;
        next = 16'h0002;
        #10;
        $display("Time=%0t | write=1, next=0002 | out = %h (Expected: 0002)", $time, out);
        next = 16'h0004;
        #10;
        $display("Time=%0t | write=1, next=0004 | out = %h (Expected: 0004)", $time, out);
        write = 0; //No More Writing
        next = 16'h000A; //Should Hold value
        #10;
        $display("Time=%0t | write=0, next=000A | out = %h (Expected: 0004)", $time, out);
        $display("Done");
        $finish;
    end
endmodule
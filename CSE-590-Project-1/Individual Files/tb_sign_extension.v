`timescale 1ns / 1ps

module tb_sign_extension();
    reg [3:0] inputs;
    wire [15:0] outputs;
    sign_extension uut (.inputs(inputs), .outputs(outputs));
    initial begin
        $display("Sign Ext Start");
        inputs = 4'b0101; //+5
        #10;
        $display("Input = %b | Output = %h (Expected: 0005)", inputs, outputs);
        inputs = 4'b1111; // -1
        #10;
        $display("Input = %b | Output = %h (Expected: FFFF)", inputs, outputs);
        inputs = 4'b1011; // -5
        #10;
        $display("Input = %b | Output = %h (Expected: FFFB)", inputs, outputs);
        $display("Done");
        $finish;
    end
endmodule
`timescale 1ns / 1ps
module tb_data_memory();
    reg clock;
    reg enabled;
    reg [15:0] address;
    reg [15:0] write;
    wire [15:0] read;
    data_memory uut (.clock(clock), .enabled(enabled), .address(address), .write(write), .read(read));
    always #5 clock = ~clock; //needed for the writeback to memory
    initial begin
        clock = 0;
        enabled = 0;
        address = 0;
        write = 0;
        #10;
        $display("Data Memory Test: ");
        enabled = 1;
        address = 16'h0004;
        write = 16'hFEED;// Write 0xFEED to address 16'h0004 (Word index 2)
        #10;
        enabled = 0;// Read back from address 16'h0004 (enabled = 0)
        #10;
        $display("Address %h | Read Data = %h (Expected: FEED)", address, read);
        $display("DONE");
        $finish;
    end
endmodule
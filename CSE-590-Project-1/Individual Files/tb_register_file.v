`timescale 1ns / 1ps
module tb_register_file();
    reg clock;
    reg write_enabled;
    reg [3:0] rs_address;
    reg [3:0] rtrd_address;
    reg [15:0] write_register_data;
    wire [15:0] rs_data;
    wire [15:0] rtrd_data;
    register_file uut (.clock(clock), .write_enabled(write_enabled), .rs_address(rs_address), .rtrd_address(rtrd_address), .write_register_data(write_register_data), .rs_data(rs_data), .rtrd_data(rtrd_data));
    always #5 clock = ~clock; //needed for writeback to memory
    initial begin //initial Setup
        clock = 0;
        write_enabled = 0;
        rs_address = 0;
        rtrd_address = 0;
        write_register_data = 0;
        #10;
        $display("Reg File Start");
        write_enabled = 1;
        rtrd_address = 4'b0000;// Write to Reg 0 (This should stay 0)
        write_register_data = 16'hFFFF;
        #10;
        rtrd_address = 4'b0001;// Try writing to reg 1
        write_register_data = 16'hABCD;
        #10;
        write_enabled = 0; // Read back both registers
        rs_address = 4'b0000;
        rtrd_address = 4'b0001;
        #10;
        $display("Reg[0] = %h (Expected: 0000) | Reg[1] = %h (Expected: ABCD)", rs_data, rtrd_data);
        $display("Done");
        $finish;
    end
endmodule
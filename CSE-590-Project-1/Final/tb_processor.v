`timescale 1ns / 1ps
module tb_processor();
    reg clock;
    reg reset;
    processor uut ( .clock(clock), .reset(reset));
    always #5 clock = ~clock; //for writeback to memory
    initial begin
        clock = 0; //initializing clock
        reset = 1; // Startup Reset otherwise it keeps old stuff
        $display("Full Processor Test");
        // Hold reset active for 15ns, then release
        #15; //Reset takes 15 ns
        reset = 0; /releases
        #200; //Let it run for 200ns
        $display("Done");
        $finish;
    end
endmodule
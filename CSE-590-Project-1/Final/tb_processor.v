`timescale 1ns / 1ps
module tb_processor();
    reg clock;
    reg reset;
    processor uut ( //instantiating clock and reset
        .clock(clock), 
        .reset(reset),
        .leds(),
        .io_pc(),
        .io_curr_inst(),
        .io_alu_result()
    );
    always #5 clock = ~clock; //10ns cycle, 5 high, 5 low
    initial begin
        clock = 0; //clock starts at 0
        reset = 1; //actively reset the entire processor just in case
        $display("Starting Full test");
        #10;
        reset = 0; //unlocking processor to start doing stuff
        // Testing each feature
        #12; $display("Time=%0t | PC=%h | Inst=%b | Reg[1](s1)=%d", $time, uut.pc_current, uut.instruction, uut.regfile_inst.registers[1]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | Reg[2](s2)=%d", $time, uut.pc_current, uut.instruction, uut.regfile_inst.registers[1]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | Reg[2](s2)=%d (ADD Result)", $time, uut.pc_current, uut.instruction, uut.regfile_inst.registers[2]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | Reg[2](s2)=%d (SUB Result)", $time, uut.pc_current, uut.instruction, uut.regfile_inst.registers[2]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | Reg[2](s2)=%d (SLL Result)", $time, uut.pc_current, uut.instruction, uut.regfile_inst.registers[2]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | Reg[2](s2)=%d (AND Result)", $time, uut.pc_current, uut.instruction, uut.regfile_inst.registers[2]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | DataMem[4]=%h (SW Executed)", $time, uut.pc_current, uut.instruction, uut.dmem_inst.memory[2]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | Reg[2](s2)=%d (LW Loaded)", $time, uut.pc_current, uut.instruction, uut.regfile_inst.registers[2]);
        #10; $display("Time=%0t | PC=%h | Inst=%b | PC Next (BEQ Check)=%h", $time, uut.pc_current, uut.instruction, uut.pc_next);
        #10; $display("Time=%0t | PC=%h | Inst=%b | PC Next (BNE Check)=%h", $time, uut.pc_current, uut.instruction, uut.pc_next);
        #10; $display("Time=%0t | PC=%h | Inst=%b | PC Next (JMP Check)=%h", $time, uut.pc_current, uut.instruction, uut.pc_next);
        #40;
        $display("Done");
        $finish;
    end
endmodule
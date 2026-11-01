module program_counter(//fix testbench
    input wire clock, //clock signal
    input wire reset, //reset flag
    input wire write, //write back flag
    input wire [15:0] next, //for branches and jumps
    output reg [15:0] out); //output address
    always @(posedge clock) begin  //only when clock is running
        if (reset) begin //if its a reset
            out <= 16'h0000; //reset address to zero
        end
        else if (write) begin  //if we write back and address
            out <= next; //we return the jump/branch address
        end
        else begin 
            out <= out + 16'h0002; //otherwise pc+2
        end
    end
endmodule
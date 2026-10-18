// Program Counter
module program_counter(
    input wire clock,
    input wire reset,
    input wire write,
    input wire [15:0] next,
    output wire [15:0] out);
    always @(posedge clock) begin 
        if (reset) begin 
            out <= 16'h0000;
        end
        else if (write) begin 
            out = next;
        end
    end
endmodule
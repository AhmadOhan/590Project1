//Data Memory
module data_memory(
    input wire clock,
    input wire enabled,
    input wire [15:0] address,
    input wire [15:0] write,
    output wire [15:0] read);
    reg [15:0] memory [255:0];
    assign read = memory[address[8:1]];
    always @(posedge clock) begin 
        if (enabled) begin 
            memory[address[8:1]] <= write;
        end
    end
endmodule
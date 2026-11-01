module data_memory(
    input wire clock, //clock signal
    input wire enabled, //write enabled
    input wire [15:0] address, //memory address of data
    input wire [15:0] write, //write back value
    output wire [15:0] read); //read data
    reg [15:0] memory [255:0]; //memory
    assign read = memory[address[8:1]]; //read the memory address
    always @(posedge clock) begin  //only only valid clock cycle
        if (enabled) begin //if writeback is enabled
            memory[address[8:1]] <= write; //write value back to memory
        end
    end
endmodule
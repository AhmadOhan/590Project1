//Instruction Memory
module instruction_memory(
    input wire [15:0] pc_address // receiving a 16 bit input wire called pc_address from the PC
    output wire [15:0] instructions); //outputting a 16 bit wire called instructions from memory location
    reg [15:0] memory [255:0]; //creating 256 slots that are each 2 bytes
    initial begin 
        $readmemb("instructions.txt", mem); //reads text instructions from external file and converts to mem array
    end
    assign instructions = memory[pc_address[8:1]] //basically assigning it to the first 8 bit index for the 256 slots while still being word aligned and incrementing by 2
endmodule
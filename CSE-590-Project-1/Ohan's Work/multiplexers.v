// Multiplexers
module multiplexers(
    input wire [15:0] input0, // receiving a wire of size 16 bit called input0
    input wire [15:0] input1, // receiving a wire of size 16 bit called input1
    input wire select, // receiving a 1 bit wire called select
    output wire [15:0] result); // outputting a 16 bit wire called result
    assign result = (select) ? input1 : input0; // constantly update
endmodule
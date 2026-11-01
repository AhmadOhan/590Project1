//ALU
module alu(
    input wire [15:0] rs, // rs register
    input wire [15:0] rtrd, // rtrd register
    input wire [2:0] alu_operation, // the arithmetic operation
    output reg [15:0] results); // return result
    always @(*) begin //  always
        case(alu_operation) // all arithmetic ops
            3'b000: results = rs + rtrd; // addition
            3'b001: results = rs - rtrd; //subtraction
            3'b010: results = rs << rtrd; //sll
            3'b011: results = rs & rtrd; //and
            default: results = 16'hxxxx; //default value (otherwise it doesnt work)
        endcase
    end 
endmodule
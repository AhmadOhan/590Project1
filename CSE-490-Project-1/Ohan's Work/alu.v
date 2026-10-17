//ALU
module alu(
    input wire [15:0] rs //
    input wire [15:0] rd //
    input wire [2:0] alu_operation //
    output reg [15:0] results); //
    always @(*) begin // 
        case(alu_operation) //
            3'b000: result = rs + rd; //
            3'b001: result = rs - rd; //
            3'b010: result = rs << rd; //
            3'b011: result = rs & rd; //
            default: result = 16'hxxxx; //
        endcase
    end 

endmodule
//Control Unit
module control_unit(
    input wire [3:0] opcode,
    output reg regwrite,
    output reg alusrc,
    output reg memwrite,
    output reg memtoreg,
    output reg beq,
    output reg bne,
    output reg jump,
    output reg [2:0] aluop);
    always @(*) begin 
        regwrite = 1'b0;
        alusrc = 1'b0;
        memwrite = 1'b0;
        memtoreg = 1'b0;
        beq = 1'b0;
        bne = 1'b0;
        jump = 1'b0;
        aluop = 3'b000;
        case (opcode)
            4'b0000: begin
                regwrite = 1'b1; 
                alusrc = 1'b0; 
                aluop = 3'b000;
            end
            4'b0001: begin
                regwrite = 1'b1; 
                alusrc = 1'b1; 
                memtoreg = 1'b1; 
                aluop = 3'b000;
            end
            4'b0010: begin 
                memwrite = 1'b1; 
                aluop = 3'b000;
            end
            4'b0011: begin
                regwrite = 1'b1; 
                alusrc = 1'b1; 
                aluop = 3'b000;
            end
            4'b0100: begin
                beq = 1'b1; 
                aluop = 3'b001; 
            end
            4'b0101: begin
                bne = 1'b1; 
                aluop = 3'b001;
            end
            4'b0110: begin 
                jump = 1'b1; 
            end
        endcase
    end
endmodule
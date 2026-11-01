//Control Unit
module control_unit(
    input wire [3:0] opcode, //opcode
    input wire [3:0] func, //func code
    output reg regwrite, 
    output reg alusrc,
    output reg memwrite,
    output reg memtoreg,
    output reg beq,
    output reg bne,
    output reg jump,
    output reg [2:0] aluop);
    always @(*) begin 
        regwrite = 1'b0;//initialized defaults
        alusrc = 1'b0;
        memwrite = 1'b0;
        memtoreg = 1'b0;
        beq = 1'b0;
        bne = 1'b0;
        jump = 1'b0;
        aluop = 3'b000;
        case (opcode)//for the opcodes
            4'b0000: begin //if its an arithmetic op
                regwrite = 1'b1; 
                alusrc = 1'b0; 
                case(func)
                    4'b0000: aluop = 3'b000; //add
                    4'b0001: aluop = 3'b001; //sub
                    4'b0010: aluop = 3'b010; //sll
                    4'b0011: aluop = 3'b011; //and
                endcase
            end
            4'b0001: begin //lw
                regwrite = 1'b1; 
                alusrc = 1'b1; 
                memtoreg = 1'b1; 
                aluop = 3'b000;
            end
            4'b0010: begin  //sw
                memwrite = 1'b1; 
                aluop = 3'b000;
            end
            4'b0011: begin //addi
                regwrite = 1'b1; 
                alusrc = 1'b1; 
                aluop = 3'b000;
            end
            4'b0100: begin //beq
                beq = 1'b1; 
                aluop = 3'b001; 
            end
            4'b0101: begin //bne
                bne = 1'b1; 
                aluop = 3'b001;
            end
            4'b0110: begin //jmp
                jump = 1'b1; 
            end
        endcase
    end
endmodule
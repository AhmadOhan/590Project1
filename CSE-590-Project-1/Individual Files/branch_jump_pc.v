module branch_jump_pc(
    input wire [15:0] current, //current address
    input wire [15:0] in, //input address
    input wire zero, //zero flag
    input wire bne, //bne flag
    input wire beq, //beq flag
    input wire jump, //jump flag
    output wire return, //return flag
    output wire [15:0] next); //next address for pc
    wire [15:0] plus_2;
    assign plus_2 = current + 16'h0002; //Just does PC+2
    wire [15:0] immediate;
    assign immediate = (in[3])?{12'hFFF,in[3:0]} : {12'h000,in[3:0]};//immediate
    wire [15:0] bt;
    assign bt = plus_2 + immediate;// pc+2+immediate
    wire [15:0] offset;
    assign offset = {{4{in[11]}}, in[11:0]} << 1; //12 bit address shifted left by 1
    wire [15:0] jt;
    assign jt = plus_2 + offset; // pc+2+the shifted address
    wire branch;
    assign branch = (beq && zero) || (bne && !zero); //take a branch if its beq and the registers are the same or if its bne and registers are different
    assign return = branch || jump; //only return to pc if its either a valid branch or jump
    assign next = jump?jt:bt; // if its a jump, do jump target, otherwise do branch target
endmodule
`timescale 1ns / 1ps
module processor(
    input wire clock,
    input wire reset,
    output wire [15:0] leds,
    output wire [15:0] io_pc,
    output wire [15:0] io_curr_inst,
    output wire [15:0] io_alu_result);
    
    // Internal Wires for Datapath and Control
    wire [15:0] pc_current;
    wire [15:0] pc_next;
    wire [15:0] instruction;

    // Control Unit Signals
    wire regwrite;
    wire alusrc;
    wire memwrite;
    wire memtoreg;
    wire beq;
    wire bne;
    wire jump;
    wire [2:0] aluop;

    // Register File & ALU / Data Wires
    wire [3:0] opcode;
    wire [3:0] rs_addr;
    wire [3:0] rtrd_addr;
    wire [3:0] imm_in;
    wire [3:0] func_code;
    wire [15:0] rs_data;
    wire [15:0] rtrd_data;
    wire [15:0] sign_ext_out;
    wire [15:0] alu_operand_b;
    wire [15:0] alu_result;
    wire [15:0] data_mem_read;
    wire [15:0] write_back_data;
    
    //For Branch and Jump
    wire zero_flag; //zero flag in case they are the same
    wire write_enabled_pc; //write flag for pc (for branch and jump)

    program_counter pc_inst ( //program counter
        .clock(clock), //starts clock
        .reset(reset), // resets pc
        .write(write_enabled_pc), //write flag driven by jump/branch
        .next(pc_next), //feed processor
        .out(pc_current)); //outputs current PC
    

    instruction_memory imem_inst ( //instruction memory
        .pc_address(pc_current), //grabs the pc address
        .instructions(instruction)); //grabs the instructions
    
    assign opcode   = instruction[15:12]; //opcode instruction mapping
    assign rtrd_addr  = instruction[11:8]; //rs instruction mapping
    assign rs_addr  = instruction[7:4]; //rt/rd instruction mapping
    assign imm_in   = instruction[3:0]; //immediate instruction mapping
    assign func_code  = instruction[3:0]; //func code for r type instructions

    control_unit cu_inst ( //Control Unit
        .opcode(opcode), //opcode
        .func(func_code), //function code
        .regwrite(regwrite), //regwrite signal
        .alusrc(alusrc), //alu src signal
        .memwrite(memwrite), //memwrite signal
        .memtoreg(memtoreg), //memtoreg signal
        .beq(beq), //beq signal
        .bne(bne), //bne signal
        .jump(jump), //jump signal
        .aluop(aluop)); //alu op signal
    

    sign_extension sext_inst ( //sign extension
        .inputs(imm_in), //inputs the immediate
        .outputs(sign_ext_out)); //converts to sign extended
    

    register_file regfile_inst ( //Reg File
        .clock(clock), //starts clock
        .write_enabled(regwrite), //enables writeback
        .rs_address(rs_addr), //rs
        .rtrd_address(rtrd_addr), //rt/rd
        .write_register_data(write_back_data), //write register (memory data)
        .rs_data(rs_data), // data from rs
        .rtrd_data(rtrd_data)); // data from rt/rd
    

    multiplexers alu_src_mux ( //ALU SRC
        .input0(rtrd_data), //data from rt/rd
        .input1(sign_ext_out), // sign extend
        .select(alusrc), //grabs the alu SRC
        .result(alu_operand_b)); //pops output
    
    alu alu_inst ( //ALU
        .rs(rs_data), //rs
        .rtrd(alu_operand_b), //rtrd
        .alu_operation(aluop), //does the alu process
        .results(alu_result)); //pops result

    assign zero_flag = (alu_result == 16'h0000); //if rs == rd, return zero

    data_memory dmem_inst ( //datamemory
        .clock(clock), //starts clock
        .enabled(memwrite), //starts memory write
        .address(alu_result), // ALU computes lw/sw
        .write(rtrd_data), // Heres the data for store word
        .read(data_mem_read));//Read back

    multiplexers wb_mux ( //multiplexer for mem to reg
        .input0(alu_result),
        .input1(data_mem_read),
        .select(memtoreg),
        .result(write_back_data));

    branch_jump_pc bjp_inst ( //branch and jump instructions
        .current(pc_current),
        .in(instruction),
        .zero(zero_flag),
        .bne(bne),
        .beq(beq),
        .jump(jump),
        .return(write_enabled_pc),
        .next(pc_next));

    assign leds = pc_current;//all of these for the board
    assign io_pc = pc_current;
    assign io_curr_inst = instruction;
    assign io_alu_result = alu_result;
endmodule




//ALL THE MODULES
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
//Instruction Memory
module instruction_memory(
    input wire [15:0] pc_address, // receiving a 16 bit input wire called pc_address from the PC
    output wire [15:0] instructions); //outputting a 16 bit wire called instructions from memory location
    reg [15:0] memory [255:0]; //creating 256 slots that are each 2 bytes
    initial begin 
        $readmemb("instructions.txt", memory); //reads text instructions from external file and converts to mem array
    end
    assign instructions = memory[pc_address[8:1]]; //basically assigning it to the first 8 bit index for the 256 slots while still being word aligned and incrementing by 2
endmodule
// Multiplexers
module multiplexers(
    input wire [15:0] input0, // receiving a wire of size 16 bit called input0
    input wire [15:0] input1, // receiving a wire of size 16 bit called input1
    input wire select, // receiving a 1 bit wire called select
    output wire [15:0] result); // outputting a 16 bit wire called result
    assign result = (select) ? input1 : input0; // constantly update
endmodule
//Register File
module register_file(//fix testbench
    input wire clock, //clock signal
    input wire write_enabled, //write enabled
    input wire [3:0] rs_address, //rs
    input wire [3:0] rtrd_address, //rt/rd
    input wire [15:0] write_register_data, //data to write back to rt/rd
    output wire [15:0] rs_data, //rs data
    output wire [15:0] rtrd_data); //rtrd data
    reg [15:0] registers [15:0]; //16 registers
    assign rs_data = (rs_address == 4'b0000) ? 16'h0000 : registers[rs_address]; //assign an empty rs with the register address of rs
    assign rtrd_data = (rtrd_address == 4'b0000) ? 16'h0000 : registers[rtrd_address]; //assign the empty rt/rd with the register address of rt/rd
    always @(posedge clock) begin //if its a pos clock signal
        if (write_enabled && (rtrd_address != 4'b0000)) begin
            registers[rtrd_address] <= write_register_data; //writeback data to the rt/rd address
        end
    end
endmodule
//Control Unit
module control_unit(//do tests
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
//Data Memory
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
// Program Counter
module program_counter(//fix testbench
    input wire clock, //clock signal
    input wire reset, //reset flag
    input wire write, //write back flag
    input wire [15:0] next, //for branches and jumps
    output reg [15:0] out); //output address
    always @(posedge clock) begin  //only when clock is running
        if (reset) begin //if its a reset
            out <= 16'h0000; //reset address to zero
        end
        else if (write) begin  //if we write back and address
            out <= next; //we return the jump/branch address
        end
        else begin 
            out <= out + 16'h0002; //otherwise pc+2
        end
    end
endmodule
module branch_jump_pc(
    input wire [15:0] current, //current address
    input wire [15:0] in, //input address
    input wire zero, //zero flag
    input wire bne, //bne flag
    input wire beq, //beq flag
    input wire jump, //jump flag
    output wire return, //return flag
    output wire [15:0] next); //next address for pc
    wire [15:0] plus_2 ;
    assign plus_2 = current + 16'h0002; //Just does PC+2
    wire [15:0] immediate;
    assign immediate = ((in[3])?{12'hFFF,in[3:0]} : {12'h000,in[3:0]}) << 1;//immediate
    wire [15:0] bt;
    assign bt = plus_2 + immediate;// pc+2+immediate
    wire [15:0] offset;
    assign offset = {{4{in[11]}}, in[11:0]} << 1; //12 bit address shifted left by 1
    wire [15:0] jt;
    assign jt = plus_2 + offset; // pc+2+the shifted address
    wire branch;
    assign branch = (beq && zero) || (bne && !zero); //take a branch if its beq and the registers are the same or if its bne and registers are different
    assign return = branch || jump; //only return to pc if its either a valid branch or jump
    assign next = return ? (jump?jt:bt) : plus_2; // if its a jump, do jump target, otherwise do branch target
endmodule
//Sign Extension
module sign_extension(
    input wire [3:0] inputs, //input number
    output wire [15:0] outputs); //output number
    assign outputs = (inputs[3]) ? {12'hFFF, inputs} : {12'h000, inputs}; //sign extension math
endmodule
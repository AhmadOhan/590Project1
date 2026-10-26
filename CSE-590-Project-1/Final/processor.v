`timescale 1ns / 1ps
module processor(
    input wire clock,
    input wire reset);
    
    // Internal Wires for Datapath and Control
    wire [15:0] pc_current;
    wire [15:0] pc_next;
    wire [15:0] pc_plus_2;
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
    wire [3:0] rd_addr;
    wire [3:0] wr_addr;
    wire [3:0] imm_in;
    wire [15:0] rs_data;
    wire [15:0] rd_data;
    wire [15:0] sign_ext_out;
    wire [15:0] alu_operand_b;
    wire [15:0] alu_result;
    wire [15:0] data_mem_read;
    wire [15:0] write_back_data;
    
    //For Branch and Jump
    wire zero_flag; //zero flag in case they are the same
    wire branch_condition; //conditional to differentiate beq from bne
    wire [15:0] branch_target; //target location
    wire [15:0] jump_target; //target location

    program_counter pc_inst ( //program counter
        .clock(clock), //starts clock
        .reset(reset), // resets pc
        .write(1'b1),   //writes to memory 
        .next(pc_next), //feed processor
        .out(pc_current) //outputs current PC
    );
    assign pc_plus_2 = pc_current + 16'h0002; //does pc+2

    instruction_memory imem_inst ( //instruction memory
        .pc_address(pc_current), //grabs the pc address
        .instructions(instruction) //grabs the instructions
    );
    assign opcode   = instruction[15:12]; //opcode instruction mapping
    assign rs_addr  = instruction[11:8]; //rs instruction mapping
    assign rd_addr  = instruction[7:4]; //rd instruction mapping
    assign imm_in   = instruction[3:0]; //immediate instruction mapping
    assign wr_addr  = rd_addr;  //rd/wr for I and R types

    control_unit cu_inst ( //Control Unit
        .opcode(opcode), //opcode
        .regwrite(regwrite), //regwrite signal
        .alusrc(alusrc), //alu src signal
        .memwrite(memwrite), //memwrite signal
        .memtoreg(memtoreg), //memtoreg signal
        .beq(beq), //beq signal
        .bne(bne), //bne signal
        .jump(jump), //jump signal
        .aluop(aluop) //alu op signal
    );

    sign_extension sext_inst ( //sign extension
        .inputs(imm_in), //inputs the immediate
        .outputs(sign_ext_out) //converts to sign extended
    );

    register_file regfile_inst ( //Reg File
        .clock(clock), //starts clock
        .write_enabled(regwrite), //enables writeback
        .rs_address(rs_addr), //rs
        .rd_address(rd_addr), //rd
        .write_register_address(wr_addr), //write register (memory address)
        .write_register_data(write_back_data), //write register (memory data)
        .rs_data(rs_data), // data from rs
        .rd_data(rd_data) // data from rd
    );

    multiplexers alu_src_mux ( //ALU SRC
        .input0(rd_data), //data from rd
        .input1(sign_ext_out), // sign extend
        .select(alusrc), //grabs the alu SRC
        .result(alu_operand_b) //pops output
    );

    alu alu_inst ( //ALU
        .rs(rs_data), //rs
        .rd(alu_operand_b), //rd
        .alu_operation(aluop), //does the alu process
        .results(alu_result) //pops result
    );
    assign zero_flag = (alu_result == 16'h0000); //if rs == rd, return zero

    data_memory dmem_inst ( //datamemory
        .clock(clock), //starts clock
        .enabled(memwrite), //starts memory write
        .address(alu_result), // ALU computes lw/sw
        .write(rd_data), // Heres the data for store word
        .read(data_mem_read) //Read back
    );

    multiplexers wb_mux ( //multiplexer for mem to reg
        .input0(alu_result),
        .input1(data_mem_read),
        .select(memtoreg),
        .result(write_back_data)
    );

    //Here is Branch and Jump
   assign branch_target = pc_plus_2 + sign_ext_out; // Target = pc+2+ immediate
    assign jump_target   = pc_plus_2 + ( { {4{instruction[11]}}, instruction[11:0] } << 1 ); // target = pc+2 + (first 11 bits of an instruction, * 2)
    assign branch_condition = (beq && zero_flag) || (bne && !zero_flag); // take branch if its beq and registers are the same or take branch if its bne and registers are different
    assign pc_next = jump ? jump_target : (branch_condition ? branch_target : pc_plus_2); //next pc value either jumps, branches, or it does pc+2 (in that order)

endmodule




//ALL THE MODULES
//ALU
module alu(
    input wire [15:0] rs, //
    input wire [15:0] rd, //
    input wire [2:0] alu_operation, //
    output reg [15:0] results); //
    always @(*) begin // 
        case(alu_operation) //
            3'b000: results = rs + rd; //
            3'b001: results = rs - rd; //
            3'b010: results = rs << rd; //
            3'b011: results = rs & rd; //
            default: results = 16'hxxxx; //
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
module register_file(
    input wire clock,
    input wire write_enabled,
    input wire [3:0] rs_address,
    input wire [3:0] rd_address,
    input wire [3:0] write_register_address,
    input wire [15:0] write_register_data,
    output wire [15:0] rs_data,
    output wire [15:0] rd_data);
    reg [15:0] registers [15:0];
    assign rs_data = (rs_address == 4'b0000) ? 16'h0000 : registers[rs_address];
    assign rd_data = (rd_address == 4'b0000) ? 16'h0000 : registers[rd_address];
    always @(posedge clock) begin
        if (write_enabled && (write_register_address != 4'b0000)) begin
            registers[write_register_address] <= write_register_data;
        end
    end
endmodule
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
// Program Counter
module program_counter(
    input wire clock,
    input wire reset,
    input wire write,
    input wire [15:0] next,
    output reg [15:0] out);
    always @(posedge clock) begin 
        if (reset) begin 
            out <= 16'h0000;
        end
        else if (write) begin 
            out <= next;
        end
    end
endmodule
//Sign Extension
module sign_extension(
    input wire [3:0] inputs,
    output wire [15:0] outputs);
    assign outputs = (inputs[3]) ? {12'hFFF, inputs} : {12'h000, inputs};
endmodule
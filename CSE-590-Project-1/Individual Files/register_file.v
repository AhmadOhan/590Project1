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
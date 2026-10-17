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
    reg [15:0] registers [15:0]
    assign rs_data = (rs_address == 4'b0000) ? 16'h0000 : registers[rs_address]
    assign rd_data = (rd_address == 4'b0000) ? 16'h0000 : registers[rd_address]
    always @(posedge clock) begin
        if (write_enabled && (write_register_address != 4'b0000)) begin
            registers[write_register_address] <= write_register_data
        end
    end
endmodule
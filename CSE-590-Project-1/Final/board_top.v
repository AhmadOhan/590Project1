`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group 5
// Engineer: Pranav Acharya, Nicole Oszczypala, Abby Angeles
// 
// Create Date: 04/03/2026 08:38:23 PM
// Design Name: 
// Module Name: board_top
// Project Name: CSE 490 Project 1
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module board_top(
    input clk,            // 100MHz system clock 
    input btnC,           // center button to step clock
    input btnU,           // up button to reset, hold up and press center to restart from pc = 0000
    input [0:0] sw,       // toggle LED output
    
    output [15:0] led,    // 16 LEDs above switches
    output [3:0] an,      // 7-segment anodes 
    output [6:0] seg      // 7-segment cathodes 
);

    
    wire [15:0] cpu_pc;
    wire [15:0] cpu_inst;
    wire [15:0] cpu_alu;
    
    
    wire step_clk;

    processor my_cpu (  
        .clock(step_clk),           
        .reset(btnU),             
        .leds(),                  
        .io_pc(cpu_pc),           
        .io_curr_inst(cpu_inst),    
        .io_alu_result(cpu_alu)   
    );

    // If sw[0] is UP, show PC. If DOWN, show ALU out
    assign led = sw[0] ? cpu_pc : cpu_alu;

    //button debouncer to allow one press to always step only one cycle
    
    reg btn_sync_0, btn_sync_1;
    reg [15:0] debounce_counter;
    reg btn_state, btn_prev;
    
    always @(posedge clk) begin
        // synchronize button to 100MHz clock
        btn_sync_0 <= btnC;
        btn_sync_1 <= btn_sync_0;
        btn_prev   <= btn_state;
        
        // debounce counter
        if (btn_sync_1 == btn_state) begin
            debounce_counter <= 0;
        end else begin
            debounce_counter <= debounce_counter + 1;
            if (debounce_counter == 16'hFFFF) begin
                btn_state <= btn_sync_1;
            end
        end
    end
    
    // generate a single pulse that lasts for exactly one 100MHz clock cycle
    assign step_clk = (btn_state == 1'b1) && (btn_prev == 1'b0);

    //7-segment display code
    
    reg [19:0] refresh_counter = 0;
    wire [1:0] digit_sel = refresh_counter[19:18];
    reg [3:0] hex_digit;
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
    // select which of the 4 hex digits from the instruction to display
    always @(*) begin
        case(digit_sel)
            2'b00: hex_digit = cpu_inst[3:0];   // Digit 0 (Rightmost)
            2'b01: hex_digit = cpu_inst[7:4];   // Digit 1
            2'b10: hex_digit = cpu_inst[11:8];  // Digit 2
            2'b11: hex_digit = cpu_inst[15:12]; // Digit 3 (Leftmost)
        endcase
    end
    
    //anode
    assign an = (digit_sel == 2'b00) ? 4'b1110 :
                (digit_sel == 2'b01) ? 4'b1101 :
                (digit_sel == 2'b10) ? 4'b1011 : 4'b0111;
                
    // hex to 7-segment decoder
    reg [6:0] seg_out;
    always @(*) begin
        case(hex_digit)
            4'h0: seg_out = 7'b1000000;
            4'h1: seg_out = 7'b1111001;
            4'h2: seg_out = 7'b0100100;
            4'h3: seg_out = 7'b0110000;
            4'h4: seg_out = 7'b0011001;
            4'h5: seg_out = 7'b0010010;
            4'h6: seg_out = 7'b0000010;
            4'h7: seg_out = 7'b1111000;
            4'h8: seg_out = 7'b0000000;
            4'h9: seg_out = 7'b0010000;
            4'hA: seg_out = 7'b0001000;
            4'hB: seg_out = 7'b0000011;
            4'hC: seg_out = 7'b1000110;
            4'hD: seg_out = 7'b0100001;
            4'hE: seg_out = 7'b0000110;
            4'hF: seg_out = 7'b0001110;
            default: seg_out = 7'b1111111;
        endcase
    end
    assign seg = seg_out;

endmodule

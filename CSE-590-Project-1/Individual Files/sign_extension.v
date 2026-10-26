//Sign Extension
module sign_extension(
    input wire [3:0] inputs,
    output wire [15:0] outputs);
    assign outputs = (inputs[3]) ? {12'hFFF, inputs} : {12'h000, inputs};
endmodule
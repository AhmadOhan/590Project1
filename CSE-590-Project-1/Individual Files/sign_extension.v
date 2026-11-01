module sign_extension(
    input wire [3:0] inputs, //input number
    output wire [15:0] outputs); //output number
    assign outputs = (inputs[3]) ? {12'hFFF, inputs} : {12'h000, inputs}; //sign extension math
endmodule
module subtractor_32bit (
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] result,
    output cout
);
    wire [31:0] b_complement;
    wire [31:0] sum;
    wire carry_out;
    
    assign b_complement = ~b + 1;  // Complemento a dos de b
    assign {carry_out, sum} = a + b_complement + cin;  // Suma con complemento a dos
    
    assign result = sum;
    assign cout = carry_out;
endmodule

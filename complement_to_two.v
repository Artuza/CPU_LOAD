module complement_to_two(
    input [31:0] in,
    output [31:0] out
);
    assign out = ~in + 1;  // Complemento a uno más uno
endmodule

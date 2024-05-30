module rsbs_32bit (
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = b - a;  // Resta de a desde b (reverse subtract)
endmodule

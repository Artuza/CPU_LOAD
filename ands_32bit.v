module ands_32bit(
    input [31:0] a,
    input [31:0] b,
    output [31:0] y
);
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : and_loop
            and_gate ag(a[i], b[i], y[i]);
        end
    endgenerate
endmodule

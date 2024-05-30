module bit_compare(
    input a,
    input b,
    output gt,
    output lt,
    output eq
);
    assign gt = a & ~b;
    assign lt = ~a & b;
    assign eq = ~(a ^ b);
endmodule

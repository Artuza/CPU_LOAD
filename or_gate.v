module or_gate(
    input a,
    input b,
    output y
);
    wire na, nb;

    // Invertir cada entrada usando NAND
    assign na = ~(a & a);
    assign nb = ~(b & b);

    // Implementar OR usando NAND en las entradas invertidas
    assign y = ~(na & nb);
endmodule

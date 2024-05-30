module and_gate(
    input a,
    input b,
    output y
);
    wire nand_ab;  // Salida intermedia

    // Dos NANDs para formar un AND
    assign nand_ab = ~(a & b);  // Primera NAND
    assign y = ~(nand_ab & nand_ab);  // Segunda NAND, negar dos veces produce AND
endmodule

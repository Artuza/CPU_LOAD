module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // XOR para la suma bit a bit
    assign sum = a ^ b ^ cin;
    // AND y OR para calcular el acarreo
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

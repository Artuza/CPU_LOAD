module add_with_carry_32bit(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout
);
    wire [31:0] carry;  // Acarreos intermedios

    // Crear el primer sumador completo (el menos significativo)
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);

    // Encadenar el resto de los sumadores completos
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : adder_loop
            full_adder fa(a[i], b[i], carry[i-1], sum[i], carry[i]);
        end
    endgenerate

    // El acarreo de salida del bit más significativo
    assign cout = carry[31];
endmodule

module add_32bit(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout,
    output NegativeFlag,
    output ZeroFlag
);
    wire [31:0] carry;  // Interconecta los acarreos entre los sumadores

    // Utiliza full_adder para cada bit, propagando el acarreo
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : adder_loop
            if (i == 0) begin
                full_adder fa0(a[i], b[i], cin, sum[i], carry[i]);
            end else if (i < 31) begin
                full_adder fa(a[i], b[i], carry[i-1], sum[i], carry[i]);
            end else begin
                full_adder fa_last(a[i], b[i], carry[i-1], sum[i], cout);
            end
        end
    endgenerate

    // Determinar NegativeFlag y ZeroFlag
    assign NegativeFlag = sum[31]; // El MSB es el bit de signo para números en complemento a dos
    assign ZeroFlag = ~|sum;  // Reduce OR para verificar si todos los bits son cero
endmodule

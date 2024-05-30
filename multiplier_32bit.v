module multiplier_32bit(
    input [31:0] a,
    input [31:0] b,
    output reg [63:0] product
);
    reg [31:0] multiplicand;
    reg [63:0] adder_output;
    integer i;

    always @(a, b) begin
        multiplicand = a;
        product = 0;
        
        for (i = 0; i < 32; i = i + 1) begin
            if (b[i] == 1) begin
                // Extender multiplicand con ceros hacia la izquierda para alinear al desplazamiento correcto
                adder_output = product + (multiplicand << i);
                product = adder_output;
            end
        end
    end
endmodule

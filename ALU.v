module alu(
    input [31:0] a,
    input [31:0] b,
    input cin,
    input [3:0] opcode,  // Código de operación para seleccionar la función
    output reg [31:0] result,
    output reg cout,
    output reg NegativeFlag,
    output reg ZeroFlag
);
    wire [31:0] add_result, and_result, or_result, rsb_result, sub_result;
    wire [63:0] mul_result;
    wire add_cout, sub_cout, mul_cout;
    wire neg, zero;

    // Instancias de los módulos
    add_with_carry_32bit adder(a, b, cin, add_result, add_cout);
    ands_32bit ander(a, b, and_result);
    orrs_32bit orer(a, b, or_result);
    rsbs_32bit rsber(a, b, rsb_result);
    subtractor_32bit subber(a, b, cin, sub_result, sub_cout);
    multiplier_32bit muler(a, b, mul_result);

    // Lógica para seleccionar la operación basada en opcode
    always @(*) begin
        case (opcode)
            4'b0000: begin // ADD
                result = add_result;
                cout = add_cout;
            end
            4'b0001: begin // ADCS
                result = add_result;
                cout = add_cout;
            end
            4'b0010: begin // ANDS
                result = and_result;
            end
            4'b0011: begin // ORRS
                result = or_result;
            end
            4'b0100: begin // RSBS
                result = rsb_result;
            end
            4'b0101: begin // SBCS
                result = sub_result;
                cout = sub_cout;
            end
            4'b0110: begin // SUBS
                result = sub_result;
            end
            4'b0111: begin // CMP
                // CMP generalmente no afecta el resultado pero sí las flags
                result = 0;  // No se usa el resultado
            end
            4'b1000: begin // MULS
                result = mul_result[31:0];  // Solo los bits inferiores
            end
            default: result = 32'hX;
        endcase

        // Flags
        NegativeFlag = result[31];
        ZeroFlag = (result == 0);
    end
endmodule

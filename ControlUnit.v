module ControlUnit (
    input [15:0] instruction,
    output reg [3:0] alu_control,
    output reg reg_write
    // Añadir más señales de control según sea necesario
);
    always @(*) begin
        case (instruction[15:12])
            4'b0000: begin // Ejemplo de instrucción ADD
                alu_control = 4'b0000;
                reg_write = 1;
                // Configurar otras señales de control
            end
            // Otros casos para diferentes instrucciones
            default: begin
                alu_control = 4'b0000;
                reg_write = 0;
                // Configurar otras señales de control
            end
        endcase
    end
endmodule

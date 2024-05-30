module ProgramROM (
    input [31:0] address,
    output reg [31:0] instruction
);
    // Ejemplo de memoria de instrucciones con 16 instrucciones.
    reg [31:0] rom [0:15];
    initial begin
        // Instrucciones precargadas
        rom[0] = 32'h00000001; // Ejemplo de instrucción
        rom[1] = 32'h00000002; // Ejemplo de instrucción
        // Añadir más instrucciones según sea necesario
    end
    
    always @(address) begin
        instruction = rom[address[3:0]];
    end
endmodule

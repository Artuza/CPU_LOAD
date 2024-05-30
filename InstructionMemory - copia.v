module InstructionMemory (
    input [31:0] addr,
    output reg [15:0] instruction
);
    // Definir la memoria de instrucciones
    reg [15:0] memory [0:1023];  // Ejemplo con 1024 instrucciones

    always @(*) begin
        instruction = memory[addr[31:2]];  // Usar 10 bits para indexar la memoria
    end
endmodule

    input clk,
    input mem_write,
    input mem_read,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:1023];  // Ejemplo con 1024 palabras de 32 bits

    always @(posedge clk) begin
        if (mem_write) begin
            memory[addr[31:2]] <= write_data;
        end
    end

    always @(*) begin
        if (mem_read) begin
            read_data = memory[addr[31:2]];
        end else begin
            read_data = 32'b0;
        end
    end
endmodule

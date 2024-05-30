module MCU (
    input clk,
    input reset
);
    // Señales para las etapas del pipeline
    wire [31:0] pc, next_pc, instruction;
    wire [31:0] read_data1, read_data2, alu_result, mem_read_data;
    wire [31:0] write_data, ex_mem_data, mem_wb_data;
    wire [4:0] write_reg;
    
    // Declarar reg_write, mem_read, y mem_write como reg
    reg reg_write, mem_read, mem_write;
    reg [3:0] alu_opcode; // Opcode para la ALU
    
    // Señales para las unidades de reenvío
    wire [4:0] id_ex_reg_rs, id_ex_reg_rt;
    wire [1:0] forward_a, forward_b;
    
    // Instanciar el contador de programa
    ProgramCounter PC (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );
    
    // Instanciar la memoria de instrucciones
    ProgramROM ROM (
        .address(pc),
        .instruction(instruction)
    );
    
    // Instanciar el banco de registros
    RegisterFile RF (
        .clk(clk),
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .write_reg(write_reg),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Instanciar la ALU
    wire [31:0] alu_a, alu_b;
    wire alu_cin = 0; // No carry-in por defecto, esto puede ajustarse según las necesidades
    wire alu_cout, alu_negative, alu_zero;
    
    alu my_alu (
        .a(alu_a),
        .b(alu_b),
        .cin(alu_cin),
        .opcode(alu_opcode),
        .result(alu_result),
        .cout(alu_cout),
        .NegativeFlag(alu_negative),
        .ZeroFlag(alu_zero)
    );

    // Instanciar la memoria de datos
    DataMemory DM (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(ex_mem_read_data2),
        .read_data(mem_read_data)
    );

    // Instanciar la unidad de reenvío
    ForwardingUnit FU (
        .ex_mem_reg_rd(ex_mem_reg_rd),
        .mem_wb_reg_rd(mem_wb_reg_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_reg_write(mem_wb_reg_write),
        .id_ex_reg_rs(id_ex_reg_rs),
        .id_ex_reg_rt(id_ex_reg_rt),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // Definir los registros intermedios entre las etapas del pipeline
    reg [31:0] id_ex_read_data1, id_ex_read_data2;
    reg [31:0] ex_mem_alu_result, ex_mem_read_data2;
    reg ex_mem_reg_write, ex_mem_mem_read, ex_mem_mem_write;
    reg [31:0] mem_wb_alu_result, mem_wb_mem_read_data;
    reg mem_wb_reg_write;

    // Actualizar los registros intermedios en el pipeline (simplificado)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_ex_read_data1 <= 32'b0;
            id_ex_read_data2 <= 32'b0;
            ex_mem_alu_result <= 32'b0;
            ex_mem_read_data2 <= 32'b0;
            ex_mem_reg_write <= 1'b0;
            ex_mem_mem_read <= 1'b0;
            ex_mem_mem_write <= 1'b0;
            mem_wb_alu_result <= 32'b0;
            mem_wb_mem_read_data <= 32'b0;
            mem_wb_reg_write <= 1'b0;
        end else begin
            // Etapa ID/EX
            id_ex_read_data1 <= read_data1;
            id_ex_read_data2 <= read_data2;

            // Etapa EX/MEM
            ex_mem_alu_result <= alu_result;
            ex_mem_read_data2 <= id_ex_read_data2;
            ex_mem_reg_write <= reg_write;
            ex_mem_mem_read <= mem_read;
            ex_mem_mem_write <= mem_write;

            // Etapa MEM/WB
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_mem_read_data <= mem_read_data;
            mem_wb_reg_write <= ex_mem_reg_write;
        end
    end

    // Asignar los datos reenviados
    assign ex_mem_data = ex_mem_alu_result;
    assign mem_wb_data = mem_wb_mem_read_data;

    // Ejemplo de cómo se podrían usar los resultados de la unidad de reenvío
    assign alu_a = (forward_a == 2'b00) ? id_ex_read_data1 :
                   (forward_a == 2'b10) ? ex_mem_data :
                   (forward_a == 2'b01) ? mem_wb_data : 32'b0;
                      
    assign alu_b = (forward_b == 2'b00) ? id_ex_read_data2 :
                   (forward_b == 2'b10) ? ex_mem_data :
                   (forward_b == 2'b01) ? mem_wb_data : 32'b0;
    
    // Otros módulos y conexiones del pipeline
    // ...

    // Señales de control para la instrucción load y set (simplificado)
    always @(*) begin
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        alu_opcode = 4'b0000; // Default opcode to ADD
        // Decodificación simplificada de una instrucción load
        // Asume que el opcode para load es 6'b100011 (LW)
        if (instruction[31:26] == 6'b100011) begin
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_opcode = 4'b0000; // Asume que la ALU hace una suma para LW
        end
        // Decodificación simplificada de una instrucción set
        // Asume que el opcode para set es 6'b001000
        if (instruction[31:26] == 6'b001000) begin
            reg_write = 1'b1;
            mem_read = 1'b0; // No se necesita leer memoria
            mem_write = 1'b0; // No se necesita escribir memoria
            alu_opcode = 4'b0000; // Asume que la ALU hace una suma (no usada en set)
        end
    end

    // Asignar el dato de escritura y el registro de destino para la instrucción set
    // La instrucción set usa un inmediato como dato a escribir
    assign write_data = (instruction[31:26] == 6'b001000) ? instruction[15:0] : mem_wb_data;
    assign write_reg = (instruction[31:26] == 6'b001000) ? instruction[20:16] : instruction[20:16];

endmodule

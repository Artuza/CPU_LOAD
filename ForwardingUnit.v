module ForwardingUnit (
    input [4:0] ex_mem_reg_rd,
    input [4:0] mem_wb_reg_rd,
    input ex_mem_reg_write,
    input mem_wb_reg_write,
    input [4:0] id_ex_reg_rs,
    input [4:0] id_ex_reg_rt,
    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);
    always @(*) begin
        // Inicializar a 00 (ningún reenvío)
        forward_a = 2'b00;
        forward_b = 2'b00;
        
        // ForwardA
        if (ex_mem_reg_write && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs))
            forward_a = 2'b10;
        else if (mem_wb_reg_write && (mem_wb_reg_rd != 0) && (mem_wb_reg_rd == id_ex_reg_rs))
            forward_a = 2'b01;
        
        // ForwardB
        if (ex_mem_reg_write && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rt))
            forward_b = 2'b10;
        else if (mem_wb_reg_write && (mem_wb_reg_rd != 0) && (mem_wb_reg_rd == id_ex_reg_rt))
            forward_b = 2'b01;
    end
endmodule

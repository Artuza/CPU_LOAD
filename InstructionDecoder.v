module InstructionDecoder(
    input [31:0] instruction,
    output reg [3:0] opcode,
    output reg [4:0] rs, rt, rd,
    output reg [15:0] immediate,
    output reg [25:0] jumpAddress
);
    always @(*) begin
        opcode = instruction[31:28];
        rs = instruction[27:23];
        rt = instruction[22:18];
        rd = instruction[17:13];
        immediate = instruction[15:0];
        jumpAddress = instruction[25:0];
    end
endmodule

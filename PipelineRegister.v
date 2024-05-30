module PipelineRegister #(parameter WIDTH = 32) (
    input clk,
    input reset,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 0;
        else
            data_out <= data_in;
    end
endmodule

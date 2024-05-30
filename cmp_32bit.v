module cmp_32bit(
    input [31:0] a,
    input [31:0] b,
    output reg gt,
    output reg lt,
    output reg eq
);
    integer i;
    reg done;

    always @(a or b) begin
        gt = 0;
        lt = 0;
        eq = 1;
        done = 0;

        for (i = 31; i >= 0; i = i - 1) begin
            if (!done) begin
                if (a[i] & ~b[i]) begin
                    gt = 1;
                    lt = 0;
                    eq = 0;
                    done = 1;
                end else if (~a[i] & b[i]) begin
                    gt = 0;
                    lt = 1;
                    eq = 0;
                    done = 1;
                end
            end
        end
    end
endmodule

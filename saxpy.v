`include "defines.v"

module saxpy
(
    input ref_clk,
    input [128-1:0] A_in,
    input A_valid,
    input [128-1:0] B_in,
    input B_valid,
    input [128-1:0] C_in,
    input C_valid,
    output reg [128*4-1:0] out,
    output reg out_valid
);

reg [32-1:0] A [4*4-1:0];
reg [32-1:0] B [4*4-1:0];

reg [1:0] count_A=1'b0;
reg [1:0] count_B=1'b0;

reg ready_A=1'b0;
reg ready_B=1'b0;
reg ready_C=1'b0;

localparam [1:0] alpha = 2'b10;
reg [(32+3+1)-1:0] long_mul [15:0];

integer a,b,c,k,m,i;

always @ (posedge ref_clk) begin
    if(A_valid) begin //&& A_open) begin
        count_A<=count_A+1'b1;
        for(a=0;a<4;a=a+1) begin
            A[count_A*4 + a]<=A_in[32*(a+1)-1 -: 32];
        end
        if(count_A==2'b11) begin
            ready_A<=1'b1;
            count_A<=2'b0;
        end
    end

    if(B_valid) begin //&& B_open) begin
        count_B<=count_B+1'b1;
        for(b=0;b<4;b=b+1) begin
            B[count_B*4 + b]<=B_in[32*(b+1)-1 -: 32];
        end
        if(count_B==2'b11) begin
            ready_B<=1'b1;
            count_B<=2'b0;
        end
    end

    if(ready_A && ready_B) begin
        ready_A<=1'b0;
        ready_B<=1'b0;
        ready_C<=1'b0;
        out_valid<=1'b1;
        for(k=0;k<16;k=k+1) begin
            long_mul[k] <= (alpha * A[k] + B[k]);
        end
        for(i=0;i<16;i=i+1) begin : genOut
            out[32*(i+1)-1 -:32] = long_mul[i][(32+4)-1 -: 4] ? long_mul[i][(32+4)-1 -: 32] : long_mul[i][31:0];
        end
    end
    else begin
        out_valid<=1'b0;
    end
end
endmodule

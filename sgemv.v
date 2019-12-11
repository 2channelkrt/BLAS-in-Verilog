`include "defines.v"

module sgemv
(
    input ref_clk,
    input [128-1:0] A_in,
    input A_valid,
    input [128-1:0] B_in,
    input B_valid,
    input [128-1:0] C_in,
    input C_valid,
    output reg [128-1:0] out,
    output reg out_valid
);

reg [32-1:0] A [3:0][3:0];
reg [32-1:0] B [3:0];
reg [32-1:0] C [3:0];

reg [2:0] count_A=1'b0;

reg ready_A=1'b0;
reg ready_B=1'b0;
reg ready_C=1'b0;

localparam [1:0] alpha=2'b11;
localparam [1:0] beta=2'b10;
reg [32*2-1:0] mid [3:0];
reg [32*2 + 2 -1:0] long_mul [3:0];
integer a,b,c;
integer i, j,k,m;

reg [1:0] temp[3:0];

always @(posedge ref_clk) begin
    if(A_valid) begin
        count_A<=count_A+1'b1;
        for(a=0;a<4;a=a+1) begin
            A[count_A][a]<=A_in[32*(a+1)-1 -: 32];
        end
        if(count_A==2'b11) begin
            ready_A<=1'b1;
            count_A<=2'b00;
        end
    end

    if(B_valid) begin
        for(b=0;b<4;b=b+1) begin
            B[b]<=B_in[32*(b+1)-1 -: 32];
        end
        ready_B<=1'b1;
    end

    if(C_valid) begin
        for(c=0;c<4;c=c+1) begin
            C[c]<=C_in[32*(c+1)-1 -: 32];
        end
        ready_C<=1'b1;
    end


    if(ready_A && ready_B && ready_C) begin
        ready_A<=1'b0;
        ready_B<=1'b0;
        ready_C<=1'b0;
        out_valid<=1'b1;
        for(i=0;i<4;i=i+1) begin
            mid[i]=0;
            for(j=0;j<4;j=j+1) begin
                mid[i]=mid[i]+A[i][j]*B[j];
            end
        end
        for(j=0;j<4;j=j+1) begin
            long_mul[j]=alpha*mid[j]+beta*C[j];
        end
        for(m=0;m<4;m=m+1) begin
            out[32*(m+1)-1 -:32] = long_mul[m][32*2+2-1 -: 32] ? long_mul[m][32*2+2-1 -: 32] : long_mul[m][32+2-1 -: 32] ? long_mul[m][32+2-1 -: 32] : long_mul[m][31:0];
        end
    end
    else begin
        out_valid<=1'b0;
    end
end 
endmodule
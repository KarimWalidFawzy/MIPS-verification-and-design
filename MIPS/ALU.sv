module ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] csig,
    input clk,
    output [31:0] out,
    output z,
    output n,
    output v
    output c);
    reg [31:0] register
    reg overflow;
    always @(posedge clk) begin
        case (csig)
            4'b0000: register<=(a|b);
            4'b0001: register<=(a&b);
            4'b0010: register<=(a^b);
            4'b0011: register<= (a<<b);
            4'b0100: register<=(a>>b);
            4'b0101: begin 
            register<=a-b;
            overflow<=~(((register>0)^(a>0)) | ((a>0)^(b>0)));
            end
            4'b0110: begin 
                register<=a+b;
            overflow<=~(((register>0)^(a>0)) | ((a>0)&(b>0)));
            end
            4'b0111: register<=~(a|b);
            4'b1000: register<=~(a&b);
            4'b1001: register<=((a<b)?32'b1:32'b0);
            4'b1010: register<=(a*b);
            4'b1011:register<=32'b0;
            4'b1100:register<=8'hffffffff;
            4'b1101:register<=(a+(b>>1));
            4'b1110:register<=a&~b;
            4'b1111:register<=~(a^b);
        endcase
    end
    assign v=overflow;
    assign n=(a<b);
    assign c = ((register)<(a+b))&(csig==4'b0111);
    assign z=(a==b);
    assign out=register;
endmodule
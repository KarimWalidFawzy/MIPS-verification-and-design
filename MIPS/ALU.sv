parameter OR = 4'b0000;
parameter AND=4'b0001;
parameter XOR=4'b0010;
parameter SLL=4'b0011;
parameter SRL=4'b0100;
parameter SUB=4'b0101;
parameter ADD=4'b0110;
parameter NOR =4'b0111;
parameter NAND =4'b1000;
parameter SLT=4'b1001;
parameter MUL=4'b1010;
parameter CLR=4'b1011;
parameter STF=4'b1100;
parameter LWSW =4'b1101;
parameter SRA=4'b1110;
parameter ANDN=4'b1111;
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
            OR: register<=(a|b);// or 0 
            AND: register<=(a&b);// and 1
            XOR: register<=(a^b);// xor 
            SLL: register<= (a<<b);// sll
            SRL: register<=(a>>b);//srl
            SUB: begin 
            register<=a-b;//sub
            overflow<=~(((register>0)^(a>0)) | ((a>0)^(b>0)));
            end
            ADD: begin 
                register<=a+b;//add 
            overflow<=~(((register>0)^(a>0)) | ((a>0)&(b>0)));
            end
            NOR: register<=~(a|b);//nor
            NAND: register<=~(a&b);//nand 
            SLT: register<=((a<b)?32'b1:32'b0);//slt 
            MUL: register<=(a*b);//mul
            CLR:register<=32'b0;//clr
            STF:register<=8'hffffffff;//stf
            LWSW:register<=(a+(b>>1));// lw/sw
            /* SRA*/
            SRA:begin 
                if(a<0 && b!=0)
                register<=~((~a)>>b);
                else
                register<=a>>b; 
            end// sra
            ANDN:register<=a&~b;//andn
        endcase
    end
    assign v=overflow;
    assign n=(a<b);
    assign c = ((register)<(a+b))&(csig==4'b0111);
    assign z=(a==b);
    assign out=register;
endmodule

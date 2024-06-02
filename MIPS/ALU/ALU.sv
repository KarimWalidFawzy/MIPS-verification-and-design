module ALU(ALUifc aluintfc);
    reg [31:0] register
    reg overflow;
    always @(posedge aluintfc.clk) begin
        case (aluintfc.csig)
            4'b0000: register<=(aluintfc.a|aluintfc.b);//or 0
            4'b0001: register<=(aluintfc.a&aluintfc.b);//and 1
            4'b0010: register<=(aluintfc.a^aluintfc.b);//xor 2
            4'b0011: register<= (aluintfc.a<<aluintfc.b);//sll 3
            4'b0100: register<=(aluintfc.a>>aluintfc.b);//srl 4 
            4'b0101: begin 
            register<=aluintfc.a-aluintfc.b;//sub
            overflow<=~(((register>0)^(aluintfc.a>0)) | ((aluintfc.a>0)^(aluintfc.b>0)));
            end
            4'b0110: begin 
                register<=aluintfc.a+aluintfc.b;//add
            overflow<=~(((register>0)^(aluintfc.a>0)) | ((aluintfc.a>0)&(aluintfc.b>0)));
            end
            4'b0111: register<=~(aluintfc.a|aluintfc.b); //nor
            4'b1000: register<=~(aluintfc.a&aluintfc.b);//nand
            4'b1001: register<=((aluintfc.a<aluintfc.b)?32'b1:32'b0);//slt
            4'b1010: register<=(aluintfc.a*aluintfc.b);//mul
            4'b1011:register<=32'b0;//clr
            4'b1100:register<=8'hffffffff;//stuff
            4'b1101:register<=(aluintfc.a+(aluintfc.b<<2));//lw/sw
            4'b1110:register<=aluintfc.a&~aluintfc.b;//andn
            4'b1111:register<=~(aluintfc.a^aluintfc.b);//xnor
        endcase
    end
    assign aluintfc.v=overflow;
    assign aluintfc.n=(a<b);
    assign aluintfc.c = ((register)<(aluintfc.a+aluintfc.b))&(aluintfc.csig==4'b0111);
    assign aluintfc.z=(aluintfc.a==aluintfc.b);
    assign aluintfc.out=register;
endmodule
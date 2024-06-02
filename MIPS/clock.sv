module clock(output bit clk);
    initial begin
        always #5 clk=~clk;
    end
endmodule
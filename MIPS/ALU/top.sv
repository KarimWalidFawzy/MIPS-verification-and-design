module top;
    bit clk;
    always #5 clk=~clk;
    ALUifc ifc(clk);
    ALU alu(ifc.dut);
    ALUtb alu_tb(ifc.tb);
    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars;
        #300 $finish;
    end
endmodule
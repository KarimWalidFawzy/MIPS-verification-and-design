interface ALUifc(bit clk);
    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] csig;//Control signal
    logic [31:0] out;
    logic z,c,n,v;
    clocking clck@(posedge clk);
    default input #1ns output #2ns;
    endclocking
    modport  dut(
    input [31:0] a,
    input [31:0] b,
    input [3:0] csig,
    output [31:0] out,
    output z,
    output n,
    output v,
    output c);
    modport tb (output [31:0] a,
    output [31:0] b,
    output [3:0] csig,
    input [31:0] out,
    input z,
    input n,
    input v,
    input c);
endinterface
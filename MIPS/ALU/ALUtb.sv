/*
    What to verify:
    - all operations give out correct results (e.g. 5+6=11) (2)
    - when overflow happens v=1 (1)
    - when result equals zero (a=b) then z=1 (4)
    - prevent illegal scenarios (e.g. bitwise nand(out @stuff)=0 ) (3)
    How to verify: 
    - crt for all op (csig must pass through all)
    - assert for clr & stuff
    - assert for overflow
    Priority:
    //Shown above
    */
    typedef [31:0] bit uint32;
    /*class dynamic_array;
        rand int unsigned abc[];
        constraint{
            abc.size()<20;
            abc.size()>10;
            foreach (abc[i]) 
                abc[i]<30;
        }*/
    class randnumbers;
        rand uint32 a;
        rand uint32 b;
        randc bit [3:0] controlsig;
        constraint {
            controlsig<16;
            controlsig>0;
        }
    endclass
module ALUtb(ALUifc intfc);
    property clr;
        @(posedge clk) ((intfc.csig==4'b1011)|->(intf.out==32'b0));//if-then within same clock cycle
    endproperty
    
    randnumbers r;
    covergroup Covallop;
        CP1:coverpoint r.controlsig;
    endgroup
    initial begin
        Covallop cov;
        cov=new();
        r=new();
        intfc.a<=8'h0fffffff;
        intfc.b<=8'hffffffff;
        intfc.csig<=4'b0110;//Should cause an overflow
        #3
        Overflowassertion: assert(intfc.v==1)
        $display("Overflow bit is %0b",intfc.v);
        else begin
            $error("Overflow is not functioning!");
        end
        #10 
        intfc.csig<=4'b1011;
        #1
        assert(clr)
        $display("Clear signal is functional");
        else begin 
            $error("Clear signal not functional");
        end
        #5
        intfc.a<=4'h00ff;
        intfc.b<=4'h0001;
        intfc.csig<=4'b1011;//add
        //out = ff+1=100
        Addtest: assert (intfc.out==4'h0100)
            $display("a=%d, b=%d,out=%d",intfc.a,intfc.b,intfc.out);
            else $error("Assertion Addtest failed!");     
        for (int i=0; i<10000; ++i) begin
            intfc.csig<=(i%16);
            intfc.a<=$urandom_range(0,8'h0fffffff);
            intfc.b<=$urandom_range(0,8'h0fffffff)-1;
            $display("a= %d, b=%d, out=%d, operation=%x",intfc.a,intfc.b,intfc.out,intfc.csig);
            #5 
        end
        repeat(2) begin
        assert(r.randomize());
        cov.sample();
        @intfc.clk; 
        end
        $display("Coverage= %.2f%%",r.get_coverage());
    end
endmodule 

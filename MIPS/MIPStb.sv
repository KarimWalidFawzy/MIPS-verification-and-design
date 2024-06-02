program MIPStb();
    /*
    code to be written here
    */
    property numofcycles;
        @(posedge clk) (|-> ##[1:4]);// inst of lw ##[1:4]
    endproperty
endprogram
////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (top module)
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO_top ();

//internal signals
    bit clk;

//clock generation
    initial begin
        clk = 0;
        forever begin
            #20;
            clk = ~clk;
        end
    end

//modules instantiation
    FIFO_int FIFOint(clk);                          //interface module
    FIFO_tb FIFOtb(FIFOint);                        //testbench module
    FIFO FIFO(FIFOint);                             //design module
    FIFO_monitor FIFOmonitor(FIFOint);              //monitor module

endmodule
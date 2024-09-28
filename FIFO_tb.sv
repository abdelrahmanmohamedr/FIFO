////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (testbench module)
// 
////////////////////////////////////////////////////////////////////////////////
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard::*;
import shared_pkg::*;

module FIFO_tb (FIFO_int.TB FIFOint);

//internal signals
    int i = 0;

//object decleration
    FIFO_transaction test_bench_FIFO_transaction_object = new();

    initial begin

    //reset drive
        FIFOint.rst_n = 0;

        @(negedge FIFOint.clk);
        #0;

    //driver loop
        for (i =0 ;i<10000 ;i++ ) begin

         //object randomization
            assert(test_bench_FIFO_transaction_object.randomize());               

        //input drive
            FIFOint.data_in = test_bench_FIFO_transaction_object.data_in;
            FIFOint.rst_n = test_bench_FIFO_transaction_object.rst_n;
            FIFOint.wr_en = test_bench_FIFO_transaction_object.wr_en;
            FIFOint.rd_en = test_bench_FIFO_transaction_object.rd_en;

            @(negedge FIFOint.clk);
            #0;

        end
    //assert test_finished signal (to declare the end of the testbench)
        test_finished = 1;
    end

endmodule
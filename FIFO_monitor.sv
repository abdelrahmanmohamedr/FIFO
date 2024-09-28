////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (monitor module)
// 
////////////////////////////////////////////////////////////////////////////////
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import shared_pkg::*;

module FIFO_monitor (FIFO_int.MONITOR FIFOint);

//object decleration
    FIFO_transaction monitor_FIFO_transaction_object = new();
    FIFO_coverage monitor_FIFO_coverage_object = new();
    FIFO_scoreboard monitor_FIFO_scoreboard_object = new();
    
    initial begin

        forever begin

            @(negedge FIFOint.clk);
            
        //signals drive
            monitor_FIFO_transaction_object.data_in = FIFOint.data_in;
            monitor_FIFO_transaction_object.rst_n = FIFOint.rst_n;
            monitor_FIFO_transaction_object.wr_en = FIFOint.wr_en;
            monitor_FIFO_transaction_object.rd_en = FIFOint.rd_en;
            monitor_FIFO_transaction_object.data_out = FIFOint.data_out;
            monitor_FIFO_transaction_object.wr_ack = FIFOint.wr_ack;
            monitor_FIFO_transaction_object.overflow = FIFOint.overflow;
            monitor_FIFO_transaction_object.full = FIFOint.full;
            monitor_FIFO_transaction_object.empty = FIFOint.empty;
            monitor_FIFO_transaction_object.almostfull = FIFOint.almostfull;
            monitor_FIFO_transaction_object.almostempty = FIFOint.almostempty;
            monitor_FIFO_transaction_object.underflow = FIFOint.underflow;

            fork
                begin
                    //sample function
                        monitor_FIFO_coverage_object.sample_data(monitor_FIFO_transaction_object);
                end

                begin
                    //check function
                        monitor_FIFO_scoreboard_object.check_data(monitor_FIFO_transaction_object);
                end
            join

    //ending simulation
        if (test_finished == 1) begin
            
            //display correct and error count cases
                $display("correct count = %0d error count = %0d",correct_count,error_count);
                
                $stop;
        end
        
        end
    end
endmodule
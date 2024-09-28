////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (coverage package)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_coverage_pkg;

import FIFO_transaction_pkg::*;

    class FIFO_coverage;

    //Object decleration
        FIFO_transaction F_cvg_txn = new();

    //covergroup
        covergroup write;

        write_enable:                       coverpoint F_cvg_txn.wr_en{option.weight=0;}                                  //wr_en signal coverage
        overflow:                           coverpoint F_cvg_txn.overflow{option.weight=0;}                               //overflow signal coverage
        full:                               coverpoint F_cvg_txn.full{option.weight=0;}                                   //full signal coverage
        almostfull:                         coverpoint F_cvg_txn.almostfull{option.weight=0;}                             //almostfull signal coverage
        empty:                              coverpoint F_cvg_txn.empty{option.weight=0;}                                  //empty signal coverage
        almostempty:                        coverpoint F_cvg_txn.almostempty{option.weight=0;}                            //almostempty signal coverage
        underflow:                          coverpoint F_cvg_txn.underflow{option.weight=0;}                              //underflow signal coverage
        write_ack:                          coverpoint F_cvg_txn.wr_ack{option.weight=0;}                                 //wr_ack signal coverage

        write_enable_full_bins:             cross write_enable , full;                      //cross coverage between wr_en and full signals
        write_enable_almost_full_bins:      cross write_enable , almostfull;                //cross coverage between wr_en and almost full signals
        write_enable_empty_bins:            cross write_enable , empty;                     //cross coverage between wr_en and empty signals
        write_enable_almost_empty_bins:     cross write_enable , almostempty;               //cross coverage between wr_en and almost empty signals
        write_enable_ovarflow_bins:         cross write_enable , overflow {                 //cross coverage between wr_en and overflow signals
        ignore_bins writeenable0_overflow1 = binsof(write_enable) intersect {0} && binsof(overflow) intersect {1};
        }
        write_enable_underflow_bins:        cross write_enable , underflow;                 //cross coverage between wr_en and underflow signals
        write_enable_write_ack_bins:        cross write_enable , write_ack{                 //cross coverage between wr_en and wr_ack signals
        ignore_bins writeenable0_write_ack1 = binsof(write_enable) intersect {0} && binsof(write_ack) intersect {1};
        }

        endgroup //write enable covergroup

        covergroup read;

        read_enable:                        coverpoint F_cvg_txn.rd_en{option.weight=0;}                                  //rd_en signal coverage
        overflow:                           coverpoint F_cvg_txn.overflow{option.weight=0;}                               //overflow signal coverage
        full:                               coverpoint F_cvg_txn.full{option.weight=0;}                                   //full signal coverage
        almostfull:                         coverpoint F_cvg_txn.almostfull{option.weight=0;}                             //almostfull signal coverage
        empty:                              coverpoint F_cvg_txn.empty{option.weight=0;}                                  //empty signal coverage
        almostempty:                        coverpoint F_cvg_txn.almostempty{option.weight=0;}                            //almostempty signal coverage
        underflow:                          coverpoint F_cvg_txn.underflow{option.weight=0;}                              //underflow signal coverage
        write_ack:                          coverpoint F_cvg_txn.wr_ack{option.weight=0;}                                 //wr_ack signal coverage

        read_enable_full_bins:             cross read_enable , full{                      //cross coverage between rd_en and full signals
        ignore_bins readenable1_full1 = binsof(read_enable) intersect {1} && binsof(full) intersect {1};
        }
        read_enable_almost_full_bins:      cross read_enable , almostfull;                //cross coverage between rd_en and almost full signals
        read_enable_empty_bins:            cross read_enable , empty;                     //cross coverage between rd_en and empty signals
        read_enable_almost_empty_bins:     cross read_enable , almostempty;               //cross coverage between rd_en and almost empty signals
        read_enable_ovarflow_bins:         cross read_enable , overflow;                  //cross coverage between rd_en and overflow signals
        read_enable_underflow_bins:        cross read_enable , underflow{                 //cross coverage between rd_en and underflow signals
        ignore_bins readenable0_underflow1 = binsof(read_enable) intersect {0} && binsof(underflow) intersect {1};
        }
        read_enable_write_ack_bins:        cross read_enable , write_ack;                 //cross coverage between rd_en and wr_ack signals

        endgroup //write enable covergroup

        function new();
            write = new();
            read = new();
        endfunction

        //sample functiom
        function void sample_data (input FIFO_transaction F_txn);

            this.F_cvg_txn = F_txn;  //assigning F_txn to F_cvg_txn
            this.write.sample();     //sampling write covergroup
            this.read.sample();      //sampling read covergroup

        endfunction //sample_data function     

    endclass //FIFO_coverage

endpackage //FIFO_coverage_pkg
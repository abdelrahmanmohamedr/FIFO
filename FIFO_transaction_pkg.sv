////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (Transaction package)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_transaction_pkg;

    class FIFO_transaction;

//parameters
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    //internal signals
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

    //constructor function
        function new(input int WR_EN_ON_DIST_int = 70 , RD_EN_ON_DIST_int = 30);
            WR_EN_ON_DIST = WR_EN_ON_DIST_int;
            RD_EN_ON_DIST = RD_EN_ON_DIST_int;
        endfunction //new()

    //constraints
        constraint c{

            rst_n dist {0:/10 , 1:/90};                                 //reset is off 10% and on 90%
            wr_en dist {0:/(100-WR_EN_ON_DIST) , 1:/WR_EN_ON_DIST};     //write enable is on with the percantage of WR_EN_ON_DIST signal and off with 100-WR_EN_ON_DIST
            rd_en dist {0:/(100-RD_EN_ON_DIST) , 1:/RD_EN_ON_DIST};     //write enable is on with the percantage of RD_EN_ON_DIST signal and off with 100-RD_EN_ON_DIST
            
        } //constraint c

    endclass //FIFO_transaction

endpackage //FIFO_transaction_pkg
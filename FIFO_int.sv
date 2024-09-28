////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (interface module)
// 
////////////////////////////////////////////////////////////////////////////////
interface FIFO_int (clk);

//parameters
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

//input/output signals
    input bit clk;

//internal signals
    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

//modports
    modport TB (
    input clk, data_out ,wr_ack, overflow, full, empty, almostfull, almostempty, underflow,
    output data_in, rst_n, wr_en, rd_en
    );//testbench modport

    modport DUT (
    input data_in, rst_n, wr_en, rd_en,clk,
    output data_out ,wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );//design modport

    modport MONITOR (
    input data_in, rst_n, wr_en, rd_en,clk, data_out ,wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );//monitor modport
       
endinterface //FIFO design interface
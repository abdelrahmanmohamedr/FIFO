////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (scoreboard package)
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_scoreboard_pkg;
    
import FIFO_transaction_pkg::*;
import shared_pkg::*;

class FIFO_scoreboard;
  
//parameters
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

//internal signals
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
    logic [max_fifo_addr-1:0] wr_ptr, rd_ptr; 
    logic [max_fifo_addr:0] count;

    function void reference_model (FIFO_transaction golden_ref_object);
        
    //write if-condition
	    if (!golden_ref_object.rst_n) begin
	    	wr_ptr = 0;
            overflow_ref = 0;
            wr_ack_ref = 0;
	    end
	    else if (golden_ref_object.wr_en && !full_ref) begin
	    	mem[wr_ptr] = golden_ref_object.data_in;
	    	wr_ack_ref = 1;
	    	wr_ptr = wr_ptr + 1;
            overflow_ref = 0;
	    end
	    else begin 
	    	wr_ack_ref = 0; 
	    	if (full_ref && golden_ref_object.wr_en)
	    		overflow_ref = 1;
	    	else
	    		overflow_ref = 0;
	    end


    //read if-condition
	    if (!golden_ref_object.rst_n) begin
	    	rd_ptr = 0;
            underflow_ref = 0;
	    end
	    else if (golden_ref_object.rd_en && !empty_ref) begin
	    	data_out_ref = mem[rd_ptr];
	    	rd_ptr = rd_ptr + 1;
            underflow_ref = 0;
        end else begin
            if (empty_ref && golden_ref_object.rd_en) begin
                underflow_ref = 1;
            end else begin
                underflow_ref = 0;
            end
        end

    //count if-condition
	    if (!golden_ref_object.rst_n) begin
	    	count = 0;
	    end
	    else begin
            if (golden_ref_object.wr_en && golden_ref_object.rd_en && !full_ref && !empty_ref) 
                count <= count; 
            else if	(golden_ref_object.wr_en && !full_ref)
	    		count = count + 1;
	    	else if (golden_ref_object.rd_en && !empty_ref)
	    		count = count - 1;
	    end

    //FIFO-state decleration
        full_ref =(count == golden_ref_object.FIFO_DEPTH)? 1 : 0;
        empty_ref =(count == 0)? 1 : 0;
        almostfull_ref =(count == golden_ref_object.FIFO_DEPTH-1)? 1 : 0; 
        almostempty_ref =(count == 1)? 1 : 0;
        
    endfunction //golden refrence function

    function void check_data (FIFO_transaction check_data_object);
        
        reference_model(check_data_object);

    //check if-condition
        if ((data_out_ref === check_data_object.data_out) && (wr_ack_ref === check_data_object.wr_ack) && 
        (overflow_ref === check_data_object.overflow) && (full_ref === check_data_object.full) && (empty_ref === check_data_object.empty) && 
        (almostfull_ref === check_data_object.almostfull) && (almostempty_ref === check_data_object.almostempty) && (underflow_ref === check_data_object.underflow)) begin
            
            correct_count++;
            $display("right = %0d , error = %0d ,time = %0t" ,correct_count ,error_count , $time);

           /*$display("data_out_ref = %0d ,check_data_object.data_out = %0d,
            wr_ack_ref = %0d ,check_data_object.wr_ack = %0d ,
            overflow_ref = %0d ,check_data_object.overflow = %0d ,
            full_ref = %0d ,check_data_object.full = %0d ,
            empty_ref = %0d ,check_data_object.empty = %0d ,
            almostfull_ref = %0d ,check_data_object.almostfull = %0d ,
            almostempty_ref = %0d ,check_data_object.almostempty = %0d ,
            underflow_ref = %0d ,check_data_object.underflow = %0d ,
            ",data_out_ref,check_data_object.data_out,
            wr_ack_ref,check_data_object.wr_ack,
            overflow_ref,check_data_object.overflow,
            full_ref,check_data_object.full,
            empty_ref,check_data_object.empty,
            almostfull_ref,check_data_object.almostfull,
            almostempty_ref,check_data_object.almostempty,
            underflow_ref,check_data_object.underflow);*/

        end else begin
            error_count++;
            $display("right = %0d , error = %0d ,time = %0t" ,correct_count ,error_count , $time);

           /*$display("data_out_ref = %0d ,check_data_object.data_out = %0d,
            wr_ack_ref = %0d ,check_data_object.wr_ack = %0d ,
            overflow_ref = %0d ,check_data_object.overflow = %0d ,
            full_ref = %0d ,check_data_object.full = %0d ,
            empty_ref = %0d ,check_data_object.empty = %0d ,
            almostfull_ref = %0d ,check_data_object.almostfull = %0d ,
            almostempty_ref = %0d ,check_data_object.almostempty = %0d ,
            underflow_ref = %0d ,check_data_object.underflow = %0d ,
            ",data_out_ref,check_data_object.data_out,
            wr_ack_ref,check_data_object.wr_ack,
            overflow_ref,check_data_object.overflow,
            full_ref,check_data_object.full,
            empty_ref,check_data_object.empty,
            almostfull_ref,check_data_object.almostfull,
            almostempty_ref,check_data_object.almostempty,
            underflow_ref,check_data_object.underflow);*/
        end
        
    endfunction //check data function


endclass //className

endpackage
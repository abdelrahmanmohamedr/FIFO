////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_int.DUT FIFOint);
 
localparam max_fifo_addr = $clog2(FIFOint.FIFO_DEPTH);

reg [FIFOint.FIFO_WIDTH-1:0] mem [FIFOint.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFOint.clk or negedge FIFOint.rst_n) begin
	if (!FIFOint.rst_n) begin
		wr_ptr <= 0;
		FIFOint.overflow <= 0;
		FIFOint.wr_ack <= 0;
	end
	else if (FIFOint.wr_en && count < FIFOint.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFOint.data_in;
		FIFOint.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		FIFOint.overflow <= 0;
	end
	else begin 
		FIFOint.wr_ack <= 0; 
		if (FIFOint.full & FIFOint.wr_en)
			FIFOint.overflow <= 1;
		else
			FIFOint.overflow <= 0;
	end
end

always @(posedge FIFOint.clk or negedge FIFOint.rst_n) begin
	if (!FIFOint.rst_n) begin
		rd_ptr <= 0;
		FIFOint.underflow <= 0;
	end
	else if (FIFOint.rd_en && count != 0) begin
		FIFOint.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFOint.underflow <= 0;
	end else begin
            if (FIFOint.empty && FIFOint.rd_en) begin
                FIFOint.underflow <= 1;
            end else begin
                FIFOint.underflow <= 0;
            end
        end
end

always @(posedge FIFOint.clk or negedge FIFOint.rst_n) begin
	if (!FIFOint.rst_n) begin
		count <= 0;
	end
	else begin
		if (FIFOint.wr_en && FIFOint.rd_en && !FIFOint.full && !FIFOint.empty) 
                count <= count; 
            else if	(FIFOint.wr_en && !FIFOint.full)
	    		count = count + 1;
	    	else if (FIFOint.rd_en && !FIFOint.empty)
	    		count = count - 1;
	end
end

assign FIFOint.full = (count == FIFOint.FIFO_DEPTH)? 1 : 0;
assign FIFOint.empty = (count == 0)? 1 : 0;
assign FIFOint.almostfull = (count == FIFOint.FIFO_DEPTH-1)? 1 : 0; 
assign FIFOint.almostempty = (count == 1)? 1 : 0;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Course: Digital Verification using SV & UVM (by eng.Kareem Waseem)
//
// Description: FIFO Design (FIFO module (assertions))
// 
////////////////////////////////////////////////////////////////////////////////

//assertions
always_comb begin
	if (!FIFOint.rst_n) begin
		reseta: assert final((!wr_ptr) && (!rd_ptr) && (!count));																																							//reset assertion
	end
end

always_comb begin
	fulla: assert final(FIFOint.full == (count == FIFOint.FIFO_DEPTH)? 1 : 0);																																				//full assertion
	almostfulla: assert final(FIFOint.almostfull == (count == FIFOint.FIFO_DEPTH-1)? 1 : 0);																																//almostfull assertion
	emptya: assert final(FIFOint.empty == (count == 0)? 1 : 0);																																								//emprt assertion
	almostemptya: assert final(FIFOint.almostempty == (count == 1)? 1 : 0);																																					//almostempty assertion
end

property overflowa;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.full) && $past(FIFOint.wr_en) && $past(FIFOint.rst_n)) |-> FIFOint.overflow																			//overflow property
endproperty

property underflowa;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.empty) && $past(FIFOint.rd_en) && $past(FIFOint.rst_n)) |-> FIFOint.underflow																		//underflow property
endproperty

property wr_acka;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && $past(count) < FIFOint.FIFO_DEPTH && $past(FIFOint.rst_n)) |-> (FIFOint.wr_ack)															//wr_ack property
endproperty

property wr_ptra;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && $past(count) < FIFOint.FIFO_DEPTH && $past(FIFOint.rst_n)) |-> (wr_ptr == $past(wr_ptr) + 1'b1)											//wr_ptr property
endproperty

property rd_prta;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.rd_en) && $past(count) != 0 && $past(FIFOint.rst_n)) |-> rd_ptr == $past(rd_ptr) + 1'b1																//rd_ptr property
endproperty

property count_constant;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && !$past(FIFOint.full) && $past(FIFOint.rd_en) && !$past(FIFOint.empty) && $past(FIFOint.rst_n)) |-> count == $past(count) + 1'b1			//count_increment property
endproperty

property count_incrementa;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) ($past(FIFOint.wr_en) && !$past(FIFOint.full) && !$past(FIFOint.rd_en) && $past(FIFOint.rst_n)) |-> count == $past(count) + 1'b1									//count_increment property
endproperty

property count_decrementa;
	@(posedge FIFOint.clk) disable iff (!FIFOint.rst_n) (!$past(FIFOint.wr_en) && $past(FIFOint.rd_en) && !$past(FIFOint.empty) && $past(FIFOint.rst_n)) |-> count == $past(count) - 1'b1									//count_decrement property
endproperty

assert property (overflowa);				//overflow property assertion
cover property  (overflowa);				//overflow property cover

assert property (underflowa);				//underflow property assertion
cover property  (underflowa);				//underflow property cover

assert property (wr_acka);					//wr_ack property assertion
cover property  (wr_acka);					//wr_ack property cover

assert property (wr_ptra);					//wr_ptr property assertion
cover property  (wr_ptra);					//wr_ptr property cover

assert property (rd_prta);					//rd_ptr property assertion
cover property  (rd_prta);					//rd_ptr property cover

assert property (count_incrementa);			//count_increment property assertion	
cover property  (count_incrementa);			//count_increment property cover

assert property (count_decrementa);			//count_decrement property assertion
cover property  (count_decrementa);			//count_decrement property cover

endmodule
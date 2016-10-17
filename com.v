
`define		UD		#1

module	com
(
    clk,
    rst,
    
    clk_out1,
    clk_out2,
    clk_out3,
    
    tx1_in,
    tx1_out,
    
    rx1_in,
    rx1_out,
    
    tx2_in,
    tx2_out,
    
    rx2_in,
    rx2_out,
    
    dir_in,
    dir_out,
    
    can1_tx_in,
    can1_tx_out,
    
    can1_rx_in,
    can1_rx_out,
    
    can2_tx_in,
    can2_tx_out,
    
    can2_rx_in,
    can2_rx_out,
    
    dout,    
    cled,
	 
	 cled_in
    
);

input			clk;
input			rst;

output			clk_out1;
output			clk_out2;
output			clk_out3;

input			tx1_in;
input			tx2_in;
input			rx1_in;
input			rx2_in;
input			can1_tx_in;
input			can1_rx_in;
input			can2_tx_in;
input			can2_rx_in;
input			dir_in;

output			tx1_out;
output			tx2_out;
output			rx1_out;
output			rx2_out;
output			can1_tx_out;
output			can1_rx_out;
output			can2_tx_out;
output			can2_rx_out;
output			dir_out;

output	[5:0]	dout;
output	[5:0]	cled;

input		[5:0]	cled_in;

reg    	[1:0]    	cnt;
wire				clk_out1;
wire				clk_out2;
wire				clk_out3;

reg		[5:0]	dout;
wire		[5:0]	cled;

always @ (posedge clk)
begin
    cnt <= `UD cnt + 1'b1;
end

assign	clk_out1 = cnt[1];
assign	clk_out2 = cnt[1];
assign	clk_out3 = cnt[1];


always @ (posedge clk or negedge rst)
begin
	if(!rst)
	begin
		dout 	<= `UD 6'b111111;
	end
	else
	begin
		dout		<= `UD 6'd0;
	end
end

assign	cled = cled_in;

assign	tx1_out = tx1_in;
assign	tx2_out = tx2_in;
assign	rx1_out = rx1_in;
assign	rx2_out = rx2_in;

assign	dir_out = dir_in;

assign	can1_tx_out = can1_tx_in;
assign	can1_rx_out = can1_rx_in;

assign	can2_tx_out = can2_tx_in;
assign	can2_rx_out = can2_rx_in;
    
endmodule
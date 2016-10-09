`define		UD		#1
module	signal_filter
(
	clk,
	rst,
	
	sig_in,
	sig_out
);
	
input		clk;
input		rst;
input		sig_in;
output		sig_out;

reg		[9:0]	filter_timer;
reg		[9:0]	filter_timer_n;

always @ (posedge clk or negedge rst)
begin

end

endmodule
	

`define		UD		#1

module	signal_filter
(
	clk,
	rst,
	
	sin,
	sout,
	timer_600n		// 600ns
);

input			clk;
input			rst;
input			sin;
input	[7:0]		timer_600n;
output			sout;

reg		[7:0]	cc;
reg		[7:0]	cc_n;
reg		[1:0]	sin_edge;
reg		[1:0]	last_edge;
reg		[1:0]	last_edge_n;
reg			sout;
reg			sout_n;

parameter		FILTER_TIME	= 8'd200;		// 200 * 0.6us = 120us

/*     input signal edge and store current edge */
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		sin_edge <= `UD 2'b00;
	else
		sin_edge <= `UD { sin_edge[0], sin };
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		last_edge <= `UD 2'b00;
	else
		last_edge <= `UD last_edge_n;
end

always @ (*)
begin
	if(sin_edge == 2'b01)
		last_edge_n = 2'b01;
	else if(sin_edge == 2'b10)
		last_edge_n = 2'b10;
	else
		last_edge_n = last_edge;
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		cc <= `UD 8'd0;
	else
		cc <= `UD cc_n;
end

always @ (*)
begin
	if(sin_edge == 2'b01 || sin_edge == 2'b10)
		cc_n = timer_600n + FILTER_TIME;
	else
		cc_n = cc;
end

/************** output signal ctrl *************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		sout <= `UD 1'b0;
	else
		sout <= `UD sout_n;
end

always @ (*)
begin
	if(timer_600n == cc)
	begin
		if(last_edge == 2'b01)
			sout_n = 1'b1;
		else if(last_edge == 2'b10)
			sout_n = 1'b0;
		else
			sout_n = sout;
	end
	else
		sout_n = sout;
end

endmodule
	

`define		UD		#1

module	opm_start
(
	clk,
	rst,
	
	start,
	
	so,
	timer
);

input			clk;
input			rst;
input			start;
input	[7:0]	timer;		// 0.6us resolution;
output			so;

reg		[7:0]	cc;
reg		[7:0]	cc_n;
reg		[1:0]	start_edge;
reg				so;
reg				so_n;

parameter	START_PULS_TIME = 8'd100;		// 100 * 0.6us == 60us;

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		start_edge <= `UD 2'b00;
	else
		start_edge <= `UD { start_edge[0], start };
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
	if(start_edge == 2'b01)
		cc_n = timer + START_PULS_TIME;
	else
		cc_n = cc;
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		so <= `UD 1'b1;
	else
		so <= `UD so_n;
end

always @ (*)
begin
	if(start_edge == 2'b01)
		so_n = 1'b0;
	else if(timer == cc)
		so_n = 1'b1;
	else
		ena_n = ena;
end

endmodule

`define		UD		#1
`timescale	1ns/100ps

// because 

module	opm
(
	clk,
	rst,
	
	ctrl,
	
	sig_in,
	timer_val,		// this timer base could be configuration.
	delay_time,

	hv_out,
	lv_out
);

input			clk;
input			rst;
input	[7:0]	ctrl;
input			sig_in;
input	[15:0]	timer_val;
input	[15:0]	delay_time;

output			hv_out;
output			lv_out;

reg				hv_out;
reg				lv_out;

reg		[1:0]	sig_edge;
reg		[15:0]	cc;
reg		[11:0]	tt;
reg		[11:0]	tt_n;
reg		[3:0]	sm_cs;
reg		[3:0]	sm_ns;

parameter		SM_INIT 							= 4'd0;
parameter		SM_WAIT_UNTIL_HV_TIMER_REACH	= 4'd1;
parameter		SM_HV_TRIG_START				= 4'd2;
parameter		SM_HV_TRIG_END					= 4'd3;
parameter		SM_WAIT_UNTIL_LV_TIMER_REACH	= 4'd4;
parameter		SM_LV_TRIG_START				= 4'd5;
parameter		SM_LV_TRIG_END					= 4'd6;

parameter		TIME_60US						= 12'd2400;

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		sig_edge <= `UD 2'b00;
	else
		sig_edge <= `UD { sig_edge[0], sig_in };
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		sm_cs <= `UD SM_INIT;
	else
		sm_cs <= `UD sm_ns;
end

always @ (*)
begin
	case(sm_cs)
	
	SM_INIT:
	begin
		if(ctrl[0] == 1'b0)
			sm_ns = sm_cs;
		else if(sig_edge == 2'b01)
			sm_ns = SM_WAIT_UNTIL_HV_TIMER_REACH;
		else
			sm_ns = sm_cs;
	end
	
	SM_WAIT_UNTIL_HV_TIMER_REACH:
	begin
		if(ctrl[0] == 1'b0)
			sm_ns = SM_INIT;
		else if(cc == timer_val)
			sm_ns = SM_HV_TRIG_START;
		else
			sm_ns = sm_cs;
	end
	
	SM_HV_TRIG_START:
	begin
		if(ctrl[0] == 1'b0)
			sm_ns = SM_INIT;
		else if(tt == TIME_60US)
			sm_ns = SM_HV_TRIG_END;
		else
			sm_ns = sm_cs;
	end
	
	SM_HV_TRIG_END:
	begin
		if(ctrl[0] == 1'b0)
			sm_ns = SM_INIT;
		else if(sig_edge == 2'b10)
			sm_ns = SM_WAIT_UNTIL_LV_TIMER_REACH;
		else
			sm_ns = sm_cs;
	end
	
	SM_WAIT_UNTIL_LV_TIMER_REACH:
	begin
		if(ctrl[0] == 1'b0)
			sm_ns = SM_INIT;
		else if(cc == timer_val)
			sm_ns = SM_LV_TRIG_START;
		else
			sm_ns = sm_cs;
	end
	
	SM_LV_TRIG_START:
	begin
		if(ctrl[0] == 1'b0)
			sm_ns = SM_INIT;
		else if(tt == TIME_60US)
			sm_ns = SM_LV_TRIG_END;
		else
			sm_ns = sm_cs;
	end
	
	SM_LV_TRIG_END:
	begin
		if(ctrl[0] == 1'b0)
			sm_ns = SM_INIT;
		else if(sig_edge == 2'b01)
			sm_ns = SM_WAIT_UNTIL_HV_TIMER_REACH;
		else
			sm_ns = sm_cs;
	end
	
	default:	sm_ns = sm_cs;
	endcase
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		cc <= `UD 16'd0;
	else
	begin
		if(ctrl[0] == 1'b0)
			cc <= `UD 16'd0;
		else if( sig_edge == 2'b01 || sig_edge == 2'b10 )
			cc <= `UD timer_val + delay_time;
		else
			cc <= `UD cc;
	end
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		tt <= `UD 12'd0;
	else
		tt <= `UD tt_n;
end

always @ (*)
begin
	if(	sm_cs == SM_HV_TRIG_START ||
		sm_cs == SM_LV_TRIG_START	)
		tt_n = tt + 1'b1;
	else
		tt_n = 12'd0;	
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		hv_out <= `UD 1'b1;
	else
	begin
		if(sm_cs == SM_HV_TRIG_START)
			hv_out <= `UD 1'b0;
		else
			hv_out <= `UD 1'b1;
	end
end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
		lv_out <= `UD 1'b1;
	else
	begin
		if(sm_cs == SM_LV_TRIG_START)
			lv_out <= `UD 1'b0;
		else
			lv_out <= `UD 1'b1;
	end
end

endmodule

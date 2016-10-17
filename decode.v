`define		UD		#1

module	decode
(
	clk,
	rst,
	
	data_in,
	data_out,
	
	reg_digit_1,
	reg_digit_2,
	reg_digit_3,
	reg_digit_4,
	
	ref_delay_y,
	ref_delay_d,
	ref_ctrl,
	
	data_ok
);

input			clk;
input			rst;
input	[7:0]	data_in;
input			data_ok;

output	[7:0]	data_out;
output	[7:0]	reg_digit_1;
output	[7:0]	reg_digit_2;
output	[7:0]	reg_digit_3;
output	[7:0]	reg_digit_4;
output	[7:0]	ref_delay_d;
output	[7:0]	ref_delay_y;
output	[7:0]	ref_ctrl;

reg		[7:0]	reg_digit_1;
reg		[7:0]	reg_digit_2;
reg		[7:0]	reg_digit_3;
reg		[7:0]	reg_digit_4;
reg		[7:0]	ref_delay_d;
reg		[7:0]	ref_delay_y;
reg		[7:0]	ref_ctrl;

reg		[7:0]	reg_digit_1_n;
reg		[7:0]	reg_digit_2_n;
reg		[7:0]	reg_digit_3_n;
reg		[7:0]	reg_digit_4_n;
reg		[7:0]	ref_delay_d_n;
reg		[7:0]	ref_delay_y_n;
reg		[7:0]	ref_ctrl_n;

reg		[7:0]	addr;
reg		[7:0]	addr_n;

reg		[7:0]	data_out;
reg		[7:0]	data_out_n;

reg		[1:0]	sm_cs;
reg		[1:0]	sm_ns;

reg		[1:0]	data_ok_edge;

reg				mode;
reg				mode_n;

parameter	SM_ADDR			= 2'b00;
parameter	SM_DATA0		= 2'b01;
parameter	SM_DATA1		= 2'b10;

parameter	ADDR_DIGIT_12	= 8'h00;
parameter	ADDR_DIGIT_34	= 8'h01;
parameter	ADDR_FREQ		= 8'h02;
parameter	ADDR_REF_DELAY	= 8'h03;
parameter	ADDR_REF_CTRL	= 8'h04;

parameter	READ_MODE		= 1'b1;
parameter	WRITE_MODE		= 1'b0;

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		data_ok_edge <= `UD 2'b00;
	else
		data_ok_edge <= `UD { data_ok_edge [0], data_ok };
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		sm_cs <= `UD SM_ADDR;
	else
		sm_cs <= `UD sm_ns;
end

always @ (*)
begin
	if(data_ok_edge == 2'b10)
		if(sm_cs == SM_DATA1)
			sm_ns = SM_ADDR;
		else
			sm_ns = sm_cs + 1'b1;
	else
		sm_ns = sm_cs;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		addr <= `UD 8'd0;
	else
		addr <= `UD addr_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_ADDR)
		addr_n = {1'b0, data_in[6:0] };
	else
		addr_n = addr;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		mode <= `UD WRITE_MODE;
	else
		mode <= `UD mode_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_ADDR)
		mode_n = data_in[7];
	else
		mode_n = mode;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		reg_digit_1 <= `UD 8'd0;
	else
		reg_digit_1 <= `UD reg_digit_1_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_DATA0 && addr == ADDR_DIGIT_12 && mode == WRITE_MODE)
		reg_digit_1_n = data_in;
	else
		reg_digit_1_n = reg_digit_1;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		reg_digit_2 <= `UD 8'd0;
	else
		reg_digit_2 <= `UD reg_digit_2_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_DATA1 && addr == ADDR_DIGIT_12 && mode == WRITE_MODE)
		reg_digit_2_n = data_in;
	else
		reg_digit_2_n = reg_digit_2;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		reg_digit_3 <= `UD 8'd0;
	else
		reg_digit_3 <= `UD reg_digit_3_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_DATA0 && addr == ADDR_DIGIT_34 && mode == WRITE_MODE)
		reg_digit_3_n = data_in;
	else
		reg_digit_3_n = reg_digit_3;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		reg_digit_4 <= `UD 8'd0;
	else
		reg_digit_4 <= `UD reg_digit_4_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_DATA1 && addr == ADDR_DIGIT_34 && mode == WRITE_MODE)
		reg_digit_4_n = data_in;
	else
		reg_digit_4_n = reg_digit_4;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		ref_delay_d <= `UD 8'd0;
	else
		ref_delay_d <= `UD ref_delay_d_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_DATA0 && addr == ADDR_REF_DELAY && mode == WRITE_MODE)
		ref_delay_d_n = data_in;
	else
		ref_delay_d_n = ref_delay_d;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		ref_delay_y <= `UD 8'd0;
	else
		ref_delay_y <= `UD ref_delay_y_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_DATA1 && addr == ADDR_REF_DELAY && mode == WRITE_MODE)
		ref_delay_y_n = data_in;
	else
		ref_delay_y_n = ref_delay_y;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		ref_ctrl <= `UD 8'd0;
	else
		ref_ctrl <= `UD ref_ctrl_n;
end

always @ (*)
begin
	if(data_ok_edge == 2'b01 && sm_cs == SM_DATA0 && addr == ADDR_REF_CTRL && mode == WRITE_MODE)
		ref_ctrl_n = data_in;
	else
		ref_ctrl_n = ref_ctrl;
end

/******************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		data_out <= `UD 8'd0;
	else
		data_out <= `UD data_out_n;
end

always @ (*)
begin
	if(sm_cs == SM_DATA0 && mode == READ_MODE)
	begin
		case (addr)
		ADDR_FREQ:		data_out_n = freq[15:8];
		default:			data_out_n = data_out;
		endcase
	end
	else if(sm_cs == SM_DATA1 && mode == READ_MODE)
	begin
		case (addr)
		ADDR_FREQ:		data_out_n = freq[7:0];
		default:			data_out_n = data_out;
		endcase
	end
	else
		data_out_n = data_out;	
end

endmodule
	
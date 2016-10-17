
`define		UD		#1

module	spi
(
	clk,
	rst,
	
	spi_sck,
	spi_sdi,
	spi_sdo,
	
	spi_rx_reg,
	spi_tx_reg,
	
	data_ok
);

input			clk;
input			rst;

input			spi_sck;
input			spi_sdi;
output			spi_sdo;
output			data_ok;

output	[7:0]	spi_rx_reg;
input	[7:0]	spi_tx_reg;

wire		[7:0]	spi_tx_reg;

parameter		MAX_BITS	= 4'd8;

reg		[1:0]	sck_edge;

reg		[7:0]	spi_rx_reg;
reg		[7:0]	spi_rx_reg_n;

reg		[7:0]	spi_tx_buf;
reg		[7:0]	spi_tx_buf_n;

reg		[3:0]	spi_rx_cnt;
reg		[3:0]	spi_rx_cnt_n;

reg				spi_sdo;
reg				spi_sdo_n;


/****** Program start here ******************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		sck_edge <= `UD 2'b00;
	else
		sck_edge <= `UD { sck_edge[0], spi_sck };
end

/****************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		spi_rx_cnt <= `UD 4'd0;
	else
		spi_rx_cnt <= `UD spi_rx_cnt_n;
end

always @ (*)
begin
	if(spi_rx_cnt == MAX_BITS)
		spi_rx_cnt_n = 4'd0;
	else if(sck_edge == 2'b01)
		spi_rx_cnt_n = spi_rx_cnt + 1'b1;
	else
		spi_rx_cnt_n = spi_rx_cnt;		
end

/****************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		spi_rx_reg <= `UD 5'd0;
	else
		spi_rx_reg <= `UD spi_rx_reg_n;
end

always @ (*)
begin
	if(sck_edge == 2'b01)
		spi_rx_reg_n = { spi_rx_reg[6:0], spi_sdi };
	else
		spi_rx_reg_n = spi_rx_reg;
end

/****************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		spi_tx_buf <= `UD 8'h00;
	else
		spi_tx_buf <= `UD spi_tx_buf_n;
end

always @ (*)
begin
	if(spi_rx_cnt == 4'd0)
		spi_tx_buf_n = spi_tx_reg;
	else
		spi_tx_buf_n = spi_tx_buf;
end

/****************************************/
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		spi_sdo <= `UD 1'b0;
	else
		spi_sdo <= `UD spi_sdo_n;
end

always @ (*)
begin
	if(sck_edge == 2'b10)
	begin
		case (spi_rx_cnt)
		4'h0:	spi_sdo_n = spi_tx_buf[7];
		4'h1:	spi_sdo_n = spi_tx_buf[6];
		4'h2:	spi_sdo_n = spi_tx_buf[5];
		4'h3:	spi_sdo_n = spi_tx_buf[4];
		4'h4:	spi_sdo_n = spi_tx_buf[3];
		4'h5:	spi_sdo_n = spi_tx_buf[2];
		4'h6:	spi_sdo_n = spi_tx_buf[1];
		4'h7:	spi_sdo_n = spi_tx_buf[0];
		default:	spi_sdo_n = spi_tx_buf[7];
		endcase
	end
	else if(spi_rx_cnt == 4'h0)
		spi_sdo_n = spi_tx_buf[7];
	else
		spi_sdo_n = spi_sdo;
end

/****************************************/
assign	data_ok = spi_rx_cnt[3];

endmodule
module spi_wrapper(mosi , miso ,ss_n , clk , rst_n);
input mosi , ss_n , clk , rst_n;
output miso;

wire [9:0]rx_data_w;
wire rx_valid_w,tx_valid_w;
wire [7:0]tx_data_w;

spi_slave     spi(.mosi(mosi) ,.miso(miso) ,.ss_n(ss_n) ,.rx_data(rx_data_w) ,.rx_valid(rx_valid_w) ,.tx_data(tx_data_w) ,.tx_valid(tx_valid_w) ,.clk(clk) ,.rst_n(rst_n) );

ram       mem(.din(rx_data_w),.clk(clk),.rst_n(rst_n),.rx_valid(rx_valid_w),.dout(tx_data_w),.tx_valid(tx_valid_w) );

endmodule
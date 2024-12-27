module spi_tb();

reg mosi , ss_n , clk , rst_n;
wire miso;

spi_wrapper tb (mosi , miso , ss_n , clk , rst_n);

initial begin
    clk=0;
    forever
        #1 clk=~clk;
end

integer n;

initial begin
    rst_n=0;
    mosi=1;
    ss_n=0;
    @(negedge clk);

    // write address
    rst_n=1;
    ss_n=0;
    @(negedge clk);

    mosi=0;
    @(negedge clk);

    mosi=0;
    @(negedge clk);

    for(n=0; n<8; n=n+1) begin
        mosi=1;
        @(negedge clk);
    end

    ss_n=1;
    @(negedge clk);

    // write data
    ss_n=0;
    @(negedge clk);

    mosi=0;
    @(negedge clk);

    mosi=0;
    @(negedge clk);
    mosi=1;
    @(negedge clk);

    for(n=0; n<8; n=n+1) begin
        mosi=1;
        @(negedge clk);
    end
    ss_n=1;
    @(negedge clk);

    // read address
    ss_n=0;
    @(negedge clk);

    mosi=1;
    @(negedge clk);

    mosi=1;
    @(negedge clk);

    mosi=0;
    @(negedge clk);

    for(n=0; n<8; n=n+1) begin
        mosi=1;
        @(negedge clk);
    end
    ss_n=1;
    @(negedge clk);
// read data
ss_n=0;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

for(n=0; n<8; n=n+1) begin
    mosi=0;
    @(negedge clk);
end

ss_n=1;
@(negedge clk);

// write add_2
ss_n=0;
@(negedge clk);

mosi=0;
@(negedge clk);

mosi=0;
@(negedge clk);

mosi=1;
repeat(4) @(negedge clk);
mosi=0;
repeat(4) @(negedge clk);
ss_n=1;
@(negedge clk);
// write data_2
ss_n=0;
@(negedge clk);

mosi=0;
@(negedge clk);

mosi=0;
@(negedge clk);
mosi=1;
@(negedge clk);
mosi=0;
repeat(7) @(negedge clk);
mosi=1;
repeat(1) @(negedge clk);

ss_n=1;
@(negedge clk);

// read address_2
ss_n=0;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=0;
@(negedge clk);

mosi=1;
repeat(4) @(negedge clk);
mosi=0;
repeat(4) @(negedge clk);
ss_n=1;
@(negedge clk);
// read data_2
ss_n=0;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

for(n=0; n<8; n=n+1) begin
    mosi=0;
    @(negedge clk);
end

ss_n=1;
@(negedge clk);

// read address_3
ss_n=0;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=0;
@(negedge clk);

mosi=1;
repeat(8) @(negedge clk);
ss_n=1;
@(negedge clk);
// read data_3
ss_n=0;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

mosi=1;
@(negedge clk);

for(n=0; n<8; n=n+1) begin
    mosi=0;
    @(negedge clk);
end

ss_n=1;
@(negedge clk);

$stop;
end

endmodule